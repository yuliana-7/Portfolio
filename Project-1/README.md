## Summary
The goal of this project was to analyse the sales data for scale model cars from the 'stores.db' database, in order to facilitate dacision-making.

Using SQL to query the data from the database, I answered the following three questions:

* Question 1: Which products should we order more of or less of?
* Question 2: How should we tailor marketing and communication strategies to customer behaviors?
* Question 3: How much can we spend on acquiring new customers?

Below is a table summarising the database. It lists the tables that the database consists of, as well as the number of columns (attributes) and rows each table contains:

![table directory](https://github.com/yuliana-7/Portfolio/blob/main/SQL/Project-1/Screenshots/tables.png)

## Question 1: Which products should we order more of or less of?

In order to answer this question, I first fetched the list of 10 cars with the **lowest stock** level, which you can see in the table below:

![low stock cars](https://github.com/yuliana-7/Portfolio/blob/main/SQL/Project-1/Screenshots/low-stock.png)

Then, I got the top 10 products that generated the **highest revenue**.

![high revenue cars](https://github.com/yuliana-7/Portfolio/blob/main/SQL/Project-1/Screenshots/high-performance.png)

Finally, I combined the data above to obtain the list of products that should have the **highest priority** for **restock**:

![restock priority](https://github.com/yuliana-7/Portfolio/blob/main/SQL/Project-1/Screenshots/restock-priority.png)

## Question 2: How should we tailor marketing and communication strategies to customer behaviors?

In this part, I generated the customer ranking based on amount of revenue they brought in, to determine the **VIP customers**.

![VIP customers](https://github.com/yuliana-7/Portfolio/blob/main/SQL/Project-1/Screenshots/VIP-customers.png)

Next, I ranked the data in ascending order to see which **customers** were **engaging less**.

![Less engaged customers](https://github.com/yuliana-7/Portfolio/blob/main/SQL/Project-1/Screenshots/less-engaged-customers.png)

The information in this question can be used to make decisions on organising programmes to increase existing customers' loyalty, as well as ways to attract new customers.

## Question 3: How much can we spend on acquiring new customers?

Here, I calculated **Customer Lifetime Value (LTV)**, which represents the average amount of money a customer generates. It is useful for deciding how much the company should spend on increasing its customer base.

![LTV](https://github.com/yuliana-7/Portfolio/blob/main/SQL/Project-1/Screenshots/lifetime-value.png)
