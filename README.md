# Group_29-Retail-Supply-Chain
## SupplyChain Master

## Project Description

SupplyChain Master is a comprehensive supply chain management platform designed to optimize logistics operations and enhance customer satisfaction. The system addresses critical supply chain inefficiencies by providing real-time order tracking, demand forecasting, and customer feedback management.

### Key Features
- **Real-Time Order Tracking**: Live status updates and progress monitoring for all orders
- **Demand Forecasting**: AI-powered inventory predictions to optimize stock levels
- **Customer Portal**: Feedback submission and satisfaction tracking
- **E-commerce Shop**: Product catalog with shopping cart functionality
- **Performance Metrics**: KPI dashboards for delivery times, accuracy, and customer satisfaction
- **User Authentication**: Secure login and signup system with session management


---

## Team Members

| Name | Student Number | 
|------|----------------|
| D Tsebe | u22729951 |
| M Thebe | u22754459 | 
| P Mkhwanazi | u21518689| 
| K Mokone | u23655144 |  

**Course**: BFB 321 Project  
**Institution**: University of Pretoria  
**Year**: 2025

---

## Technology Stack

### Backend
- **Framework**: Flask (Python web framework)
- **Database**: SQLite with Row factory for dict-like access
- **Session Management**: Flask sessions with secret key
- **API**: RESTful API endpoints

### Frontend
- **HTML5**: Semantic markup
- **CSS3**: Custom styling with Bootstrap integration
- **Bootstrap 5.3.2**: Responsive UI framework
- **Bootstrap Icons 1.11.1**: Icon library

### Database
- **SQLite**: Lightweight, file-based database
- **SQL.js**: Client-side SQLite support
- **Indexes**: Optimized queries for performance
- **Views**: Pre-built analytics and reporting queries

---

## Installation & Setup Instructions

### Prerequisites
- Python 3.8 or higher
- pip (Python package installer)
- Modern web browser (Chrome, Firefox, Safari, or Edge)

### Setup Steps

1. **Clone the Repository**
   ```bash
   git clone [repository-url]
   cd supplychain-master
   ```

2. **Install Python Dependencies**
   ```bash
   pip install flask
   ```

3. **Project Structure**
   ```
   supplychain-master/
   ├── app.py                  # Flask application
   ├── inventory.sql           # Database schema
   ├── inventory.db            # SQLite database (auto-created)
   ├── templates/              # HTML templates
   │   ├── index.html
   │   ├── shop.html
   │   ├── tracking.html
   │   ├── forecast.html
   │   ├── customer.html
   │   ├── login.html
   │   └── signup.html
   └── README.md
   ```

4. **Initialize the Database**
   The database is automatically initialized when you first run the application. The `init_db()` function creates the database from `inventory.sql` if it doesn't exist.

5. **Run the Application**
   ```bash
   python app.py
   ```
   The application will start on `http://localhost:5000`

6. **Access the Application**
   - Open your browser and navigate to `http://localhost:5000`
   - The home page will display with KPI metrics
   - Navigate through different sections using the navigation bar

### Default User Accounts

The system comes pre-populated with sample user accounts:

| Email | Password | Type |
|-------|----------|------|
| admin@supplychain.com | admin123 | Admin |
| vendor@supplychain.com | vendor123 | Vendor |
| katlego.mokone@example.com | password123 | Customer |

### Browser Compatibility
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

---

## Application Features

### 1. Home Dashboard (`/`)
- Real-time KPI metrics display
- Total orders, products, and stock levels
- Low stock alerts
- Inventory value calculation
- Average customer rating

### 2. Shop (`/shop`)
- Product catalog with categories
- Filter by category (Electronics, Clothing, Books, Beauty, Sports, Home)
- Stock availability display
- Add to cart functionality
- Product details with SKU, price, and descriptions

### 3. Order Tracking (`/tracking`)
- Real-time order status updates
- Progress bar visualization (0-100%)
- Location tracking
- Estimated delivery dates (ETA)
- Order status categories: processing, in-transit, delivered, delayed, cancelled
- Performance metrics: on-time delivery rate, average delivery time

### 4. Demand Forecasting (`/forecast`)
- Category-based inventory predictions
- Current stock vs. forecasted demand
- Reorder point recommendations
- Status indicators: low, optimal, high
- Automated restocking suggestions

