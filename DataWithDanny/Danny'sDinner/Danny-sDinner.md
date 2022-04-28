Data With Danny: Danny’s Dinner
================
Benjamin Sivac
2022-04-15

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/Danny'sDinner/figure-gfm/dwd_1.png"
       height="850px" width="850px"/>
</p>

## Introduction

Danny seriously loves Japanese food so in the beginning of 2021, he
decides to embark upon a risky venture and opens up a cute little
restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay
afloat - the restaurant has captured some very basic data from their few
months of operation but have no idea how to use their data to help them
run the business.

## Problem Statement

Danny wants to use the data to answer a few simple questions about his
customers, especially about their visiting patterns, how much money
they’ve spent and also which menu items are their favourite. Having this
deeper connection with his customers will help him deliver a better and
more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should
expand the existing customer loyalty program - additionally he needs
help to generate some basic datasets so his team can easily inspect the
data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to
privacy issues - but he hopes that these examples are enough for you to
write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:

-   sales
-   menu
-   members

## Entity Relationship Diagram

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/Danny'sDinner/figure-gfm/erd.PNG"/>
</p>

## Datasets

All datasets exist within the dannys\_diner database schema - be sure to
include this reference within your SQL scripts as you start exploring
the data and answering the case study questions.

<h3 id="Table 1: sales"><code>Table 1: sales</code></h3>

The sales table captures all customer\_id level purchases with an
corresponding order\_date and product\_id information for when and what
menu items were ordered.

<div class="knitsql-table">

| customer\_id | order\_date | product\_id |
|:-------------|:------------|------------:|
| A            | 2021-01-01  |           1 |
| A            | 2021-01-01  |           2 |
| A            | 2021-01-07  |           2 |
| A            | 2021-01-10  |           3 |
| A            | 2021-01-11  |           3 |
| A            | 2021-01-11  |           3 |
| B            | 2021-01-01  |           2 |
| B            | 2021-01-02  |           2 |
| B            | 2021-01-04  |           1 |
| B            | 2021-01-11  |           1 |
| B            | 2021-01-16  |           3 |
| B            | 2021-02-01  |           3 |
| C            | 2021-01-01  |           3 |
| C            | 2021-01-01  |           3 |
| C            | 2021-01-07  |           3 |

Displaying records 1 - 15

</div>

<h3 id="Table 2: menu"><code>Table 2: menu</code></h3>

The menu table maps the product\_id to the actual product\_name and
price of each menu item.

<div class="knitsql-table">

| product\_id | product\_name | price |
|:------------|:--------------|------:|
| 1           | sushi         |    10 |
| 2           | curry         |    15 |
| 3           | ramen         |    12 |

3 records

</div>

<h3 id="Table 3: members"><code>Table 3: members</code></h3>

The final members table captures the join\_date when a customer\_id
joined the beta version of the Danny’s Diner loyalty program.

<div class="knitsql-table">

| customer\_id | join\_date |
|:-------------|:-----------|
| A            | 2021-01-07 |
| B            | 2021-01-09 |

2 records

</div>

## Case Study Questions

Each of the following case study questions can be answered using a
single SQL statement:

**1. What is the total amount each customer spent at the restaurant?**

``` sql
SELECT
    DISTINCT customer_id,
    SUM(price) AS total_amount
FROM
    sales
JOIN
    menu 
ON
    sales.product_id = menu.product_id
GROUP BY customer_id
```

<div class="knitsql-table">

| customer\_id | total\_amount |
|:-------------|--------------:|
| A            |            76 |
| B            |            74 |
| C            |            36 |

3 records

</div>

------------------------------------------------------------------------

**2. How many days has each customer visited the restaurant?**

``` sql
SELECT
    DISTINCT customer_id,
    COUNT(DISTINCT order_date) AS days
FROM
    sales
GROUP BY customer_id;
```

<div class="knitsql-table">

| customer\_id | days |
|:-------------|-----:|
| A            |    4 |
| B            |    6 |
| C            |    2 |

3 records

</div>

------------------------------------------------------------------------

**3. What was the first item from the menu purchased by each customer?**

``` sql
WITH CTE_dr AS(
    SELECT 
        customer_id,
        order_date,
        product_name,
        DENSE_RANK() OVER(PARTITION BY customer_id
            ORDER BY order_date) AS dr
    FROM
        sales s
    JOIN
        menu m
    ON
        s.product_id = m.product_id
)

SELECT 
    customer_id,
    product_name
FROM
    CTE_dr
WHERE dr = 1
GROUP BY customer_id, product_name;
```

<div class="knitsql-table">

| customer\_id | product\_name |
|:-------------|:--------------|
| A            | curry         |
| A            | sushi         |
| B            | curry         |
| C            | ramen         |

4 records

</div>

------------------------------------------------------------------------

**4. What is the most purchased item on the menu and how many times was
it purchased by all customers?**

``` sql
SELECT TOP 1
    product_name,
    (COUNT(s.product_id)) AS times_purchased
FROM
    sales s
JOIN
    menu m
ON
    s.product_id = m.product_id
GROUP BY product_name
ORDER BY times_purchased DESC
```

<div class="knitsql-table">

| product\_name | times\_purchased |
|:--------------|-----------------:|
| ramen         |                8 |

1 records

</div>

------------------------------------------------------------------------

**5. Which item was the most popular for each customer?**

