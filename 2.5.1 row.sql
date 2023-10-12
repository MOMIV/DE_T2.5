SELECT shop_name, product_name, sales_fact, sales_plan, sales_fact/sales_plan, income_fact, income_plan,  income_fact/income_plan
row_number()over (partition by FirstName,LastName order by TotalAmount desc) 
FROM Customers FULL  JOIN  Orders on Customers.Customer_ID=Orders.Customer_ID 
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);

SELECT product_id, SUM(sales_cnt) AS sales_fact, date_trunc('month', fact_date) as month
FROM shop_dns 
GROUP by  month, product_id 
ORDER by  month, product_id


SELECT product_id, SUM(plan_cnt) AS sales_plan, date_trunc('month', plan_date) as month
FROM plan
GROUP by  month, product_id, shop_name 
ORDER by  month, product_id, shop_name


SELECT shop_name, product_name, SUM(plan_cnt) AS sales_plan, date_trunc('month', plan_date) as month
FROM plan, products, shop_dns, shop_mvideo, shop_sitilink
GROUP by  month, product_id, shop_name 
ORDER by  month, product_id, shop_name


SELECT shop_name, product_name, SUM(sales_cnt) AS sales_fact, SUM(plan_cnt) AS sales_plan, sales_fact*1.0/sales_plan,  date_trunc('month', plan_date) as month
FROM plan, products, shop_dns, shop_mvideo, shop_sitilink
GROUP by  month, product_name, shop_name 
ORDER by  month, product_name

WITH cte AS
(
    select *, DATE_TRUNC('month',fact_date) as "month"
    FROM shop_dns
)
SELECT product_id, month, SUM(sales_cnt) AS sales_fact
from cte
group by month, product_id
order by month, product_id


WITH cte AS
(
    select *, DATE_TRUNC('month',plan_date) as "month"
    FROM plan
)
SELECT  shop_name, product_id, month, SUM(plan_cnt) AS sales_plan
from cte
group by month, product_id, shop_name
order by month, product_id, shop_name

WITH cte AS
(
    select *, DATE_TRUNC('month',fact_date) as "month"
    FROM shop_dns, shop_mvideo, shop_sitilink
)
SELECT product_id, month, SUM(sales_cnt) AS sales_fact
from cte
group by month, product_id, shop_name
order by month, product_id, shop_name



ALTER TABLE shop_dns add shop_name CHARACTER VARYING(30) DEFAULT 'shop_dns';
ALTER TABLE shop_mvideo add shop_name CHARACTER VARYING(30) DEFAULT 'shop_mvideo';
ALTER TABLE shop_sitilink add shop_name CHARACTER VARYING(30) DEFAULT 'shop_sitilink';

SELECT shop_name, product_id,SUM(sales_cnt) AS sales_fact, date_trunc('month', fact_date) as month
from ( SELECT shop_name, product_id, sales_cnt, fact_date 
FROM shop_dns 
union all
SELECT shop_name, product_id, sales_cnt, fact_date  
FROM shop_mvideo
union all
SELECT shop_name, product_id, sales_cnt, fact_date  
FROM shop_sitilink) as pt
GROUP by  month, pt.shop_name, pt.product_id 
ORDER by  month, pt.shop_name, pt.product_id 


SELECT shop_name, product_id,SUM(sales_cnt) AS sales_fact, SUM(plan_cnt) AS sales_plan, date_trunc('month', fact_date) as month
from ( SELECT shop_name, product_id, sales_cnt, fact_date 
FROM shop_dns 
union all
SELECT shop_name, product_id, sales_cnt, fact_date  
FROM shop_mvideo
union all
SELECT shop_name, product_id, sales_cnt, fact_date  
FROM shop_sitilink) as pt
full join plan
on plan.shop_name=pt.shop_name and plan.product_id=pt.product_id
GROUP by  month, pt.shop_name, pt.product_id 
ORDER by  month, pt.shop_name, pt.product_id 

SELECT ptt.shop_name, ptt.product_id, sales_fact, SUM(plan_cnt) AS sales_plan, date_trunc('month', plan_date) as month
from plan
full join(SELECT shop_name, product_id,SUM(sales_cnt) AS sales_fact, date_trunc('month', fact_date) as month
from ( SELECT shop_name, product_id, sales_cnt, fact_date 
FROM shop_dns 
union all
SELECT shop_name, product_id, sales_cnt, fact_date  
FROM shop_mvideo
union all
SELECT shop_name, product_id, sales_cnt, fact_date  
FROM shop_sitilink) as pt
GROUP by  month, pt.shop_name, pt.product_id 
ORDER by  month, pt.shop_name, pt.product_id) as ptt
on ptt.shop_name=plan.shop_name and ptt.product_id=plan.product_id
GROUP by  month, ptt.shop_name, ptt.product_id 
ORDER by  month, ptt.shop_name, ptt.product_id

with shop_sales AS
(SELECT pt.shop_name, pt.product_id,SUM(sales_cnt) AS sales_fact, date_trunc('month', fact_date) as month
from ( SELECT shop_name, product_id, sales_cnt, fact_date  
FROM shop_dns 
union all
SELECT shop_name, product_id, sales_cnt, fact_date  
FROM shop_mvideo
union all
SELECT shop_name, product_id, sales_cnt, fact_date  
FROM shop_sitilink) as pt
GROUP by  month, pt.shop_name, pt.product_id 
ORDER by  month, pt.shop_name, pt.product_id) 

SELECT shop_sales.shop_name, 
products.product_name, 
shop_sales.sales_fact, 
plan_cnt AS sales_plan,
ROUND(sales_fact::numeric/plan_cnt::numeric,2) as "sales_fact/sales_plan",
shop_sales.sales_fact*products.price as income_fact,
plan_cnt*products.price as income_plan,
ROUND(shop_sales.sales_fact::numeric*products.price::numeric/plan_cnt::numeric/products.price::numeric,2) as "income_fact/income_plan",
month
from plan
full join shop_sales on plan.shop_name=shop_sales.shop_name and plan.product_id=shop_sales.product_id and month = date_trunc('month', plan_date)
full join products on  shop_sales.product_id=products.product_id and plan.product_id=products.product_id 
GROUP by  month, shop_sales.shop_name, products.product_name, shop_sales.sales_fact, plan.plan_cnt, products.price
ORDER by  month, shop_sales.shop_name, products.product_name