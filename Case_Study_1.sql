select * from [Case_Study].[members];
select * from [Case_Study].menu;
select * from [Case_Study].sales;

/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
select s.customer_id,sum(m.price) as Total_spent from [Case_Study].[sales] s 
	inner join [Case_Study].[menu] m on s.product_id = m.product_id
	group by s.customer_id

-- 2. How many days has each customer visited the restaurant?
select 
	customer_id,count(distinct(order_date)) as Total_visit 
	from Case_Study.sales 
	group by 
customer_id

-- 3. What was the first item from the menu purchased by each customer?

select t.customer_id,t.product_name from
(select customer_id,product_name,ROW_NUMBER() over(partition by s.customer_id order by order_date) as Row_num from [Case_Study].sales s inner join Case_Study.menu m on s.product_id = m.product_id ) t
where t.Row_num = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?


with cte_2 as (
select s.customer_id,s.order_date,s.product_id,m.product_name,m.price from Case_Study.sales s inner join Case_Study.menu m on s.product_id=m.product_id)

select top 1 product_name,count(customer_id) as Total_purchased from cte_2
group by product_name
order by count(customer_id) desc


-- 5. Which item was the most popular for each customer?


with cte_3 as (
select *,row_number() over(partition by customer_id  order by Total_Popular desc) as rnk from
(select s.customer_id,s.order_date,s.product_id,m.product_name,m.price,count(*) over(partition by customer_id,product_name) as Total_Popular
from Case_Study.sales s inner join Case_Study.menu m on s.product_id= m.product_id ) t)

select customer_id,product_name,Total_Popular from cte_3
where rnk = 1

-- 6. Which item was purchased first by the customer after they became a member?


select customer_id,order_date,join_date,product_name from (
select
s.customer_id,s.order_date,m.join_date,ROW_NUMBER() over(partition by s.customer_id order by s.order_date) as rnk,product_name
from Case_Study.sales s inner join
Case_Study.members m on s.customer_id = m.customer_id inner join Case_Study.menu me  on s.product_id = me.product_id 
where order_date > join_date) t 
where rnk =1

-- 8. What is the total items and amount spent for each member before they became a member?
select customer_id,count(product_name) as Total_order,sum(price) as total_spent from
(
select s.customer_id,s.order_date,s.product_id,m.join_date,me.price,me.product_name
from Case_Study.sales s inner join Case_Study.members m on s.customer_id = m.customer_id
inner join Case_Study.menu me on s.product_id =me.product_id
where order_date<join_date) t 
group by customer_id


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

with cte_4 as(
select s.customer_id,s.order_date,s.product_id,m.price,
CASE WHEN m.product_name = 'sushi' then price * 20 else price * 10 end total_points
from Case_Study.sales s inner join Case_Study.menu m on s.product_id = m.product_id)

select customer_id , sum(total_points) from cte_4 group by customer_id

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