### 5. Customer Portal (`/customer`)
- Submit feedback for orders
- View recent customer reviews
- Multi-dimensional ratings (overall, delivery, product)
- Performance improvement tracking
- Contact support information

### 6. Authentication
- **Login** (`/login`): User authentication with email and password
- **Signup** (`/signup`): New user registration
- **Logout** (`/logout`): Session termination
- Session management with Flask sessions

---

## API Endpoints

### Products API

#### Get All Products
```http
GET /api/products
```
Returns all products with category information.

#### Get Single Product
```http
GET /api/products/<product_id>
```
Returns details for a specific product.

#### Create Product
```http
POST /api/products
Content-Type: application/json

{
  "sku": "PROD-001",
  "product_name": "Product Name",
  "category_id": 1,
  "quantity": 100,
  "price": 99.99,
  "description": "Product description",
  "supplier": "Supplier Name",
  "min_stock_level": 10,
  "max_stock_level": 500
}
```

### Orders API

#### Get All Orders
```http
GET /api/orders
```
Returns all orders sorted by creation date.

#### Get Single Order
```http
GET /api/orders/<order_id>
```
Returns details for a specific order.

#### Create Order
```http
POST /api/orders
Content-Type: application/json

{
  "customer_name": "John Doe",
  "customer_email": "john@example.com",
  "product_name": "Samsung Galaxy S23",
  "product_id": 1,
  "quantity": 1,
  "total_amount": 899.99
}
```

#### Update Order Status
```http
PUT /api/orders/<order_id>/status
Content-Type: application/json

{
  "status": "in-transit",
  "location": "Johannesburg Hub",
  "progress": 65
}
```

### Feedback API

#### Submit Feedback
```http
POST /api/feedback
Content-Type: application/json

{
  "customer_name": "John Doe",
  "customer_email": "john@example.com",
  "order_number": "ORD-001",
  "rating": 5,
  "delivery_rating": 5,
  "product_rating": 5,
  "comment": "Excellent service!",
  "order_status": "delivered"
}
```

### Dashboard API

#### Get Dashboard Metrics
```http
GET /api/dashboard/metrics
```
Returns all KPI metrics for the dashboard.

---

## Database Schema

### Entity Relationship Diagram (ERD)

```
┌─────────────────┐         ┌─────────────────┐
│     USERS       │         │    PRODUCTS     │
├─────────────────┤         ├─────────────────┤
│ user_id (PK)    │         │ product_id (PK) │
│ name            │         │ sku             │
│ email           │         │ name            │
│ password        │         │ category        │
│ created_at      │         │ price           │
└────────┬────────┘         │ stock           │
         │                  │ description     │
         │                  └────────┬────────┘
         │                           │
         │                           │
         │                  ┌────────┴────────┐
         │                  │                 │
         │         ┌────────▼────────┐  ┌────▼──────────┐
         │         │     ORDERS      │  │   FORECASTS   │
         │         ├─────────────────┤  ├───────────────┤
         └────────►│ order_id (PK)   │  │ forecast_id   │
                   │ order_number    │  │ category      │
                   │ customer (FK)   │  │ current_stock │
                   │ product (FK)    │  │ forecast      │
                   │ status          │  │ status        │
                   │ eta             │  │ reorder       │
                   │ location        │  └───────────────┘
                   │ progress        │
                   └────────┬────────┘
                            │
                            │
                   ┌────────▼────────┐
                   │    FEEDBACK     │
                   ├─────────────────┤
                   │ feedback_id(PK) │
                   │ customer (FK)   │
                   │ order_num (FK)  │
                   │ rating          │
                   │ delivery_rating │
                   │ product_rating  │
                   │ comment         │
                   │ date            │
                   │ status          │
                   └─────────────────┘
```

### Table Relationships

#### 1. USERS ↔ ORDERS
**Relationship Type**: One-to-Many  
**Description**: One user can place multiple orders  
**Foreign Key**: `ORDERS.customer` references `USERS.name`  
**Cardinality**: 1:N

```sql
-- A user can have multiple orders
SELECT u.name, COUNT(o.order_id) as total_orders
FROM users u
LEFT JOIN orders o ON u.name = o.customer
GROUP BY u.name;
```