``` sql
WITH CTE_dr AS(
    SELECT 
        customer_id,
        product_name,
        COUNT(s.product_id) AS item_count,
        DENSE_RANK() OVER(PARTITION BY s.customer_id
            ORDER BY COUNT(s.customer_id) DESC) AS dr
    FROM
        sales s
    JOIN
        menu m
    ON
        s.product_id = m.product_id
    GROUP BY customer_id, product_name
)

SELECT 
    customer_id,
    product_name,
    item_count
FROM
    CTE_dr
WHERE dr = 1
GROUP BY customer_id, product_name, item_count;
```

<div class="knitsql-table">

| customer\_id | product\_name | item\_count |
|:-------------|:--------------|------------:|
| A            | ramen         |           3 |
| B            | sushi         |           2 |
| B            | curry         |           2 |
| B            | ramen         |           2 |
| C            | ramen         |           3 |

5 records

</div>

------------------------------------------------------------------------

**6. Which item was purchased first by the customer after they became a
member?**

``` sql
WITH CTE_dr AS(
    SELECT 
        s.customer_id,
        join_date,
        order_date,
        product_id,
        DENSE_RANK() OVER(PARTITION BY s.customer_id
            ORDER BY order_date) AS dr
    FROM
        sales s
    JOIN
        members m
    ON
        s.customer_id = m.customer_id
    WHERE order_date >= join_date 
)

SELECT 
    customer_id,
    order_date,
    product_name
FROM
    CTE_dr dr
JOIN
    menu m
ON
    dr.product_id = m.product_id
WHERE dr = 1;
```

<div class="knitsql-table">

| customer\_id | order\_date | product\_name |
|:-------------|:------------|:--------------|
| A            | 2021-01-07  | curry         |
| B            | 2021-01-11  | sushi         |

2 records

</div>

------------------------------------------------------------------------

**7. Which item was purchased just before the customer became a
member?**

``` sql
WITH CTE_dr AS(
    SELECT 
        s.customer_id,
        join_date,
        order_date,
        product_id,
        DENSE_RANK() OVER(PARTITION BY s.customer_id
            ORDER BY order_date DESC) AS dr
    FROM
        sales s
    JOIN
        members m
    ON
        s.customer_id = m.customer_id
    WHERE order_date < join_date 
)

SELECT 
    customer_id,
    order_date,
    product_name
FROM
    CTE_dr dr
JOIN
    menu m
ON
    dr.product_id = m.product_id
WHERE dr = 1;
```

<div class="knitsql-table">

| customer\_id | order\_date | product\_name |
|:-------------|:------------|:--------------|
| A            | 2021-01-01  | sushi         |
| A            | 2021-01-01  | curry         |
| B            | 2021-01-04  | sushi         |

3 records

</div>

------------------------------------------------------------------------

**8. What is the total items and amount spent for each member before
they became a member?**

``` sql
SELECT 
    DISTINCT s.customer_id,
    COUNT(DISTINCT s.product_id) AS total_items,
    SUM(price) AS total_expenditure
FROM
    sales s
JOIN
    members m
ON
    s.customer_id = m.customer_id
JOIN
    menu 
ON
    s.product_id = menu.product_id
WHERE order_date < join_date 
GROUP BY s.customer_id;
```

<div class="knitsql-table">

| customer\_id | total\_items | total\_expenditure |
|:-------------|-------------:|-------------------:|
| A            |            2 |                 25 |
| B            |            2 |                 40 |

2 records

</div>

------------------------------------------------------------------------

**9. If each $1 spent equates to 10 points and sushi has a 2x points
multiplier - how many points would each customer have?**

``` sql
WITH CTE_points AS(
    SELECT
        customer_id,
        CASE 
            WHEN s.product_id = 1 THEN price*20
            ELSE price * 10
        END AS points
    FROM
        menu m
    JOIN
        sales s
    ON
        m.product_id = s.product_id
)
SELECT
    DISTINCT customer_id,
    SUM(points) AS total_points
FROM
    CTE_points
GROUP BY customer_id;
```

<div class="knitsql-table">

| customer\_id | total\_points |
|:-------------|--------------:|
| A            |           860 |
| B            |           940 |
| C            |           360 |

3 records

</div>

------------------------------------------------------------------------

**10. In the first week after a customer joins the program (including
their join date) they earn 2x points on all items, not just sushi - how
many points do customer A and B have at the end of January?**

``` sql
WITH CTE_points AS(
    SELECT
        s.customer_id,
        order_date,
        s.product_id,
        CASE 
            WHEN s.product_id = 1 
              OR (order_date BETWEEN join_date AND DATEADD(DAY, 7, join_date)) 
              THEN price*20
            ELSE price * 10
        END AS points
    FROM
        menu m
    JOIN
        sales s
    ON
        m.product_id = s.product_id
    JOIN
        members mem
    ON
        s.customer_id = mem.customer_id
)
SELECT
    DISTINCT customer_id,
    SUM(points) AS total_points
FROM
    CTE_points
GROUP BY customer_id
```

<div class="knitsql-table">

| customer\_id | total\_points |
|:-------------|--------------:|
| A            |          1370 |
| B            |          1060 |

2 records

</div>

Only difference to question 9 is that I added another OR condition with
a between operator, which includes both the start and end value. I also
added a parenthesis for better readability.
