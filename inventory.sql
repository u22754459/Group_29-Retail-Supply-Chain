-- Supply Chain Management System - SQLite Database Schema
-- Database: inventory.db
-- BFB 321 Project Team: D Tsebe | M Thebe | P Mkhwanazi | K Mokone | A Majova
-- University of Pretoria - 2025

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS stock_updates;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS forecasts;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS product_categories;

-- ============================================
-- Create product_categories table
-- ============================================
CREATE TABLE product_categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT NOT NULL UNIQUE,
    category_description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Create users table (for customer and vendor accounts)
-- ============================================
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    address TEXT,
    password TEXT NOT NULL,
    user_type TEXT NOT NULL CHECK (user_type IN ('customer', 'vendor', 'admin')) DEFAULT 'customer',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Create products table
-- ============================================
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    sku TEXT UNIQUE NOT NULL,
    product_name TEXT NOT NULL,
    category_id INTEGER,
    quantity INTEGER NOT NULL DEFAULT 0,
    price REAL NOT NULL CHECK (price >= 0),
    emoji TEXT,
    description TEXT,
    supplier TEXT,
    min_stock_level INTEGER DEFAULT 10,
    max_stock_level INTEGER DEFAULT 100,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id)
);

-- ============================================
-- Create orders table
-- ============================================
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_number TEXT UNIQUE NOT NULL,
    customer_name TEXT NOT NULL,
    customer_email TEXT,
    product_name TEXT NOT NULL,
    product_id INTEGER,
    quantity INTEGER NOT NULL DEFAULT 1,
    total_amount REAL NOT NULL DEFAULT 0,
    status TEXT NOT NULL CHECK(status IN ('processing', 'in-transit', 'delivered', 'delayed', 'cancelled')) DEFAULT 'processing',
    eta TEXT,
    location TEXT,
    progress INTEGER DEFAULT 0 CHECK(progress >= 0 AND progress <= 100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ============================================
-- Create forecasts table
-- ============================================
CREATE TABLE forecasts (
    forecast_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER NOT NULL,
    category_name TEXT NOT NULL,
    current_stock INTEGER NOT NULL,
    forecast_demand INTEGER NOT NULL,
    status TEXT NOT NULL CHECK(status IN ('low', 'optimal', 'high')) DEFAULT 'optimal',
    reorder_point INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id)
);

-- ============================================
-- Create feedback table
-- ============================================
CREATE TABLE feedback (
    feedback_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_name TEXT NOT NULL,
    customer_email TEXT,
    order_number TEXT NOT NULL,
    rating INTEGER NOT NULL CHECK(rating >= 1 AND rating <= 5),
    delivery_rating INTEGER NOT NULL CHECK(delivery_rating >= 1 AND delivery_rating <= 5),
    product_rating INTEGER NOT NULL CHECK(product_rating >= 1 AND product_rating <= 5),
    comment TEXT NOT NULL,
    feedback_date TEXT NOT NULL,
    order_status TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_number) REFERENCES orders(order_number)
);