**Business Rules**:
- A user must exist before placing an order
- A user can have zero or more orders
- Each order must belong to exactly one user
- Deleting a user should handle associated orders (cascade or restrict)

---

#### 2. PRODUCTS ↔ ORDERS
**Relationship Type**: One-to-Many  
**Description**: One product can appear in multiple orders  
**Foreign Key**: `ORDERS.product` references `PRODUCTS.name`  
**Cardinality**: 1:N

```sql
-- Track which products are most ordered
SELECT p.name, p.category, COUNT(o.order_id) as times_ordered
FROM products p
LEFT JOIN orders o ON p.name = o.product
GROUP BY p.name, p.category
ORDER BY times_ordered DESC;
```

**Business Rules**:
- A product must exist in catalog before being ordered
- A product can be in zero or more orders
- Each order references exactly one product
- Product stock should decrease when order is placed
- Product cannot be deleted if active orders exist

---

#### 3. ORDERS ↔ FEEDBACK
**Relationship Type**: One-to-One  
**Description**: Each order can have one feedback entry  
**Foreign Key**: `FEEDBACK.order_num` references `ORDERS.order_number`  
**Cardinality**: 1:1

```sql
-- Get orders with their feedback
SELECT o.order_number, o.product, o.status,
       f.rating, f.delivery_rating, f.product_rating, f.comment
FROM orders o
LEFT JOIN feedback f ON o.order_number = f.order_num;
```

**Business Rules**:
- Feedback can only be submitted for existing orders
- Each order can have at most one feedback entry
- Feedback is typically submitted after order is delivered
- Feedback customer should match order customer
- Orders without feedback are allowed (not all customers provide feedback)

---

#### 4. USERS ↔ FEEDBACK
**Relationship Type**: One-to-Many  
**Description**: One user can submit multiple feedback entries  
**Foreign Key**: `FEEDBACK.customer` references `USERS.name`  
**Cardinality**: 1:N

```sql
-- Get all feedback from a specific user
SELECT f.order_num, f.rating, f.comment, f.date
FROM feedback f
JOIN users u ON f.customer = u.name
WHERE u.name = 'Alulutho Majova';
```

**Business Rules**:
- Only registered users can submit feedback
- A user can submit feedback for multiple orders
- Each feedback entry belongs to exactly one user
- User information in feedback should match order information

---

#### 5. PRODUCTS ↔ FORECASTS
**Relationship Type**: One-to-Many (Categorical)  
**Description**: Products are grouped by category for forecasting  
**Foreign Key**: `FORECASTS.category` references `PRODUCTS.category`  
**Cardinality**: N:1

```sql
-- Compare product inventory to forecast recommendations
SELECT p.category, 
       SUM(p.stock) as total_stock,
       f.forecast as predicted_demand,
       f.reorder as reorder_point,
       f.status
FROM products p
JOIN forecasts f ON p.category = f.category
GROUP BY p.category, f.forecast, f.reorder, f.status;
```

**Business Rules**:
- Forecasts are generated per category, not per individual product
- Multiple products can belong to the same forecast category
- Each forecast entry represents one product category
- Stock levels across all products in a category determine forecast status
- Reorder recommendations apply to the entire category

---

### Relationship Summary Table

| Relationship | Type | Foreign Key | Cascade Behavior | Description |
|--------------|------|-------------|------------------|-------------|
| USERS → ORDERS | 1:N | customer | CASCADE/RESTRICT | Users place orders |
| PRODUCTS → ORDERS | 1:N | product | RESTRICT | Products are ordered |
| ORDERS → FEEDBACK | 1:1 | order_num | CASCADE | Orders receive feedback |
| USERS → FEEDBACK | 1:N | customer | CASCADE | Users submit feedback |
| PRODUCTS → FORECASTS | N:1 | category | CASCADE | Products grouped for forecasting |

### Referential Integrity Constraints

