create database ecommerce_analysis;
use ecommerce_analysis;

create table customers (
	customer_id varchar(50) primary key,
    customer_unique_id varchar(50),
    customer_zip_code_prefix int,
    customer_city varchar(100),
    customer_state varchar(10));
    
    
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);


CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);


CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);


CREATE TABLE order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);


CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10, 2)
);

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

ALTER TABLE orders ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE order_items ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);
ALTER TABLE order_items ADD FOREIGN KEY (product_id) REFERENCES products(product_id);
ALTER TABLE order_items ADD FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);
ALTER TABLE order_reviews ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);
ALTER TABLE order_payments ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- CUSTOMER INSIGHTS
-- 1.Find the top 10 states with the highest number of customers?
select customer_state,count(*) as total_customers
from customers
group by customer_state
order by total_customers desc limit 10;

-- 2.What is the distribution of orders by order status?

select order_status, count(*) as order_distribution
from orders
group by order_status;

-- 3.How many unique sellers and products are present in the dataset?

select count(distinct seller_id) as unique_sellers from sellers;
select count(distinct product_id) as unique_products from products;

-- 4.Which product categories are the most popular based on number of orders?

select product_category_name, count(*) as total_orders
from products join order_items using(product_id)
group by product_category_name order by product_category_name desc;

-- 5.What is the monthly revenue trend over time?

SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- 6.What is the average, minimum and maximum delivery time for delivered orders?

select
	round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),2) as avg_delivery_days,
	min(datediff(order_delivered_customer_date,order_purchase_timestamp)) as min_delivery_days,
	max(datediff(order_delivered_customer_date,order_purchase_timestamp)) as max_delivery_days
        from orders 
        where order_status='delivered'
			and order_delivered_customer_date is not null
            and order_purchase_timestamp is not null;
            
-- 7.Which sellers have the highest total sales (revenue)?

select seller_id,sum(price+freight_value) as revenue
from order_items
group by seller_id
order by revenue desc;

-- 8.What is the average review score for each product category?

select product_category_name, avg(review_score) as avg_review_score
from order_reviews r
join orders o on r.order_id=o.order_id
join order_items oi on o.order_id=oi.order_id
join products p on oi.product_id=p.product_id
where r.review_score is not null
group by p.product_category_name
order by avg_review_score desc;

-- 9.Which payment types are most commonly used and what's the average payment value per type?

select payment_type, count(payment_type) as commonly_used_payment_type
from order_payments
group by payment_type;

select payment_type, round(avg(payment_value),2) as avg_payment_value
from order_payments
group by payment_type;

-- 10.Is there a correlation b/w delivery time and review score?

select r.review_score,
	round(avg(datediff(o.order_delivered_customer_date,o.order_purchase_timestamp)),2) as avg_delivery_days
	from orders o
	join order_reviews r on o.order_id=r.order_id
	where o.order_status='delivered'
		and o.order_delivered_customer_date is not null
		and o.order_purchase_timestamp is not null
		group by r.review_score
		order by r.review_score;
            
-- 11. Which states generate the most revenue and which have the highest return rates (cancelled orders)?

select c.customer_state,sum(price+freight_value) as revenue
from order_items oi
join orders o on o.order_id=oi.order_id
join customers c on c.customer_id=o.customer_id
where order_status='delivered'
group by customer_state
order by revenue desc limit 1;

select customer_state, count(order_status)as canceled_orders
from customers c
join orders o on c.customer_id=o.customer_id
where order_status='canceled'
group by customer_state
order by canceled_orders desc limit 1;

-- 12 What are the top 10 products with the highest no. of repeated purchases (same no.of cstomers again)?

SELECT 
    customer_id,
    product_id,
    COUNT(*) AS purchase_count
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY customer_id, product_id
HAVING purchase_count > 1
ORDER BY purchase_count DESC
LIMIT 10;

select * from order_reviews;
