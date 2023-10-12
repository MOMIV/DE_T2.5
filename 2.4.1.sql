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
WHERE shop_name='shop_dns'
GROUP by  month, product_id 
ORDER by  month, product_id