-- ============================================
-- Create stock_updates table (for tracking inventory changes)
-- ============================================
CREATE TABLE stock_updates (
    update_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    user_id INTEGER,
    update_type TEXT NOT NULL CHECK (update_type IN ('add', 'remove', 'set', 'adjustment')),
    quantity_change INTEGER NOT NULL,
    old_quantity INTEGER NOT NULL,
    new_quantity INTEGER NOT NULL,
    reason TEXT NOT NULL CHECK (reason IN ('restock', 'sale', 'damage', 'return', 'adjustment', 'order', 'other')),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ============================================
-- Insert sample product categories
-- ============================================
INSERT INTO product_categories (category_name, category_description) VALUES
('Electronics', 'Electronic devices, smartphones, and gadgets'),
('Clothing', 'Apparel, fashion items, and footwear'),
('Books', 'Books, publications, and educational materials'),
('Beauty', 'Beauty products, cosmetics, and skincare'),
('Sports', 'Sports equipment, fitness gear, and outdoor items'),
('Home', 'Home appliances, furniture, and household items'),
('Food & Beverages', 'Food products and beverages'),
('Tools & Hardware', 'Tools, hardware, and construction supplies');

-- ============================================
-- Insert sample users
-- ============================================
INSERT INTO users (first_name, last_name, email, phone, address, password, user_type) VALUES
('Katlego', 'Mokone', 'katlego.mokone@example.com', '+27 82 123 4567', '123 Main St, Johannesburg', 'password123', 'customer'),
('Phumi', 'Mkhwanazi', 'phumi.mkhwanazi@example.com', '+27 83 234 5678', '456 Oak Ave, Pretoria', 'password123', 'customer'),
('Mamoshoeshoe', 'Thebe', 'mamoshoeshoe.thebe@example.com', '+27 84 345 6789', '789 Pine Rd, Cape Town', 'password123', 'customer'),
('Dineo', 'Tsebe', 'dineo.tsebe@example.com', '+27 85 456 7890', '321 Elm St, Durban', 'password123', 'customer'),
('Alulutho', 'Majova', 'alulutho.majova@example.com', '+27 86 567 8901', '654 Maple Dr, Bloemfontein', 'password123', 'customer'),
('Thabang', 'Ngwenya', 'thabang.ngwenya@example.com', '+27 87 678 9012', '987 Cedar Ln, Port Elizabeth', 'password123', 'customer'),
('Ibrahim', 'Akanbi', 'ibrahim.akanbi@example.com', '+27 88 789 0123', '147 Birch Ave, Polokwane', 'password123', 'customer'),
('Admin', 'User', 'admin@supplychain.com', '+27 63 049 0645', 'University of Pretoria', 'admin123', 'admin'),
('Vendor', 'Manager', 'vendor@supplychain.com', '+27 11 234 5678', 'Warehouse District, Johannesburg', 'vendor123', 'vendor');

-- ============================================
-- Insert sample products with corresponding categories
-- ============================================
INSERT INTO products (sku, product_name, category_id, quantity, price, emoji, description, supplier, min_stock_level, max_stock_level) VALUES
('ELEC-001', 'Samsung Galaxy S23', 1, 248, 899.99, '📱', 'Latest smartphone with advanced camera', 'Samsung Electronics', 50, 500),
('ELEC-002', 'iPhone 14 Pro', 1, 150, 999.00, '📱', 'Apple flagship with ProRAW', 'Apple Inc.', 30, 300),
('ELEC-003', 'AirPods Pro', 1, 95, 249.00, '🎧', 'Wireless earbuds with ANC', 'Apple Inc.', 20, 200),
('ELEC-004', 'MacBook Pro M2', 1, 75, 1999.00, '💻', 'Professional laptop with M2 chip', 'Apple Inc.', 15, 150),
('ELEC-005', 'iPad Air', 1, 120, 599.00, '📱', 'Versatile tablet for work and play', 'Apple Inc.', 25, 250),
('CLOTH-001', 'Nike Air Max', 2, 0, 120.00, '👟', 'Premium running shoes', 'Nike Inc.', 20, 200),
('CLOTH-002', 'Adidas Hoodie', 2, 200, 65.00, '👕', 'Comfortable sportswear', 'Adidas Group', 30, 300),
('CLOTH-003', 'Levi''s Jeans', 2, 150, 89.99, '👖', 'Classic denim jeans', 'Levi Strauss & Co.', 25, 250),
('CLOTH-004', 'Nike T-Shirt', 2, 300, 35.00, '👕', 'Cotton athletic t-shirt', 'Nike Inc.', 50, 500),
('BOOK-001', 'JavaScript Guide', 3, 180, 45.99, '📚', 'Complete programming guide', 'O''Reilly Media', 30, 300),
('BOOK-002', 'Python Basics', 3, 95, 39.99, '📚', 'Learn Python from scratch', 'Pearson Education', 20, 200),
('BOOK-003', 'Data Science 101', 3, 120, 55.00, '📚', 'Introduction to data science', 'Wiley Publishing', 25, 250),
('BEAU-001', 'Moisturizing Cream', 4, 210, 24.99, '💄', 'Daily skincare essential', 'Beauty Supplies Ltd', 40, 400),
('BEAU-002', 'Facial Cleanser', 4, 180, 18.99, '💄', 'Gentle face wash', 'Beauty Supplies Ltd', 35, 350),
('BEAU-003', 'Lipstick Set', 4, 150, 32.00, '💄', 'Assorted colors', 'Cosmetics International', 30, 300),
('SPORT-001', 'Yoga Mat', 5, 120, 39.99, '🧘', 'Non-slip premium mat', 'Fitness World', 25, 250),
('SPORT-002', 'Dumbbell Set', 5, 65, 89.99, '🏋️', 'Adjustable weights', 'Sports Equipment Co', 15, 150),
('SPORT-003', 'Running Shoes', 5, 95, 110.00, '👟', 'Lightweight performance', 'Athletic Gear Ltd', 20, 200),
('HOME-001', 'Coffee Maker', 6, 45, 79.99, '☕', 'Automatic drip maker', 'Home Appliances Inc', 10, 100),
('HOME-002', 'Blender', 6, 88, 59.99, '🍹', 'High-speed blender', 'Kitchen Solutions', 15, 150),
('HOME-003', 'Air Fryer', 6, 72, 129.99, '🍟', 'Healthy cooking appliance', 'Kitchen Solutions', 15, 150);

-- ============================================
-- Insert sample orders
-- ============================================
INSERT INTO orders (order_number, customer_name, customer_email, product_name, product_id, quantity, total_amount, status, eta, location, progress) VALUES
('ORD-001', 'Katlego Mokone', 'katlego.mokone@example.com', 'Samsung Galaxy S23', 1, 1, 899.99, 'in-transit', '2025-10-23', 'Johannesburg Hub', 65),
('ORD-002', 'Phumi Mkhwanazi', 'phumi.mkhwanazi@example.com', 'iPhone 14 Pro', 2, 1, 999.00, 'processing', '2025-10-24', 'Warehouse', 30),
('ORD-003', 'Mamoshoeshoe Thebe', 'mamoshoeshoe.thebe@example.com', 'AirPods Pro', 3, 1, 249.00, 'delivered', '2025-10-20', 'Delivered', 100),
('ORD-004', 'Dineo Tsebe', 'dineo.tsebe@example.com', 'Nike Air Max', 6, 1, 120.00, 'delayed', '2025-10-22', 'Pretoria Depot', 45),
('ORD-005', 'Alulutho Majova', 'alulutho.majova@example.com', 'MacBook Pro M2', 4, 1, 1999.00, 'in-transit', '2025-10-25', 'Cape Town Hub', 55),
('ORD-006', 'Thabang Ngwenya', 'thabang.ngwenya@example.com', 'Adidas Hoodie', 7, 2, 130.00, 'delivered', '2025-10-18', 'Delivered', 100),
('ORD-007', 'Ibrahim Akanbi', 'ibrahim.akanbi@example.com', 'JavaScript Guide', 10, 1, 45.99, 'processing', '2025-10-26', 'Warehouse', 20),
('ORD-008', 'Katlego Mokone', 'katlego.mokone@example.com', 'Yoga Mat', 16, 1, 39.99, 'in-transit', '2025-10-24', 'Durban Hub', 70),
('ORD-009', 'Phumi Mkhwanazi', 'phumi.mkhwanazi@example.com', 'Coffee Maker', 19, 1, 79.99, 'delivered', '2025-10-19', 'Delivered', 100),
('ORD-010', 'Mamoshoeshoe Thebe', 'mamoshoeshoe.thebe@example.com', 'Moisturizing Cream', 13, 3, 74.97, 'processing', '2025-10-25', 'Warehouse', 15);

-- ============================================
-- Insert sample forecasts
-- ============================================
INSERT INTO forecasts (category_id, category_name, current_stock, forecast_demand, status, reorder_point) VALUES
(1, 'Electronics', 688, 850, 'low', 750),
(2, 'Clothing', 650, 580, 'optimal', 500),
(3, 'Books', 395, 450, 'low', 400),
(4, 'Beauty', 540, 480, 'optimal', 450),
(5, 'Sports', 280, 340, 'low', 320),
(6, 'Home', 205, 220, 'optimal', 200);

-- ============================================
-- Insert sample feedback
-- ============================================
INSERT INTO feedback (customer_name, customer_email, order_number, rating, delivery_rating, product_rating, comment, feedback_date, order_status) VALUES
('Alulutho Majova', 'alulutho.majova@example.com', 'ORD-003', 5, 5, 5, 'Fast delivery and accurate order!', '2025-10-20', 'delivered'),
('Thabang Ngwenya', 'thabang.ngwenya@example.com', 'ORD-006', 4, 4, 5, 'Good service, minor delay but excellent product quality', '2025-10-19', 'delivered'),
('Ibrahim Akanbi', 'ibrahim.akanbi@example.com', 'ORD-004', 3, 2, 4, 'Wrong size received, but quick replacement process', '2025-10-18', 'returned'),
('Katlego Mokone', 'katlego.mokone@example.com', 'ORD-008', 5, 5, 5, 'Perfect! Arrived on time and exactly as described', '2025-10-21', 'delivered'),
('Phumi Mkhwanazi', 'phumi.mkhwanazi@example.com', 'ORD-009', 4, 5, 4, 'Great delivery service, product works well', '2025-10-19', 'delivered'),
('Mamoshoeshoe Thebe', 'mamoshoeshoe.thebe@example.com', 'ORD-003', 5, 4, 5, 'Love the product! Delivery was one day late but acceptable', '2025-10-18', 'delivered'),
('Katlego Mokone', 'katlego.mokone@example.com', 'ORD-001', 5, 5, 5, 'Excellent tracking system, kept me informed throughout', '2025-10-22', 'delivered'),
('Phumi Mkhwanazi', 'phumi.mkhwanazi@example.com', 'ORD-002', 4, 3, 5, 'Product is great but took longer than expected', '2025-10-20', 'delivered');

-- ============================================
-- Insert sample stock updates to show activity history
-- ============================================
INSERT INTO stock_updates (product_id, user_id, update_type, quantity_change, old_quantity, new_quantity, reason, notes) VALUES
(1, 9, 'add', 50, 198, 248, 'restock', 'Received new shipment from Samsung'),
(3, 9, 'remove', 2, 97, 95, 'sale', 'Sold 2 units to walk-in customer'),
(2, 9, 'remove', 1, 151, 150, 'order', 'Online order ORD-002'),
(6, 9, 'remove', 5, 5, 0, 'sale', 'Final units sold during clearance'),
(1, 9, 'remove', 3, 251, 248, 'damage', '3 units damaged in shipping, returned to supplier'),
(10, 9, 'add', 20, 160, 180, 'restock', 'Monthly book inventory replenishment'),
(16, 9, 'remove', 1, 121, 120, 'order', 'Order ORD-008 - Yoga Mat'),
(19, 9, 'remove', 1, 46, 45, 'order', 'Order ORD-009 - Coffee Maker');

-- ============================================
-- Create Indexes for Performance Optimization
-- ============================================
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_quantity ON products(quantity);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_customer ON orders(customer_name);
CREATE INDEX idx_orders_order_number ON orders(order_number);
CREATE INDEX idx_feedback_order_num ON feedback(order_number);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_type ON users(user_type);
CREATE INDEX idx_forecasts_category ON forecasts(category_id);
CREATE INDEX idx_stock_updates_product ON stock_updates(product_id);

-- ============================================
-- Create Views for Analytics and Reporting
-- ============================================

-- View: Order Statistics by Status
CREATE VIEW order_statistics AS
SELECT 
    status,
    COUNT(*) as order_count,
    ROUND(AVG(progress), 2) as avg_progress,
    ROUND(SUM(total_amount), 2) as total_revenue
FROM orders
GROUP BY status;

-- View: Product Inventory Summary by Category
CREATE VIEW inventory_summary AS
SELECT 
    pc.category_name,
    COUNT(p.product_id) as product_count,
    SUM(p.quantity) as total_stock,
    ROUND(AVG(p.price), 2) as avg_price,
    ROUND(SUM(p.quantity * p.price), 2) as inventory_value
FROM products p
JOIN product_categories pc ON p.category_id = pc.category_id
GROUP BY pc.category_name;

-- View: Customer Satisfaction Metrics
CREATE VIEW satisfaction_metrics AS
SELECT 
    ROUND(AVG(rating), 2) as avg_overall_rating,
    ROUND(AVG(delivery_rating), 2) as avg_delivery_rating,
    ROUND(AVG(product_rating), 2) as avg_product_rating,
    COUNT(*) as total_feedback,
    COUNT(CASE WHEN rating >= 4 THEN 1 END) as positive_reviews,
    COUNT(CASE WHEN rating <= 2 THEN 1 END) as negative_reviews
FROM feedback;

-- View: Low Stock Alert with Category Information
CREATE VIEW low_stock_alert AS
SELECT 
    p.sku,
    p.product_name,
    pc.category_name,
    p.quantity as current_stock,
    p.min_stock_level,
    (p.min_stock_level - p.quantity) as units_needed,
    CASE 
        WHEN p.quantity = 0 THEN 'OUT OF STOCK'
        WHEN p.quantity < (p.min_stock_level * 0.5) THEN 'CRITICAL'
        WHEN p.quantity < p.min_stock_level THEN 'LOW'
        ELSE 'ADEQUATE'
    END as stock_status
FROM products p
JOIN product_categories pc ON p.category_id = pc.category_id
WHERE p.quantity < p.min_stock_level
ORDER BY p.quantity ASC;

-- View: Sales Performance by Product
CREATE VIEW sales_performance AS
SELECT 
    p.product_name,
    pc.category_name,
    COUNT(o.order_id) as units_sold,
    ROUND(SUM(o.total_amount), 2) as total_sales,
    ROUND(AVG(o.total_amount), 2) as avg_order_value
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN product_categories pc ON p.category_id = pc.category_id
GROUP BY p.product_name, pc.category_name
ORDER BY total_sales DESC;

-- View: Stock Movement History
CREATE VIEW stock_movement_history AS
SELECT 
    su.update_id,
    p.sku,
    p.product_name,
    u.first_name || ' ' || u.last_name as updated_by,
    su.update_type,
    su.quantity_change,
    su.old_quantity,
    su.new_quantity,
    su.reason,
    su.notes,
    su.created_at
FROM stock_updates su
JOIN products p ON su.product_id = p.product_id
LEFT JOIN users u ON su.user_id = u.user_id
ORDER BY su.created_at DESC;

-- ============================================
-- Sample Queries (Comments for reference)
-- ============================================

/*
-- Get all orders for a specific customer
SELECT * FROM orders WHERE customer_name = 'Katlego Mokone';

-- Get products by category with stock levels
SELECT p.product_name, p.quantity, p.price, pc.category_name 
FROM products p
JOIN product_categories pc ON p.category_id = pc.category_id
WHERE pc.category_name = 'Electronics';

-- Get average ratings by order status
SELECT o.status, AVG(f.rating) as avg_rating 
FROM feedback f
JOIN orders o ON f.order_number = o.order_number
GROUP BY o.status;

-- Get inventory reorder recommendations
SELECT 
    f.category_name, 
    f.current_stock, 
    f.forecast_demand, 
    f.reorder_point,
    (f.forecast_demand - f.current_stock) as units_needed
FROM forecasts f
WHERE f.current_stock < f.reorder_point;

-- Get top rated products through feedback
SELECT 
    o.product_name, 
    AVG(f.product_rating) as avg_rating, 
    COUNT(*) as review_count
FROM feedback f
JOIN orders o ON f.order_number = o.order_number
GROUP BY o.product_name
ORDER BY avg_rating DESC, review_count DESC;

-- Calculate on-time delivery percentage
SELECT 
    ROUND(
        (SUM(CASE WHEN status = 'delivered' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) as on_time_percentage
FROM orders;

-- Get customer order history with totals
SELECT 
    customer_name,
    COUNT(*) as total_orders,
    SUM(total_amount) as lifetime_value,
    AVG(total_amount) as avg_order_value
FROM orders
GROUP BY customer_name
ORDER BY lifetime_value DESC;

-- Stock turnover analysis
SELECT 
    p.product_name,
    p.quantity as current_stock,
    COUNT(su.update_id) as total_transactions,
    SUM(CASE WHEN su.update_type = 'remove' AND su.reason = 'sale' THEN su.quantity_change ELSE 0 END) as units_sold
FROM products p
LEFT JOIN stock_updates su ON p.product_id = su.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC;
*/

-- ============================================
-- Database Information and Documentation
-- ============================================
-- Database: SupplyChain Master Management System
-- Team Members: D Tsebe, M Thebe, P Mkhwanazi, K Mokone, A Majova
-- Project: BFB 321 - Supply Chain Management System
-- Institution: University of Pretoria
-- Academic Year: 2025
-- Contact: BFB321@gmail.com | +27 63 049 0645
-- ============================================