```sql
-- Add foreign key constraints (if using full SQL database)

-- Orders references Users
ALTER TABLE orders 
ADD CONSTRAINT fk_orders_customer 
FOREIGN KEY (customer) REFERENCES users(name)
ON DELETE CASCADE;

-- Orders references Products
ALTER TABLE orders 
ADD CONSTRAINT fk_orders_product 
FOREIGN KEY (product) REFERENCES products(name)
ON DELETE RESTRICT;

-- Feedback references Orders
ALTER TABLE feedback 
ADD CONSTRAINT fk_feedback_order 
FOREIGN KEY (order_num) REFERENCES orders(order_number)
ON DELETE CASCADE;

-- Feedback references Users
ALTER TABLE feedback 
ADD CONSTRAINT fk_feedback_customer 
FOREIGN KEY (customer) REFERENCES users(name)
ON DELETE CASCADE;

-- Forecasts references Products (category level)
ALTER TABLE forecasts 
ADD CONSTRAINT fk_forecasts_category 
FOREIGN KEY (category) REFERENCES products(category)
ON DELETE CASCADE;
```

### Data Flow Diagram

```
┌──────────┐
│  User    │
│ (Login)  │
└────┬─────┘
     │
     ▼
┌─────────────┐     ┌──────────────┐
│   Browse    │────►│   Products   │
│  Products   │     │   (Catalog)  │
└─────┬───────┘     └──────┬───────┘
      │                     │
      ▼                     │
┌─────────────┐            │
│  Add to     │◄───────────┘
│    Cart     │
└─────┬───────┘
      │
      ▼
┌─────────────┐     ┌──────────────┐
│   Place     │────►│    Orders    │
│   Order     │     │  (Created)   │
└─────────────┘     └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │   Tracking   │
                    │   (Status)   │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐     ┌──────────────┐
                    │  Delivered   │────►│   Feedback   │
                    │   (Complete) │     │  (Submit)    │
                    └──────────────┘     └──────────────┘
```

### Core Tables

#### 1. product_categories
```sql
CREATE TABLE product_categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT NOT NULL UNIQUE,
    category_description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### 2. users
```sql
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
```

#### 3. products
```sql
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
```

#### 4. orders
```sql
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
```

#### 5. forecasts
```sql
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
```

#### 6. feedback
```sql
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
```

#### 7. stock_updates
```sql
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
```

### Database Views

The system includes pre-built views for analytics:

1. **order_statistics**: Order counts and revenue by status
2. **inventory_summary**: Product inventory by category
3. **satisfaction_metrics**: Customer satisfaction aggregates
4. **low_stock_alert**: Products requiring reorder
5. **sales_performance**: Sales data by product
6. **stock_movement_history**: Complete stock change audit trail

---

## Key Performance Indicators (KPIs)

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Total Orders | 156 | - | ✅ |
| On-Time Delivery | 87.5% | 95% | ⚠️ |
| Average Delivery Time | 2.8 days | 2.0 days | ⚠️ |
| Return Rate | 4.2% | <3% | ⚠️ |
| Order Accuracy | 95.8% | >95% | ✅ |
| Customer Satisfaction | 4.6/5 | 4.8/5 | ⚠️ |

---

## Usage Guide

### For Customers
1. **Create Account**: Register via signup page with email and password
2. **Browse Products**: Navigate to Shop page to view available products
3. **Filter by Category**: Use category buttons to filter products
4. **Add to Cart**: Select products and add them to shopping cart
5. **Place Orders**: Complete checkout process
6. **Track Orders**: Use Order Tracking page to monitor delivery status in real-time
7. **Submit Feedback**: Provide ratings and comments via Customer Portal after delivery

### For Administrators
1. **Login**: Use admin credentials to access admin features
2. **Monitor KPIs**: View real-time metrics on dashboard and tracking pages
3. **Manage Inventory**: Check Forecast page for stock recommendations
4. **Review Feedback**: Access Customer Portal to read customer reviews
5. **Analyze Performance**: Track improvements in delivery times and accuracy
6. **Use API**: Access RESTful API for programmatic integration

### For Developers
1. **API Integration**: Use provided API endpoints for custom integrations
2. **Database Access**: Query SQLite database directly for custom reports
3. **Extend Functionality**: Add new routes and templates as needed
4. **Custom Analytics**: Create new database views for specific metrics

---


---

## Contact Information

**Email**: BFB321@gmail.com  
**Phone**: +27 63 049 0645  
**Address**: University of Pretoria

---

## License

© 2025 SupplyChain Master - BFB 321 Project Team  
All rights reserved.

---







