CREATE SCHEMA Case_Study
GO Case_Study');
END
GO

/*-----------------------------------------
  3. Drop tables if already exist
-----------------------------------------*/
DROP TABLE IF EXISTS Case_Study.sales;
DROP TABLE IF EXISTS Case_Study.menu;
DROP TABLE IF EXISTS Case_Study.members;
GO

/*-----------------------------------------
  4. Create tables
-----------------------------------------*/
CREATE TABLE Case_Study.sales (
    customer_id VARCHAR(1),
    order_date  DATE,
    product_id  INT
);
GO

CREATE TABLE Case_Study.menu (
    product_id   INT,
    product_name VARCHAR(5),
    price        INT
);
GO

CREATE TABLE Case_Study.members (
    customer_id VARCHAR(1),
    join_date   DATE
);
GO

/*-----------------------------------------
  5. Insert data
-----------------------------------------*/
INSERT INTO Case_Study.sales (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', 1),
  ('A', '2021-01-01', 2),
  ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3),
  ('A', '2021-01-11', 3),
  ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2),
  ('B', '2021-01-02', 2),
  ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1),
  ('B', '2021-01-16', 3),
  ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-07', 3);
GO

INSERT INTO Case_Study.menu (product_id, product_name, price)
VALUES
  (1, 'sushi', 10),
  (2, 'curry', 15),
  (3, 'ramen', 12);
GO

INSERT INTO Case_Study.members (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
GO

/*-----------------------------------------
  6. Case Study Questions & Solutions
-----------------------------------------*/

-- 1. Total amount each customer spent
SELECT s.customer_id, SUM(m.price) AS total_spent
FROM Case_Study.sales s
JOIN Case_Study.menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 2. Number of days each customer visited
SELECT customer_id, COUNT(DISTINCT order_date) AS total_visit
FROM Case_Study.sales
GROUP BY customer_id;

-- 3. First item purchased by each customer
SELECT * FROM (
    SELECT s.customer_id, m.product_name,
           ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS rn
    FROM Case_Study.sales s
    JOIN Case_Study.menu m ON s.product_id = m.product_id
) t
WHERE rn = 1;

-- 4. Most purchased item overall
SELECT TOP 1 m.product_name, COUNT(*) AS total_purchased
FROM Case_Study.sales s
JOIN Case_Study.menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY total_purchased DESC;

-- 5. Most popular item for each customer
WITH ranked AS (
    SELECT s.customer_id, m.product_name,
           COUNT(*) AS total_count,
           ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS rn
    FROM Case_Study.sales s
    JOIN Case_Study.menu m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
)
SELECT customer_id, product_name, total_count
FROM ranked
WHERE rn = 1;

-- 6. First item purchased after becoming member
SELECT * FROM (
    SELECT s.customer_id, s.order_date, me.product_name,
           ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rn
    FROM Case_Study.sales s
    JOIN Case_Study.members mb ON s.customer_id = mb.customer_id
    JOIN Case_Study.menu me ON s.product_id = me.product_id
    WHERE s.order_date > mb.join_date
) t
WHERE rn = 1;

-- 8. Total items & amount before becoming member
SELECT customer_id, COUNT(*) AS total_orders, SUM(price) AS total_spent
FROM (
    SELECT s.customer_id, me.price
    FROM Case_Study.sales s
    JOIN Case_Study.members mb ON s.customer_id = mb.customer_id
    JOIN Case_Study.menu me ON s.product_id = me.product_id
    WHERE order_date < join_date
) t
GROUP BY customer_id;

-- 9. Points earned (sushi = 2x)
SELECT customer_id, SUM(
    CASE WHEN m.product_name = 'sushi' THEN m.price * 20 ELSE m.price * 10 END
) AS total_points
FROM Case_Study.sales s
JOIN Case_Study.menu m ON s.product_id = m.product_id
GROUP BY customer_id;

-- 10. Double points for first week after joining
SELECT s.customer_id,
       SUM(
           CASE WHEN s.order_date BETWEEN mb.join_date AND DATEADD(day, 6, mb.join_date)
                THEN m.price * 20
                WHEN m.product_name = 'sushi'
                THEN m.price * 20
                ELSE m.price * 10
           END
       ) AS january_points
FROM Case_Study.sales s
JOIN Case_Study.members mb ON s.customer_id = mb.customer_id
JOIN Case_Study.menu m ON s.product_id = m.product_id
WHERE MONTH(s.order_date) = 1
GROUP BY s.customer_id;
