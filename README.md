# SQL Subqueries & CTEs — Advanced Business Analysis

## Project Overview

This project is a hands-on SQL business analysis exercise focused on using **Common Table Expressions (CTEs), non-correlated subqueries, conditional aggregation, benchmarking, and multi-level aggregation** to answer realistic business questions.

Rather than practicing SQL syntax in isolation, the exercises are designed around an **analyst mindset**: turning raw customer, order, and product data into meaningful business insights.

> **Focus:** Transform → Aggregate → Benchmark → Compare → Interpret

---

## Objectives

The primary objectives of this exercise were to:

* Strengthen CTE-based SQL workflows
* Practice non-correlated subqueries
* Build reusable analytical datasets
* Calculate business benchmarks
* Compare individual entities against overall averages
* Perform customer-, product-, category-, and city-level analysis
* Use conditional aggregation for business metrics
* Calculate cancellation rates and revenue metrics
* Apply SQL segmentation logic using `CASE`
* Translate business questions into structured SQL solutions

**Correlated subqueries were intentionally excluded from this exercise.**

---

## Dataset Structure

The analysis uses three relational tables:

### `customers`

| Column          | Description                |
| --------------- | -------------------------- |
| `customer_id`   | Unique customer identifier |
| `customer_name` | Customer name              |
| `city`          | Customer city              |

### `orders`

| Column        | Description             |
| ------------- | ----------------------- |
| `order_id`    | Unique order identifier |
| `customer_id` | Customer reference      |
| `product_id`  | Product reference       |
| `amount`      | Order amount            |
| `status`      | Order status            |
| `order_date`  | Order date              |

### `products`

| Column         | Description               |
| -------------- | ------------------------- |
| `product_id`   | Unique product identifier |
| `product_name` | Product name              |
| `category`     | Product category          |
| `price`        | Product price             |

---

# Business Questions Covered

## Q1 — High-Value Customers

Identified customers whose:

* Total spending was above the overall average customer spending
* Completed-order count was above the average completed-order count

### SQL concepts

`CTE` · `CASE` · `SUM()` · `AVG()` · `CROSS JOIN`

---

## Q2 — Category Revenue Benchmark

Identified product categories whose completed-order revenue exceeded the average revenue across all categories.

### SQL concepts

`CTE` · Conditional aggregation · `AVG()` · Benchmark analysis

---

## Q3 — Customer Product Diversity

Identified customers who purchased products from more than one category using completed orders only.

### SQL concepts

`JOIN` · `COUNT(DISTINCT)` · `GROUP BY` · `HAVING`

---

## Q4 — Above-Average Product Performance

Identified products whose completed-order revenue exceeded the average completed-order revenue across products.

Also calculated the number of completed orders per product.

### SQL concepts

`CTE` · Aggregation · Benchmarking · `CROSS JOIN`

---

## Q5 — City-Level Customer Analysis

Identified cities where:

* Average customer spending exceeded the overall average customer spending
* At least one completed order existed within the city

This exercise introduced **multi-level aggregation**:

```text
Order
  ↓
Customer spending
  ↓
City-level customer average
  ↓
Overall benchmark
  ↓
City comparison
```

### SQL concepts

Multi-level aggregation · CTEs · `AVG()` · Conditional aggregation

---

## Q6 — Cancellation Risk by Product

Identified products whose cancellation rate exceeded the overall cancellation rate.

Calculated:

* Total orders
* Cancelled orders
* Cancellation rate

### SQL concepts

Conditional aggregation · Rate calculation · Benchmark comparison

---

## Q7 — City Value Segmentation

Classified cities according to average customer spending:

* `High Value`
* `Low Value`
* `Average Value`

The classification was based on comparison with the overall average customer spending.

### SQL concepts

`CASE` · CTEs · Multi-level aggregation · Business segmentation

---

## Q8 — Advanced Customer Investigation

Identified customers satisfying all three conditions:

1. Total spending above the overall customer spending average
2. At least one completed order
3. Completed-order revenue greater than cancelled-order amount

This question combined multiple business conditions into a single analytical query.

### SQL concepts

CTEs · Conditional aggregation · Benchmarking · Multiple business conditions

---

# Key SQL Patterns Practiced

### 1. CTE-Based Analytical Pipeline

```text
Raw Tables
    ↓
Entity-Level Aggregation
    ↓
Benchmark / Secondary Aggregation
    ↓
Comparison
    ↓
Business Output
```

### 2. Conditional Aggregation

```sql
SUM(
    CASE
        WHEN status = 'Completed' THEN amount
        ELSE 0
    END
)
```

Useful for calculating:

* Completed revenue
* Cancelled revenue
* Completed orders
* Cancelled orders

---

### 3. Benchmark Analysis

A recurring analytical pattern throughout the project:

```text
Calculate entity metric
        ↓
Calculate benchmark
        ↓
Compare entity vs benchmark
```

Examples include:

* Customer spending vs average customer spending
* Product revenue vs average product revenue
* Category revenue vs average category revenue
* Product cancellation rate vs overall cancellation rate

---

### 4. Multi-Level Aggregation

One of the most important lessons from this exercise was maintaining the correct **grain**.

For example:

```text
Order level
    ↓
Customer level
    ↓
City level
```

A city-level average customer spending should not be calculated directly from order amounts. Customer spending must first be calculated and then aggregated at the city level.

---

# Business Analytics Perspective

The SQL queries are designed to answer questions that could appear in a real analytics environment:

* Who are the highest-value customers?
* Which categories generate above-average revenue?
* Which customers demonstrate broader product engagement?
* Which products outperform the portfolio average?
* Which cities contain higher-value customer segments?
* Which products show elevated cancellation risk?
* Which customer segments combine high spending with stronger completed revenue?

The objective is not simply to obtain a result, but to understand **why the aggregation level, benchmark, and business metric matter**.

---

# SQL Skills Demonstrated

* MySQL
* CTEs
* Non-correlated subqueries
* `INNER JOIN`
* `CROSS JOIN`
* `GROUP BY`
* `HAVING`
* `CASE`
* `SUM()`
* `AVG()`
* `COUNT()`
* `COUNT(DISTINCT)`
* Conditional aggregation
* Percentage calculations
* Benchmark analysis
* Multi-level aggregation
* Business segmentation

---

# Learning Outcome

This exercise strengthened the transition from:

> **"I know SQL syntax."**

to:

> **"I can translate a business question into an analytical SQL workflow."**

The most important takeaway was learning to identify the **correct grain of analysis** before writing the aggregation.

---

## Author

**shorya dev bisht**
www.linkedin.com/in/shorya-bisht-a20144349
This project is part of my structured journey toward becoming a stronger **Data Analyst / Web Analyst / Data Science professional**, with a focus on SQL, business analytics, experimentation, and data-driven decision making.
