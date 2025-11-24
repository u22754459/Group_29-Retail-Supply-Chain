# Group_29-Retail-Supply-Chain
## SupplyChain Master

## Project Description

SupplyChain Master is a comprehensive supply chain management platform designed to optimize logistics operations and enhance customer satisfaction. The system addresses critical supply chain challenges by providing real-time order tracking, demand forecasting, and customer feedback management.

### Key Features
- **Real-Time Order Tracking**: Live GPS updates and progress monitoring for all orders
- **Demand Forecasting**: AI-powered inventory predictions to optimize stock levels
- **Customer Portal**: Feedback submission and satisfaction tracking
- **E-commerce Shop**: Product catalog with shopping cart functionality
- **Performance Metrics**: KPI dashboards for delivery times, accuracy, and customer satisfaction

### Project Goals
- Reduce delivery delays by 40%
- Decrease wrong orders by 70%
- Improve customer satisfaction to 4.8/5.0
- Achieve 95% on-time delivery rate
- Maintain order accuracy above 95%

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

- **Frontend**: HTML5, CSS3, Bootstrap 5.3.2
- **JavaScript**: Vanilla JS (ES6+)
- **Database**: SQL.js (Client-side SQLite)
- **Icons**: Bootstrap Icons 1.11.1
- **Storage**: LocalStorage for session and data persistence

---

## Installation & Setup Instructions

### Prerequisites
- Modern web browser (Chrome, Firefox, Safari, or Edge)
- No server installation required (runs entirely in browser)

### Setup Steps

1. **Download the Project Files**
   ```bash
   # Clone or download the repository
   git clone [repository-url]
   cd supplychain-master
   ```

2. **File Structure**
   Ensure all files are in the same directory:
   ```
   supplychain-master/
   ├── index.html
   ├── shop.html
   ├── tracking.html
   ├── forecast.html
   ├── customer.html
   ├── login.html 
   ├── signup.html 
   └── README.md
   ```

3. **Launch the Application**
   - Simply open `index.html` in your web browser
   - Or use a local development server:
     ```bash
     # Using Python 3
     python -m http.server 8000
     
     # Using Node.js
     npx http-server
     ```
   - Navigate to `http://localhost:8000`

4. **Initial Data**
   - The application automatically creates sample data on first load
   - Sample orders, products, and feedback are pre-populated
   - Data persists in browser's LocalStorage

### Browser Compatibility
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

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

### Table Definitions

#### 1. USERS Table
```sql
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| user_id | INTEGER | PRIMARY KEY | Unique user identifier |
| name | TEXT | NOT NULL | User's full name |
| email | TEXT | UNIQUE, NOT NULL | User's email address |
| password | TEXT | NOT NULL | Hashed password |
| created_at | TEXT | DEFAULT NOW | Account creation date |

#### 2. PRODUCTS Table
```sql
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    sku TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INTEGER DEFAULT 0,
    description TEXT,
    emoji TEXT
);
```

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| product_id | INTEGER | PRIMARY KEY | Unique product identifier |
| sku | TEXT | UNIQUE, NOT NULL | Stock keeping unit code |
| name | TEXT | NOT NULL | Product name |
| category | TEXT | NOT NULL | Product category |
| price | DECIMAL | NOT NULL | Product price |
| stock | INTEGER | DEFAULT 0 | Available quantity |
| description | TEXT | | Product description |
| emoji | TEXT | | Display emoji |

**Sample Data:**
- Electronics: Samsung Galaxy S23, iPhone 14 Pro, AirPods Pro
- Clothing: Nike Air Max
- Books: JavaScript Guide
- Beauty: Moisturizing Cream
- Sports: Yoga Mat
- Home: Coffee Maker

#### 3. ORDERS Table
```sql
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_number TEXT UNIQUE NOT NULL,
    customer TEXT NOT NULL,
    product TEXT NOT NULL,
    status TEXT CHECK(status IN ('processing', 'in-transit', 'delivered', 'delayed', 'cancelled')),
    eta TEXT,
    location TEXT,
    progress INTEGER DEFAULT 0
);
```

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| order_id | INTEGER | PRIMARY KEY | Unique order identifier |
| order_number | TEXT | UNIQUE, NOT NULL | Order reference number |
| customer | TEXT | NOT NULL | Customer name |
| product | TEXT | NOT NULL | Ordered product |
| status | TEXT | CHECK constraint | Order status |
| eta | TEXT | | Estimated delivery date |
| location | TEXT | | Current location |
| progress | INTEGER | DEFAULT 0 | Completion percentage (0-100) |

**Status Values:**
- `processing`: Order being prepared
- `in-transit`: Out for delivery
- `delivered`: Successfully delivered
- `delayed`: Behind schedule
- `cancelled`: Order cancelled

#### 4. FEEDBACK Table
```sql
CREATE TABLE feedback (
    feedback_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer TEXT NOT NULL,
    order_num TEXT NOT NULL,
    rating INTEGER CHECK(rating BETWEEN 1 AND 5),
    delivery_rating INTEGER CHECK(delivery_rating BETWEEN 1 AND 5),
    product_rating INTEGER CHECK(product_rating BETWEEN 1 AND 5),
    comment TEXT NOT NULL,
    date TEXT DEFAULT CURRENT_DATE,
    status TEXT CHECK(status IN ('pending', 'delivered', 'returned'))
);
```

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| feedback_id | INTEGER | PRIMARY KEY | Unique feedback identifier |
| customer | TEXT | NOT NULL | Customer name |
| order_num | TEXT | NOT NULL | Related order number |
| rating | INTEGER | 1-5 | Overall rating |
| delivery_rating | INTEGER | 1-5 | Delivery experience rating |
| product_rating | INTEGER | 1-5 | Product quality rating |
| comment | TEXT | NOT NULL | Customer feedback text |
| date | TEXT | DEFAULT NOW | Feedback submission date |
| status | TEXT | CHECK constraint | Order status at feedback time |

#### 5. FORECASTS Table
```sql
CREATE TABLE forecasts (
    forecast_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NOT NULL,
    current_stock INTEGER NOT NULL,
    forecast INTEGER NOT NULL,
    status TEXT CHECK(status IN ('low', 'optimal', 'high')),
    reorder INTEGER NOT NULL
);
```

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| forecast_id | INTEGER | PRIMARY KEY | Unique forecast identifier |
| category | TEXT | NOT NULL | Product category |
| current_stock | INTEGER | NOT NULL | Current inventory level |
| forecast | INTEGER | NOT NULL | Predicted demand (30 days) |
| status | TEXT | CHECK constraint | Inventory status |
| reorder | INTEGER | NOT NULL | Reorder point threshold |

**Status Logic:**
- `low`: current_stock < reorder
- `optimal`: current_stock ≥ reorder AND < forecast * 1.2
- `high`: current_stock ≥ forecast * 1.2

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
1. **Browse Products**: Navigate to Shop page to view available products
2. **Add to Cart**: Select products and add them to shopping cart
3. **Track Orders**: Use Order Tracking page to monitor delivery status
4. **Submit Feedback**: Provide ratings and comments via Customer Portal

### For Administrators
1. **Monitor KPIs**: View real-time metrics on Tracking page
2. **Manage Inventory**: Check Forecast page for stock recommendations
3. **Review Feedback**: Access Customer Portal to read customer reviews
4. **Analyze Performance**: Track improvements in delivery times and accuracy

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
