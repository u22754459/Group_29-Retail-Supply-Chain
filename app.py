from flask import Flask, render_template, request, jsonify, redirect, url_for, flash, session
import sqlite3
import os
from datetime import datetime
from functools import wraps

app = Flask(__name__)
app.secret_key = 'supplychain-bfb321-2025-secret-key'

# Database configuration
DATABASE = 'inventory.db'

def get_db_connection():
    """Establish database connection with Row factory"""
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    """Initialize database with schema if not exists"""
    if not os.path.exists(DATABASE):
        conn = get_db_connection()
        with open('inventory.sql', 'r') as f:
            conn.executescript(f.read())
        conn.commit()
        conn.close()

# Initialize database on startup
init_db()

# Login required decorator
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please log in to access this page.', 'warning')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

# ============================================
# ROUTES - Main Pages
# ============================================

@app.route('/')
def index():
    """Home page with KPI metrics"""
    conn = get_db_connection()
    
    # Get KPI metrics
    total_orders = conn.execute('SELECT COUNT(*) as count FROM orders').fetchone()['count']
    
    total_products = conn.execute('SELECT COUNT(*) as count FROM products').fetchone()['count']
    
    total_stock = conn.execute('SELECT SUM(quantity) as total FROM products').fetchone()['total'] or 0
    
    low_stock_count = conn.execute(
        'SELECT COUNT(*) as count FROM products WHERE quantity < min_stock_level'
    ).fetchone()['count']
    
    inventory_value = conn.execute(
        'SELECT SUM(quantity * price) as value FROM products'
    ).fetchone()['value'] or 0
    
    avg_rating = conn.execute(
        'SELECT ROUND(AVG(rating), 1) as avg FROM feedback'
    ).fetchone()['avg'] or 0
    
    conn.close()
    
    return render_template('index.html',
                         total_orders=total_orders,
                         total_products=total_products,
                         total_stock=int(total_stock),
                         low_stock_count=low_stock_count,
                         inventory_value=round(inventory_value, 2),
                         avg_rating=avg_rating)

@app.route('/shop', methods=['GET', 'POST'])
def shop():
    """Shop page with product catalog and cart functionality"""
    if request.method == 'POST':
        # Handle add to cart
        action = request.form.get('action')
        
        if action == 'add_to_cart':
            product_id = request.form.get('product_id')
            product_name = request.form.get('product_name')
            price = request.form.get('price')
            
            # In a real app, you'd add to a cart table or session
            flash(f'{product_name} added to cart!', 'success')
            return redirect(url_for('shop'))
    
    # GET request - display products
    conn = get_db_connection()
    products = conn.execute('''
        SELECT p.*, pc.category_name 
        FROM products p 
        LEFT JOIN product_categories pc ON p.category_id = pc.category_id
        ORDER BY p.product_name
    ''').fetchall()
    
    categories = conn.execute(
        'SELECT DISTINCT category_name FROM product_categories ORDER BY category_name'
    ).fetchall()
    
    conn.close()
    
    return render_template('shop.html', products=products, categories=categories)

@app.route('/tracking')
def tracking():
    """Order tracking page with live status"""
    conn = get_db_connection()
    
    # Get all orders with tracking info
    orders = conn.execute('''
        SELECT * FROM orders 
        ORDER BY 
            CASE status
                WHEN 'processing' THEN 1
                WHEN 'in-transit' THEN 2
                WHEN 'delayed' THEN 3
                WHEN 'delivered' THEN 4
                ELSE 5
            END,
            created_at DESC
    ''').fetchall()
    
    # Get KPI metrics
    total_orders = len(orders)
    delivered_count = sum(1 for o in orders if o['status'] == 'delivered')
    on_time_rate = round((delivered_count / total_orders * 100), 1) if total_orders > 0 else 0
    
    conn.close()
    
    return render_template('tracking.html', 
                         orders=orders,
                         total_orders=total_orders,
                         on_time_rate=on_time_rate)

@app.route('/forecast')
def forecast():
    """Demand forecasting page"""
    conn = get_db_connection()
    
    forecasts = conn.execute('''
        SELECT f.*, pc.category_name
        FROM forecasts f
        LEFT JOIN product_categories pc ON f.category_id = pc.category_id
        ORDER BY f.status, f.current_stock
    ''').fetchall()
    
    conn.close()
    
    return render_template('forecast.html', forecasts=forecasts)

