SELECT FirstName,LastName, TotalAmount,
row_number()over (partition by FirstName,LastName order by TotalAmount desc) 
FROM Customers FULL  JOIN  Orders on Customers.Customer_ID=Orders.Customer_ID 
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);

