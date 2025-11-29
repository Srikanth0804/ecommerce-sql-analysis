# ecommerce-sql-analysis
SQL-based analysis of e-commerce customer behavior, sales, and delivery performance

📌 **Project Overview**

This project performs a comprehensive SQL-based analysis on an e-commerce dataset to extract actionable business insights related to customers, sales, delivery performance, payments, and reviews. A normalized relational schema was designed and analyzed using structured queries to answer business-oriented questions.

The goal is to demonstrate practical SQL skills including database creation, table design, joins, aggregations, grouping, filtering, and real-world business analytics.

🛠 **Tech Stack**

SQL (MySQL)
Relational Database Design
Data Analysis using SQL Queries

🗂 **Database Schema**

The database ecommerce_analysis consists of the following tables:

customers
orders
order_items
products
order_reviews
order_payments
sellers

Foreign key relationships were implemented to maintain data integrity between orders, customers, sellers, products, and payments.

🗃 **Entity Relationship Summary**

One customer → Many orders

One order → Many order items

One product → Many order items

One seller → Many order items

One order → One or many payments

One order → One review

🔍 **Business Questions Answered**

Customer & Market Insights

Top 10 states with the highest number of customers

Order distribution by status (delivered, canceled, shipped, etc.)

Number of unique sellers and products

Product & Sales Performance

Most popular product categories by number of orders

Top sellers by total revenue

Repeat purchase analysis by customer-product combinations

Revenue Analysis

Monthly revenue trends

State-wise revenue contribution

Identification of states with highest canceled orders

Delivery Performance

Average, minimum, and maximum delivery time

Relationship between delivery time and review score

Payment Insights

Most commonly used payment types

Average payment value per payment type

Customer Experience

Average review score by product category

Correlation between delivery time and customer ratings

📊 **Sample Insights**

Identified regions contributing highest revenue

Found sellers generating maximum revenue

Discovered categories with best customer ratings

Highlighted delivery delays impacting review scores

Analyzed repeat customer behavior for loyalty insights

📁 Project Structure
Ecommerce-SQL-Analysis/
│── schema.sql
│── analysis_queries.sql
│── README.md
│── data/ (if dataset is available)

▶ **How to Run This Project**

Install MySQL

Create the database:

CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;


Run the schema SQL file to create tables.

Import data using MySQL Workbench / CLI.

Execute analysis queries from analysis_queries.sql.

🚀 **Future Enhancements**

Add Power BI or Tableau dashboard

Index optimization for large datasets

Convert queries into stored procedures

Build recommendation logic on SQL views

Deploy results through API / web app

👤 **Author**

Srikanth Gunti
📧 Email: srikanthgunti11@gmail.com

🔗 LinkedIn: https://www.linkedin.com/in/srikanth-gunti-

⭐ If you found this project useful

Feel free to ⭐ star this repository and fork it!