@app.route('/customer', methods=['GET', 'POST'])
def customer():
    """Customer feedback and satisfaction portal"""
    if request.method == 'POST':
        # Handle feedback submission
        customer_name = request.form.get('customer_name')
        customer_email = request.form.get('customer_email', '')
        order_number = request.form.get('order_number')
        rating = request.form.get('rating')
        delivery_rating = request.form.get('delivery_rating')
        product_rating = request.form.get('product_rating')
        comment = request.form.get('comment')
        
        conn = get_db_connection()
        try:
            conn.execute('''
                INSERT INTO feedback (customer_name, customer_email, order_number, rating, 
                                    delivery_rating, product_rating, comment, feedback_date, order_status)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            ''', (
                customer_name,
                customer_email,
                order_number,
                int(rating),
                int(delivery_rating),
                int(product_rating),
                comment,
                datetime.now().strftime('%Y-%m-%d'),
                'delivered'
            ))
            conn.commit()
            flash('Thank you for your feedback!', 'success')
        except Exception as e:
            flash(f'Error submitting feedback: {str(e)}', 'danger')
        finally:
            conn.close()
        
        return redirect(url_for('customer'))
    
    # GET request - display feedback
    conn = get_db_connection()
    
    # Get recent feedback
    feedback_list = conn.execute('''
        SELECT * FROM feedback 
        ORDER BY created_at DESC 
        LIMIT 10
    ''').fetchall()
    
    # Get satisfaction metrics
    metrics = conn.execute('''
        SELECT 
            ROUND(AVG(rating), 1) as avg_rating,
            ROUND(AVG(delivery_rating), 1) as avg_delivery,
            ROUND(AVG(product_rating), 1) as avg_product,
            COUNT(*) as total_reviews
        FROM feedback
    ''').fetchone()
    
    conn.close()
    
    return render_template('customer.html', 
                         feedback_list=feedback_list,
                         metrics=metrics)

# ============================================
# ROUTES - Authentication
# ============================================

@app.route('/login', methods=['GET', 'POST'])
def login():
    """User login"""
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        
        conn = get_db_connection()
        user = conn.execute(
            'SELECT * FROM users WHERE email = ?', (email,)
        ).fetchone()
        conn.close()
        
        if user and user['password'] == password:  # In production, use hashed passwords
            session['user_id'] = user['user_id']
            session['user_name'] = user['first_name']
            session['user_type'] = user['user_type']
            flash('Login successful!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Invalid email or password.', 'danger')
    
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    """User registration"""
    if request.method == 'POST':
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        email = request.form.get('email')
        password = request.form.get('password')
        confirm = request.form.get('confirm_password')
        
        if password != confirm:
            flash('Passwords do not match!', 'danger')
            return render_template('signup.html')
        
        conn = get_db_connection()
        
        # Check if email already exists
        existing = conn.execute('SELECT user_id FROM users WHERE email = ?', (email,)).fetchone()
        if existing:
            flash('Email already registered.', 'danger')
            conn.close()
            return render_template('signup.html')
        
        # Create new user
        try:
            conn.execute('''
                INSERT INTO users (first_name, last_name, email, password, user_type)
                VALUES (?, ?, ?, ?, 'customer')
            ''', (first_name, last_name, email, password))
            conn.commit()
            flash('Account created successfully! Please log in.', 'success')
            conn.close()
            return redirect(url_for('login'))
        except Exception as e:
            flash(f'Error creating account: {str(e)}', 'danger')
            conn.close()
    
    return render_template('signup.html')

@app.route('/logout')
def logout():
    """User logout"""
    session.clear()
    flash('You have been logged out.', 'info')
    return redirect(url_for('index'))

# ============================================
# API ENDPOINTS (RESTful)
# ============================================

@app.route('/api/products', methods=['GET'])
def api_get_products():
    """API: Get all products"""
    conn = get_db_connection()
    products = conn.execute('''
        SELECT p.*, pc.category_name 
        FROM products p 
        LEFT JOIN product_categories pc ON p.category_id = pc.category_id
        ORDER BY p.product_name
    ''').fetchall()
    conn.close()
    
    return jsonify([dict(row) for row in products])

@app.route('/api/products/<int:product_id>', methods=['GET'])
def api_get_product(product_id):
    """API: Get single product by ID"""
    conn = get_db_connection()
    product = conn.execute(
        'SELECT * FROM products WHERE product_id = ?', (product_id,)
    ).fetchone()
    conn.close()
    
    if product:
        return jsonify(dict(product))
    return jsonify({'error': 'Product not found'}), 404

