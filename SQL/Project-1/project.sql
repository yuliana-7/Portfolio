-- List of tables
SELECT 'Customers' AS table_name,
                  '13' AS number_of_attributes,
				  COUNT(*) AS number_of_rows
  FROM customers
 UNION ALL
SELECT 'Products' AS table_name,
                   '9' AS number_of_attributes,
				   COUNT(*) AS number_of_rows
  FROM products
 UNION ALL
SELECT 'ProductLines' AS table_name,
                  '4' AS number_of_attributes,
				  COUNT(*) AS number_of_rows
  FROM productlines
 UNION ALL
SELECT 'Orders' AS table_name,
                  '7' AS number_of_attributes,
				  COUNT(*) AS number_of_rows
  FROM orders
 UNION ALL
SELECT 'OrderDetails' AS table_name,
                  '5' AS number_of_attributes,
				  COUNT(*) AS number_of_rows
  FROM orderdetails
 UNION ALL
SELECT 'Payments' AS table_name,
                  '4' AS number_of_attributes,
				  COUNT(*) AS number_of_rows
  FROM payments
 UNION ALL
SELECT 'Employees' AS table_name,
                  '8' AS number_of_attributes,
				  COUNT(*) AS number_of_rows
  FROM employees
 UNION ALL
SELECT 'Offices' AS table_name,
                  '9' AS number_of_attributes,
				  COUNT(*) AS number_of_rows
  FROM offices;
   
/*Question 1*/
--Low stock
SELECT p.productCode, p.productName,
                 SUM(od.quantityOrdered) * 1.0 / (SELECT quantityInStock
				                                                             FROM products p
																			 WHERE p.productCode = od.productCode) AS stock
  FROM orderdetails od
  JOIN products p
    ON p.productCode = od.productCode
 GROUP BY od.productCode
 ORDER BY stock
 LIMIT 10;
  
 --Product performance
SELECT od.productCode, p.productName, 
                   SUM(quantityOrdered * priceEach) AS performance
  FROM orderdetails od
  JOIN products p
    ON od.productCode = p.productCode
 GROUP BY od.productCode
 ORDER BY performance DESC;

--Priority products for restocking
WITH
 low_stock AS (
  SELECT p.productCode, p.productName,
         SUM(od.quantityOrdered) * 1.0 / (SELECT quantityInStock
                                            FROM products p
				           WHERE p.productCode = od.productCode) AS stock
    FROM orderdetails od
    JOIN products p
      ON p.productCode = od.productCode
   GROUP BY od.productCode
   ORDER BY stock
   LIMIT 10
)
  
SELECT productCode, 
       (SELECT productName
          FROM products p
         WHERE p.productCode = od.productCode) AS product_name,
       SUM(quantityOrdered * priceEach) AS performance
 FROM orderdetails od
WHERE productCode IN (SELECT productCode
                        FROM low_stock)
GROUP BY productCode
ORDER BY performance DESC;
 
 
/*Question 2*/
--VIP customers ranked by profit
SELECT o.customerNumber, 
       c.contactFirstName, c.contactLastName,
       SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS profit
  FROM orders o
  JOIN orderdetails od
    ON o.orderNumber = od.orderNumber
  JOIN products p
    ON od.productCode = p.productCode
  JOIN customers c
    ON o.customerNumber = c.customerNumber
 GROUP BY o.customerNumber
 ORDER BY profit DESC;
  
-- Less-engaged customers
SELECT o.customerNumber, 
       c.contactFirstName, c.contactLastName,
       SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS profit
  FROM orders o
  JOIN orderdetails od
    ON o.orderNumber = od.orderNumber
  JOIN products p
    ON od.productCode = p.productCode
  JOIN customers c
    ON o.customerNumber = c.customerNumber
 GROUP BY o.customerNumber
 ORDER BY profit;
  
  
--Customer Lifetime Value 
WITH 
 customer_profit AS (
  SELECT o.customerNumber, 
         c.contactFirstName, c.contactLastName,
         SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)) AS profit
    FROM orders o
    JOIN orderdetails od
      ON o.orderNumber = od.orderNumber
    JOIN products p
      ON od.productCode = p.productCode
    JOIN customers c
      ON o.customerNumber = c.customerNumber
   GROUP BY o.customerNumber
)
 
SELECT AVG(profit) AS LTV
  FROM  customer_profit;
