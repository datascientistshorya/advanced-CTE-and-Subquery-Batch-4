/*Q1 — High-Value Customers
Find customers whose total spending is above the overall average customer spending
and whose number of completed orders is also above 
the average completed-order count per customer*/

with customer_data as(
	select c.customer_id,c.customer_name,sum(o.amount) as total_spend,
    sum(case when o.status='Completed' then 1 else 0 end) as completed_orders
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id,c.customer_name
),
benchmark as(
	select avg(total_spend) as avg_total,
    avg(completed_orders) as avg_comp 
    from customer_data)

select * from customer_data cd
cross join benchmark b
where cd.total_spend>b.avg_total
and
cd.completed_orders>b.avg_comp;

/*Q2 — Category Revenue Benchmark
Find product categories whose total completed-order revenue is above the 
average category revenue.*/

with product_data as(
	select p.category,
    sum(case when o.status='Completed' then amount else 0 end) as total_revenue
    from products p inner join orders o 
    on p.product_id=o.product_id
    group by p.category
),
benchmark as(
	select avg(total_revenue) as avg_comp_rev 
    from product_data
)
select * from product_data pd
cross join benchmark as b
where pd.total_revenue>b.avg_comp_rev;

/* Q3 — Customers with Strong Product Diversity
Find customers who have purchased products from more than one category, 
considering only completed orders.*/

select c.customer_id,c.customer_name,count(distinct(p.category)) as cat_count
from customers c
inner join orders o 
on c.customer_id=o.customer_id
inner join products p 
on o.product_id=p.product_id
where o.status='Completed'
group by c.customer_id,c.customer_name
having cat_count>1;

/*Q4 — Above-Average Product Performance
Find products whose completed-order revenue is above the 
average completed-order revenue across all products. 
Show product name, category, revenue, and number of completed orders.*/

	with prod_data as(
		select p.product_name,p.category,sum(o.amount) as revenue,
		sum(case when o.status='Completed' then 1 else 0 end) as completed_orders
		from products p inner join orders o 
		on o.product_id=p.product_id
		where o.status='Completed'
		group by p.product_name,p.category
	),
	benchmark as(
		select avg(revenue) avg_rev from prod_data
	)
	select * from prod_data pd
	cross join benchmark b
	where pd.revenue>b.avg_rev;

/*Q5 — City-Level Customer Analysis
Find cities where:
•	average customer spending is above the overall average customer spending, and 
•	at least one customer from that city has placed a completed order. 
Return city, number of customers, and average customer spending*/

with customer_data as (
	select c.city, sum(o.amount) as total_spend,
    sum(case when o.status='Completed' then 1 else 0 end) as completed_orders
	from customers c
    inner join orders o 
    on  c.customer_id=o.customer_id
    group by c.customer_id,c.customer_name,c.city
),
city_data AS (
    SELECT
        city,
        COUNT(*) AS customer_count,
        AVG(total_spend) AS avg_customer_spending,
        SUM(completed_orders) AS completed_orders
    FROM customer_data
    GROUP BY city
),
benchmark AS (
    SELECT AVG(total_spend) AS overall_avg_spending
    FROM customer_data
)
select * FROM city_data cd
CROSS JOIN benchmark b
WHERE cd.avg_customer_spending > b.overall_avg_spending
  AND cd.completed_orders > 0;
  
  /*Q6 — Cancellation Risk by Product
Find products whose cancellation rate is above the 
overall cancellation rate across all orders.
Return:product name, total orders, cancelled orders, cancellation rate */

with prod_data as(
	select p.product_name,count(*) as total_orders,
    sum(case when o.status='Cancelled' then 1 else 0 end) as cancelled_orders,
    sum(case when o.status='Cancelled' then 1 else 0 end)/count(*)*100 as cancel_rate
    from products p inner join orders o
    on o.product_id=p.product_id
    group by p.product_name
),
benchmark as(
	select sum(case when status='Cancelled' then 1 else 0 end)/count(*)*100 as cancel_rate
    from orders
)
select * from prod_data pd
cross join benchmark b
where pd.cancel_rate>b.cancel_rate;

/*Q7 — Channel-Style Business Segmentation
Using customer city as the segmentation dimension, classify each city as:
•	High Value → average customer spending > overall average 
•	Low Value → average customer spending < overall average 
•	Average Value → otherwise */

WITH customer_data AS (
    SELECT
        c.customer_id,
        c.city,
        SUM(o.amount) AS total_spend
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.city
),
city_data AS (
    SELECT
        city,
        COUNT(*) AS customer_count,
        AVG(total_spend) AS avg_customer_spending
    FROM customer_data
    GROUP BY city
),
benchmark AS (
    SELECT
        AVG(total_spend) AS overall_avg_spending
    FROM customer_data
)
SELECT
    cd.city,
    cd.customer_count,
    cd.avg_customer_spending,
    CASE
        WHEN cd.avg_customer_spending > b.overall_avg_spending
            THEN 'High Value'
        WHEN cd.avg_customer_spending < b.overall_avg_spending
            THEN 'Low Value'
        ELSE 'Average Value'
    END AS city_segment
FROM city_data cd
CROSS JOIN benchmark b;

/*Q8 — Final Business Investigation 🔥
Identify customers who satisfy all three conditions:
1.	Their total spending is above the overall average customer spending. 
2.	They have at least one completed order. 
3.	Their completed-order revenue is greater than their cancelled-order amount. 
Return: customer_id, customer_name, total_spending, completed_revenue and cancelled_amount*/

with customer_data as(
	select c.customer_id, c.customer_name, sum(o.amount) as total_spending,
    sum(case when o.status='Completed' then 1 else 0 end) as completed_orders,
    sum(case when o.status='Cancelled' then amount else 0 end) as cancel_amt,
    sum(case when o.status='Completed' then amount else 0 end) as completed_amt
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id, c.customer_name
),
benchmark as(
	select avg(total_spending) as avg_spending from customer_data  
)    

select customer_id,customer_name, total_spending from customer_data cd
cross join benchmark b
where cd.total_spending>b.avg_spending
and 
cd.completed_amt>cd.cancel_amt
and cd.completed_orders>0;