@app.route('/api/products', methods=['POST'])
def api_create_product():
    """API: Create new product"""
    data = request.get_json()
    
    conn = get_db_connection()
    try:
        cursor = conn.execute('''
            INSERT INTO products (sku, product_name, category_id, quantity, price, description, supplier, min_stock_level, max_stock_level)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            data['sku'],
            data['product_name'],
            data.get('category_id'),
            data.get('quantity', 0),
            data['price'],
            data.get('description', ''),
            data.get('supplier', ''),
            data.get('min_stock_level', 10),
            data.get('max_stock_level', 100)
        ))
        conn.commit()
        product_id = cursor.lastrowid
        conn.close()
        
        return jsonify({'success': True, 'product_id': product_id}), 201
    except Exception as e:
        conn.close()
        return jsonify({'error': str(e)}), 400

@app.route('/api/orders', methods=['GET'])
def api_get_orders():
    """API: Get all orders"""
    conn = get_db_connection()
    orders = conn.execute('SELECT * FROM orders ORDER BY created_at DESC').fetchall()
    conn.close()
    
    return jsonify([dict(row) for row in orders])

@app.route('/api/orders/<int:order_id>', methods=['GET'])
def api_get_order(order_id):
    """API: Get single order by ID"""
    conn = get_db_connection()
    order = conn.execute('SELECT * FROM orders WHERE order_id = ?', (order_id,)).fetchone()
    conn.close()
    
    if order:
        return jsonify(dict(order))
    return jsonify({'error': 'Order not found'}), 404

@app.route('/api/orders', methods=['POST'])
def api_create_order():
    """API: Create new order"""
    data = request.get_json()
    
    conn = get_db_connection()
    try:
        # Generate order number
        last_order = conn.execute('SELECT order_number FROM orders ORDER BY order_id DESC LIMIT 1').fetchone()
        if last_order:
            num = int(last_order['order_number'].split('-')[1]) + 1
        else:
            num = 1
        order_number = f'ORD-{num:03d}'
        
        cursor = conn.execute('''
            INSERT INTO orders (order_number, customer_name, customer_email, product_name, product_id, quantity, total_amount, status, eta, location, progress)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            order_number,
            data['customer_name'],
            data.get('customer_email', ''),
            data['product_name'],
            data.get('product_id'),
            data.get('quantity', 1),
            data['total_amount'],
            'processing',
            data.get('eta', ''),
            'Warehouse',
            0
        ))
        conn.commit()
        order_id = cursor.lastrowid
        conn.close()
        
        return jsonify({'success': True, 'order_id': order_id, 'order_number': order_number}), 201
    except Exception as e:
        conn.close()
        return jsonify({'error': str(e)}), 400

@app.route('/api/orders/<int:order_id>/status', methods=['PUT'])
def api_update_order_status(order_id):
    """API: Update order status"""
    data = request.get_json()
    
    conn = get_db_connection()
    try:
        conn.execute('''
            UPDATE orders 
            SET status = ?, location = ?, progress = ?, updated_at = CURRENT_TIMESTAMP
            WHERE order_id = ?
        ''', (data['status'], data.get('location', ''), data.get('progress', 0), order_id))
        conn.commit()
        conn.close()
        
        return jsonify({'success': True, 'message': 'Order status updated'})
    except Exception as e:
        conn.close()
        return jsonify({'error': str(e)}), 400

@app.route('/api/feedback', methods=['POST'])
def api_submit_feedback():
    """API: Submit customer feedback"""
    data = request.get_json()
    
    conn = get_db_connection()
    try:
        conn.execute('''
            INSERT INTO feedback (customer_name, customer_email, order_number, rating, delivery_rating, product_rating, comment, feedback_date, order_status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            data['customer_name'],
            data.get('customer_email', ''),
            data['order_number'],
            data['rating'],
            data['delivery_rating'],
            data['product_rating'],
            data['comment'],
            datetime.now().strftime('%Y-%m-%d'),
            data.get('order_status', 'delivered')
        ))
        conn.commit()
        conn.close()
        
        return jsonify({'success': True, 'message': 'Feedback submitted successfully'}), 201
    except Exception as e:
        conn.close()
        return jsonify({'error': str(e)}), 400

@app.route('/api/dashboard/metrics', methods=['GET'])
def api_dashboard_metrics():
    """API: Get dashboard KPI metrics"""
    conn = get_db_connection()
    
    metrics = {
        'total_orders': conn.execute('SELECT COUNT(*) as count FROM orders').fetchone()['count'],
        'total_products': conn.execute('SELECT COUNT(*) as count FROM products').fetchone()['count'],
        'total_stock': conn.execute('SELECT SUM(quantity) as total FROM products').fetchone()['total'] or 0,
        'low_stock_count': conn.execute('SELECT COUNT(*) as count FROM products WHERE quantity < min_stock_level').fetchone()['count'],
        'inventory_value': round(conn.execute('SELECT SUM(quantity * price) as value FROM products').fetchone()['value'] or 0, 2),
        'avg_rating': conn.execute('SELECT ROUND(AVG(rating), 1) as avg FROM feedback').fetchone()['avg'] or 0,
        'on_time_delivery': 87.5,
        'avg_delivery_time': 2.8
    }
    
    conn.close()
    
    return jsonify(metrics)

# ============================================
# Error Handlers
# ============================================

@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404

@app.errorhandler(500)
def internal_error(error):
    return render_template('500.html'), 500

# ============================================
# Main Execution
# ============================================

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
