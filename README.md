# 📊 SQL Case Study 

This repository contains a complete **SQL Server implementation** of the popular **8-Week SQL Challenge – Case Study #1

It includes:

- ✔ Full database schema
- ✔ Sample data
- ✔ Solutions for all 8 questions
- ✔ Usage of JOINs, CTEs, and window functions
- ✔ Clean & optimized T-SQL scripts

---

## 🗂️ Project Structure


---

## 🗃️ Database Schema

### 1️⃣ `sales`
Stores customer order transactions.

| Column       | Type        |
|--------------|-------------|
| customer_id  | VARCHAR(1)  |
| order_date   | DATE        |
| product_id   | INT         |

---

### 2️⃣ `menu`
Stores menu items and their prices.

| Column        | Type        |
|---------------|-------------|
| product_id    | INT         |
| product_name  | VARCHAR(5)  |
| price         | INT         |

---

### 3️⃣ `members`
Stores customer membership start dates.

| Column       | Type        |
|--------------|-------------|
| customer_id  | VARCHAR(1)  |
| join_date    | DATE        |

---

## ❓ Case Study Questions

1. What is the total amount each customer spent at the restaurant?  
2. How many days has each customer visited the restaurant?  
3. What was the first item purchased by each customer?  
4. What is the most purchased item on the menu?  
5. Which item was the most popular for each customer?  
6. Which item was purchased first after the customer became a member?  
7. Which item was purchased just before the customer became a member?  
8. What is the total items and amount spent before they became a member?

All answers are included in `Case_Study_1.sql`.

---

## 🚀 How to Use

1. Open **SQL Server Management Studio (SSMS)**  
2. Open the file **Case_Study_1.sql**  
3. Run the script to create tables and insert sample data  
4. Execute each query to view results  

---

## 🛠 Technologies Used

- SQL Server (T-SQL)
- Aggregations
- Joins & Subqueries
- Common Table Expressions (CTEs)
- Window Functions

---

## ⭐ Author

**Navin Fartyal**  
This repository is part of my SQL learning and portfolio.

