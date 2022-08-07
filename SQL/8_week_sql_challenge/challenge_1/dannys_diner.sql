/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT s.customer_id, 
       SUM(price) AS total_amount_spent
  FROM sales s
	JOIN menu m
    ON s.product_id = m.product_id
 GROUP BY s.customer_id
 ORDER BY total_amount_spent DESC;

/* Answer: Customer A spent the highest amount, $76, followed by customer B who spent $76, and finally customer C spent the least at $36. */

-- 2. How many days has each customer visited the restaurant?

SELECT customer_id, 
       COUNT(DISTINCT order_date) AS days_visited
  FROM sales
 GROUP BY customer_id
 ORDER BY days_visited DESC;

/* Answer: Customer B was the most frequent customer, with 6 visits in total, while customer A visited on 4 days, and customer C visited the least often: 2 days */

-- 3. What was the first item from the menu purchased by each customer?

SELECT s.customer_id, m.product_name
  FROM sales s
  JOIN menu m
    ON s.product_id = m.product_id
 GROUP BY s.customer_id
HAVING s.order_date = min(s.order_date);

/* Answer: The first item purchased by customer A was sushi, for customer B it was curry, and the first item customer C purchased was ramen */

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT m.product_name, 
       COUNT(*) AS purchases
  FROM sales s
  JOIN menu m
    ON s.product_id = m.product_id
 GROUP BY s.product_id
 ORDER BY purchases DESC
 LIMIT 1;

/* The most purchased item on the menu was ramen: it was purchased 8 times */

-- 5. Which item was the most popular for each customer?

WITH 
 popularity AS (
  SELECT customer_id, product_id, 
         CAST(COUNT(*) AS INT) AS amount_sold
    FROM sales
   GROUP BY customer_id, product_id
   ORDER BY customer_id, amount_sold DESC
),

 most_popular AS (
  SELECT p.customer_id AS customer, m.product_name AS name, 
         max(p.amount_sold) AS highest_amount
    FROM popularity p
    JOIN menu m
      ON p.product_id = m.product_id
   GROUP BY p.customer_id
)

SELECT s.customer_id,  m.product_name, 
       COUNT(*) AS amount_sold
  FROM sales s
  JOIN menu m
    ON s.product_id = m.product_id
  JOIN most_popular mp
    ON s.customer_id = mp.customer
 GROUP BY s.customer_id, s.product_id
HAVING amount_sold = mp.highest_amount;

/* Answer: Ramen was the most popular item for customers A and C, while customer B purchased all items equally. */

-- 6. Which item was purchased first by the customer after they became a member?

SELECT s.customer_id, s.order_date, m.product_name, mem.join_date
  FROM sales s
  JOIN members mem
    ON mem.customer_id = s.customer_id
  JOIN menu m
    ON m.product_id = s.product_id
 WHERE s.order_date >= mem.join_date
 GROUP BY s.customer_id
HAVING s.order_date = min(s.order_date);

/* Answer: After becoming a member, customer A bought curry. As for customer B, the first item they bought after they became a member was sushi. */

-- 7. Which item was purchased just before the customer became a member?

WITH 
 order_just_before AS (
  SELECT s.customer_id, s.order_date, m.product_name, mem.join_date
    FROM sales s
    JOIN members mem
      ON mem.customer_id = s.customer_id
    JOIN menu m
      ON m.product_id = s.product_id
   WHERE s.order_date < mem.join_date
   GROUP BY s.customer_id
  HAVING s.order_date = max(s.order_date)
)

SELECT s.customer_id, s.order_date, m.product_name, mem.join_date
  FROM sales s
  JOIN menu m
    ON m.product_id = s.product_id
  JOIN members mem
    ON mem.customer_id = s.customer_id
  JOIN order_just_before o
    ON s.customer_id = o.customer_id
 WHERE s.order_date = o.order_date
 GROUP BY s.customer_id, s.product_id;

/* Answer: Customer A became a member after purchasing curry and sushi (both were bought on the same day), and for customer B it was sushi. */

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT s.customer_id, 
       COUNT(DISTINCT s.product_id) AS items_bought, 
			 SUM(m.price) AS amount_spent
  FROM sales s
  JOIN menu m
    ON m.product_id = s.product_id
  JOIN members mem
    ON s.customer_id = mem.customer_id
 WHERE s.order_date < mem.join_date
 GROUP BY s.customer_id;
 
/* Answer: Before becoming a member, customer A bought 2 different items and spent $25; customer B also bought 2 items and spent $40. */

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH
 points_cte AS (
  SELECT *, 
         CASE 
				  WHEN product_name = 'sushi' THEN price * 10 * 2
					ELSE price * 10
				 END AS points
	  FROM menu
 
)
 
SELECT s.customer_id, 
       SUM(p.points) AS points
  FROM sales s
  JOIN points_cte as p
    ON s.product_id = p.product_id
 GROUP BY s.customer_id;

/* Answer: In this scenario, customer A would have 860 points, customer B would have 940 points and customer C would have 360 points. */

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT s.customer_id, mem.join_date, 
       SUM(CASE
			      WHEN s.order_date BETWEEN mem.join_date AND date(mem.join_date, '+6 days') THEN m.price * 10 * 2
						WHEN m.product_name = 'sushi' THEN m.price * 10 * 2
						ELSE m.price * 10
			     END) AS points
  FROM sales s
  JOIN menu m
    ON s.product_id = m.product_id
  JOIN members mem
    ON s.customer_id = mem.customer_id
 WHERE s.order_date  < '2021-01-31'
 GROUP BY s.customer_id;

/* Answer: with the revised point system, customer A would have 1370 points and customer B would have 820 points */
