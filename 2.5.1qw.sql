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
plan.shop_name,
products.product_name, 
shop_sales.sales_fact, 
plan_cnt AS sales_plan,
ROUND(sales_fact::numeric/plan_cnt::numeric,2) as "sales_fact/sales_plan",
shop_sales.sales_fact*products.price as income_fact,
plan_cnt*products.price as income_plan,
ROUND(shop_sales.sales_fact::numeric*products.price::numeric/plan_cnt::numeric/products.price::numeric,2) as "income_fact/income_plan",
month,
date_trunc('month', plan_date)
from plan
full join shop_sales on plan.shop_name=shop_sales.shop_name and plan.product_id=shop_sales.product_id and month = date_trunc('month', plan_date)
full join products on  shop_sales.product_id=products.product_id and plan.product_id=products.product_id 
GROUP by  month, plan.plan_date, shop_sales.shop_name, plan.shop_name, products.product_name, shop_sales.sales_fact, plan.plan_cnt, products.price
ORDER by month, plan.plan_date, shop_sales.shop_name, plan.shop_name, products.product_name
