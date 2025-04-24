-- Step 1: Create the Database
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Step 2: Drop if existing (safe reset)
DROP TABLE IF EXISTS reviews, payments, order_items, orders, products, customers, categories;

-- Step 3: Create Categories Table
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE,
    description TEXT
);

-- Step 4: Create Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    password_hash TEXT,
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    zip_code VARCHAR(10),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Step 5: Create Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT,
    category_id INT,
    price DECIMAL(10,2),
    stock_quantity INT,
    image_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Step 6: Create Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    payment_method VARCHAR(50),
    shipping_address TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Step 7: Create Order_Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price_at_order_time DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Step 8: Create Payments Table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    amount DECIMAL(10,2),
    payment_date DATETIME,
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    transaction_id VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Step 9: Create Reviews Table
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert Categories
INSERT INTO categories (name, description) VALUES
('Electronics', 'Devices, gadgets, and more'),
('Fashion', 'Clothing, accessories, and trends'),
('Books', 'All genres and authors');

-- Insert Products
INSERT INTO products (name, description, category_id, price, stock_quantity, image_url) VALUES
('Smartphone X10', 'Latest Android smartphone', 1, 699.99, 50, 'img/smartphone.jpg'),
('Wireless Earbuds', 'Noise-cancelling earbuds', 1, 129.99, 100, 'img/earbuds.jpg'),
('4K LED TV', 'Ultra HD Smart TV 55"', 1, 899.00, 20, 'img/tv.jpg'),
('Leather Jacket', 'Genuine leather for winter', 2, 199.99, 30, 'img/jacket.jpg'),
('Sneakers Pro', 'Comfortable running shoes', 2, 89.99, 75, 'img/sneakers.jpg'),
('Denim Jeans', 'Slim fit jeans for men', 2, 59.99, 40, 'img/jeans.jpg'),
('Thriller Novel', 'Bestselling suspense novel', 3, 19.99, 200, 'img/book1.jpg'),
('Science Fiction Saga', 'Futuristic space adventure', 3, 24.99, 150, 'img/book2.jpg'),
('Cooking Mastery', 'Cookbook by top chef', 3, 29.99, 100, 'img/cookbook.jpg'),
('Smartwatch V3', 'Fitness tracker with GPS', 1, 199.00, 60, 'img/smartwatch.jpg');

-- Insert Customers
INSERT INTO customers (name, email, phone, password_hash, address, city, state, country, zip_code) VALUES
('Alice Johnson', 'alice@example.com', '1234567890', 'hash123', '123 Maple St', 'New York', 'NY', 'USA', '10001'),
('Bob Smith', 'bob@example.com', '2345678901', 'hash234', '456 Oak St', 'Los Angeles', 'CA', 'USA', '90001'),
('Clara Lee', 'clara@example.com', '3456789012', 'hash345', '789 Pine St', 'Chicago', 'IL', 'USA', '60601'),
('David Miller', 'david@example.com', '4567890123', 'hash456', '321 Cedar St', 'Houston', 'TX', 'USA', '77001'),
('Ella Davis', 'ella@example.com', '5678901234', 'hash567', '654 Birch St', 'Phoenix', 'AZ', 'USA', '85001'),
('Frank Moore', 'frank@example.com', '6789012345', 'hash678', '987 Ash St', 'Philadelphia', 'PA', 'USA', '19101'),
('Grace Kim', 'grace@example.com', '7890123456', 'hash789', '111 Elm St', 'San Antonio', 'TX', 'USA', '78201'),
('Henry Scott', 'henry@example.com', '8901234567', 'hash890', '222 Walnut St', 'San Diego', 'CA', 'USA', '92101'),
('Ivy Chen', 'ivy@example.com', '9012345678', 'hash901', '333 Willow St', 'Dallas', 'TX', 'USA', '75201'),
('Jake Brown', 'jake@example.com', '0123456789', 'hash012', '444 Cherry St', 'San Jose', 'CA', 'USA', '95101');

-- Insert Orders
INSERT INTO orders (customer_id, total_amount, status, payment_method, shipping_address) VALUES
(1, 829.98, 'Delivered', 'Credit Card', '123 Maple St, NY, USA'),
(3, 259.98, 'Shipped', 'PayPal', '789 Pine St, IL, USA'),
(5, 89.99, 'Pending', 'Cash on Delivery', '654 Birch St, AZ, USA'),
(7, 1049.98, 'Delivered', 'Credit Card', '111 Elm St, TX, USA'),
(2, 199.99, 'Cancelled', 'UPI', '456 Oak St, CA, USA');

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, price_at_order_time) VALUES
(1, 1, 1, 699.99),
(1, 2, 1, 129.99),
(2, 4, 1, 199.99),
(2, 5, 1, 59.99),
(3, 5, 1, 89.99),
(4, 3, 1, 899.00),
(4, 10, 1, 199.00),
(5, 4, 1, 199.99);

-- Insert Payments
INSERT INTO payments (order_id, amount, payment_date, payment_status, transaction_id) VALUES
(1, 829.98, NOW(), 'Completed', 'TXN123A'),
(2, 259.98, NOW(), 'Completed', 'TXN456B'),
(3, 89.99, NULL, 'Pending', 'TXN789C'),
(4, 1049.98, NOW(), 'Completed', 'TXN101D'),
(5, 199.99, NOW(), 'Failed', 'TXN202E');

-- Insert Reviews
INSERT INTO reviews (customer_id, product_id, rating, review_text) VALUES
(1, 1, 5, 'Amazing phone! Super fast.'),
(3, 4, 4, 'Great quality jacket.'),
(5, 5, 3, 'Comfortable but not very durable.'),
(7, 3, 5, 'Love the display quality!'),
(2, 2, 4, 'Good value for the price.');

-- View Categories
SELECT * FROM categories;

-- View Products
SELECT * FROM products;

-- View Customers
SELECT * FROM customers;

-- View Orders
SELECT * FROM orders;

-- View Order Items
SELECT * FROM order_items;

-- View Payments
SELECT * FROM payments;

-- View Reviews
SELECT * FROM reviews;

SELECT 
    r.review_id,
    c.name AS customer_name,
    p.name AS product_name,
    r.rating,
    r.review_text,
    r.created_at
FROM 
    reviews r
INNER JOIN customers c ON r.customer_id = c.customer_id
INNER JOIN products p ON r.product_id = p.product_id;


SELECT o.*, 
    (SELECT SUM(total_amount) FROM orders) AS total_revenue
FROM orders o;


-- Customers with orders > 500
SELECT name FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders
    WHERE total_amount > 500
);
CREATE OR REPLACE VIEW high_value_customers AS
SELECT name FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders
    WHERE total_amount > 500
);
SELECT * FROM high_value_customers;
CREATE OR REPLACE VIEW high_value_orders AS
SELECT 
    c.customer_id,
    c.name AS customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > 500;
SELECT * FROM high_value_orders;


