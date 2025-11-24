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

## Team Members & Contributions

| Name | Student Number | GitHub Username | Contributions |
|------|----------------|-----------------|---------------|
| D Tsebe | u22729951 | Dineo Tsebe | • Updated and linked the **Shop** and **Customer** HTML files to the backend Python files<br>• Integrated shop product catalog with database queries<br>• Implemented customer feedback submission functionality<br>• Updated the README.md file to include the team members and contributions table |
| M Thebe | u22754459 | u22754459 | • Updated and linked the **Index** HTML file (home page) to the backend Python file<br>• Integrated KPI metrics display with Flask routes<br>• Updated the app.py file to correspond with all HTML templates<br>• Implemented dashboard statistics and real-time data binding |
| P Mkhwanazi | u21518689 | Phumi-km | • Updated and linked the **Forecast** and **Tracking** HTML files to the backend Python files<br>• Integrated demand forecasting data with database views<br>• Implemented order tracking with progress indicators and status updates<br>• Connected real-time order location and ETA functionality |
| K Mokone | u23655144 | Katlego23-stack | • Updated and linked the **Login** and **Signup** HTML files to the backend Python file<br>• Implemented user authentication and session management<br>• Created user registration with password validation<br>• Integrated Flask session handling for secure login/logout |

**Note**: All team members contributed collectively to updating the app.py file to ensure proper correspondence and integration with all HTML templates, database connections, and route handling.

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
- **JavaScript**: Client-side interactivity (via Bootstrap bundle)

### Database
- **SQLite**: Lightweight, file-based database
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
---
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
---
### Table Relationships

#### 1. USERS ↔ ORDERS
**Relationship Type**: One-to-Many  
**Description**: One user can place multiple orders  
**Foreign Key**: `ORDERS.customer` references `USERS.name`  
**Cardinality**: 1:N


```
---
```
**Business Rules**:
- A user must exist before placing an order
- A user can have zero or more orders
- Each order must belong to exactly one user
- Deleting a user should handle associated orders (cascade or restrict)
```
---

#### 2. PRODUCTS ↔ ORDERS
**Relationship Type**: One-to-Many  
**Description**: One product can appear in multiple orders  
**Foreign Key**: `ORDERS.product` references `PRODUCTS.name`  
**Cardinality**: 1:N


```
---
```
**Business Rules**:
- A product must exist in catalog before being ordered
- A product can be in zero or more orders
- Each order references exactly one product
- Product stock should decrease when order is placed
- Product cannot be deleted if active orders exist
```
---

#### 3. ORDERS ↔ FEEDBACK
**Relationship Type**: One-to-One  
**Description**: Each order can have one feedback entry  
**Foreign Key**: `FEEDBACK.order_num` references `ORDERS.order_number`  
**Cardinality**: 1:1


```
---
```
**Business Rules**:
- Feedback can only be submitted for existing orders
- Each order can have at most one feedback entry
- Feedback is typically submitted after order is delivered
- Feedback customer should match order customer
- Orders without feedback are allowed (not all customers provide feedback)
```
---

#### 4. USERS ↔ FEEDBACK
**Relationship Type**: One-to-Many  
**Description**: One user can submit multiple feedback entries  
**Foreign Key**: `FEEDBACK.customer` references `USERS.name`  
**Cardinality**: 1:N


```
---
```
**Business Rules**:
- Only registered users can submit feedback
- A user can submit feedback for multiple orders
- Each feedback entry belongs to exactly one user
- User information in feedback should match order information
```
---

#### 5. PRODUCTS ↔ FORECASTS
**Relationship Type**: One-to-Many (Categorical)  
**Description**: Products are grouped by category for forecasting  
**Foreign Key**: `FORECASTS.category` references `PRODUCTS.category`  
**Cardinality**: N:1


```
---
```
**Business Rules**:
- Forecasts are generated per category, not per individual product
- Multiple products can belong to the same forecast category
- Each forecast entry represents one product category
- Stock levels across all products in a category determine forecast status
- Reorder recommendations apply to the entire category
```
---
### Relationship Summary Table

| Relationship | Type | Foreign Key | Cascade Behavior | Description |
|--------------|------|-------------|------------------|-------------|
| USERS → ORDERS | 1:N | customer | CASCADE/RESTRICT | Users place orders |
| PRODUCTS → ORDERS | 1:N | product | RESTRICT | Products are ordered |
| ORDERS → FEEDBACK | 1:1 | order_num | CASCADE | Orders receive feedback |
| USERS → FEEDBACK | 1:N | customer | CASCADE | Users submit feedback |
| PRODUCTS → FORECASTS | N:1 | category | CASCADE | Products grouped for forecasting |

```
---
```
## Key Performance Indicators (KPIs)

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Total Orders | 156 | - | ✅ |
| On-Time Delivery | 87.5% | 95% | ⚠️ |
| Average Delivery Time | 2.8 days | 2.0 days | ⚠️ |
| Return Rate | 4.2% | <3% | ⚠️ |
| Order Accuracy | 95.8% | >95% | ✅ |
| Customer Satisfaction | 4.6/5 | 4.8/5 | ⚠️ |
```
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
```
---
```
### For Administrators
1. **Login**: Use admin credentials to access admin features
2. **Monitor KPIs**: View real-time metrics on dashboard and tracking pages
3. **Manage Inventory**: Check Forecast page for stock recommendations
4. **Review Feedback**: Access Customer Portal to read customer reviews
5. **Analyze Performance**: Track improvements in delivery times and accuracy
6. **Use API**: Access RESTful API for programmatic integration
```
---
### For Developers
1. **API Integration**: Use provided API endpoints for custom integrations
2. **Database Access**: Query SQLite database directly for custom reports
3. **Extend Functionality**: Add new routes and templates as needed
4. **Custom Analytics**: Create new database views for specific metrics
```
---
```
## Contact Information

**Email**: BFB321@gmail.com  
**Phone**: +27 63 049 0645  
**Address**: University of Pretoria
```
---
```
## License

© 2025 SupplyChain Master - BFB 321 Project Team  
All rights reserved.
```
---







