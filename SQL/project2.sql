/* 
We calculate sales (absolute and percentage) by genre in the USA. 
Based on the results below, out of the four albums in the task, 
the three albums that the record store should select are Red Tone (Punk), 
Slim Jim Bites (Blues) and Meteor and the Girls (Pop), as those genres had 
more sales in the USA than Hip-Hop.
*/
SELECT g.name AS genre_name, 
                 COUNT(*) AS USA_sales_absolute,
				 (ROUND(cast(COUNT(*) AS float) * 100.00 / (SELECT SUM(quantity)
				                              FROM invoice_line il
											   JOIN invoice i
											       ON i.invoice_id = il.invoice_id
										WHERE i.billing_country = 'USA'), 2) || '%') AS USA_sales_percentage
    FROM genre g
      JOIN track t
	      ON t.genre_id = g.genre_id
	  JOIN invoice_line il
	      ON il.track_id = t.track_id
      JOIN invoice i
	      ON i.invoice_id = il.invoice_id
WHERE i.billing_country = 'USA'
  GROUP BY genre_name
  ORDER BY USA_sales_absolute DESC;

/* 
We calculate the total dollar amount of sales achieved by each employee. 
According to the data below, Jane Peacock performed the best, and Steve Johnson had the lowest sales revenue. 
However, this might not be indicative of Steve's actual performance, since he was employed later, 
which is shown in the hire_date column 
*/

SELECT (e.last_name || ' ' || e.first_name) AS employee_name, 
                  e.hire_date,
				  ('$' || SUM(i.total)) AS dollar_sales
   FROM employee e
     JOIN customer c
	     ON c.support_rep_id = e.employee_id
	 JOIN invoice i
	     ON i.customer_id = c.customer_id
GROUP BY e.employee_id
ORDER BY dollar_sales DESC;

/* 
In this step, we analyse sales data per each country, to identify which countries have the most potential in
bringing more revenue, hence more efforts should be focused on marketing in those countries.
Based on the results shown below, Czech Republic, United Kingdom and India are the countries with 
multiple customers that have the highest average order value, hence they have a lot of potential in bringing more
revenue if the record store manages to attract more customers there.
 */
 
 SELECT c.country, 
                  COUNT(DISTINCT c.customer_id) AS total_customers, 
				  SUM(i.total) AS total_sales, 
				  SUM(i.total) / COUNT(DISTINCT c.customer_id) AS average_sales_per_customer,
				  SUM(i.total) / COUNT(DISTINCT i.invoice_id) AS average_order_value
    FROM customer c
      JOIN invoice i
          ON i.customer_id = c.customer_id
 GROUP BY c.country
 ORDER BY total_sales DESC;