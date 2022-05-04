Data With Danny: Balanced Tree Clothing Co.
================
<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/BalancedTreeClothingCo/figures-gfm/7.png"
       height="850px" width="850px"/>
</p>

Benjamin Sivac
2022-04-08

## Introduction

Balanced Tree Clothing Company prides themselves on providing an optimised range of clothing and lifestyle wear for the modern adventurer!

Danny, the CEO of this trendy fashion company has asked you to assist the team’s merchandising teams analyse their sales performance and generate a basic financial report to share with the wider business.

## Available Data

For this case study there is a total of 4 datasets for this case study - however you will only need to utilise 2 main tables to solve all of the
regular questions, and the additional 2 tables are used only for the bonus challenge question!

<h3 id="Product Details"><code>Product Details</code></h3>

product\_details includes all information about the entire range that Balanced Clothing sells in their store.

<div class="knitsql-table">

| product\_id | price | product\_name                 | category\_id | segment\_id | style\_id | category\_name | segment\_name | style\_name    |
|:------------|------:|:------------------------------|-------------:|------------:|----------:|:---------------|:--------------|:---------------|
| c4a632      |    13 | Navy Oversized Jeans - Womens |            1 |           3 |         7 | Womens         | Jeans         | Navy Oversized |
| e83aa3      |    32 | Black Straight Jeans - Womens |            1 |           3 |         8 | Womens         | Jeans         | Black Straight |
| e31d39      |    10 | Cream Relaxed Jeans - Womens  |            1 |           3 |         9 | Womens         | Jeans         | Cream Relaxed  |
| d5e9a6      |    23 | Khaki Suit Jacket - Womens    |            1 |           4 |        10 | Womens         | Jacket        | Khaki Suit     |
| 72f5d4      |    19 | Indigo Rain Jacket - Womens   |            1 |           4 |        11 | Womens         | Jacket        | Indigo Rain    |
| 9ec847      |    54 | Grey Fashion Jacket - Womens  |            1 |           4 |        12 | Womens         | Jacket        | Grey Fashion   |
| 5d267b      |    40 | White Tee Shirt - Mens        |            2 |           5 |        13 | Mens           | Shirt         | White Tee      |
| c8d436      |    10 | Teal Button Up Shirt - Mens   |            2 |           5 |        14 | Mens           | Shirt         | Teal Button Up |
| 2a2353      |    57 | Blue Polo Shirt - Mens        |            2 |           5 |        15 | Mens           | Shirt         | Blue Polo      |
| f084eb      |    36 | Navy Solid Socks - Mens       |            2 |           6 |        16 | Mens           | Socks         | Navy Solid     |

Displaying records 1 - 10

</div>

<h3 id="Product Sales"><code>Product Sales</code></h3>

sales contains product level information for all the transactions made for Balanced Tree including quantity, price, percentage discount, member status, a transaction ID and also the transaction timestamp.

<div class="knitsql-table">

| prod\_id | qty | price | discount | member | txn\_id | start\_txn\_time            |
|:---------|----:|------:|---------:|:-------|:--------|:----------------------------|
| c4a632   |   4 |    13 |       17 | t      | 54f307  | 2021-02-13 01:59:43.2960000 |
| 5d267b   |   4 |    40 |       17 | t      | 54f307  | 2021-02-13 01:59:43.2960000 |
| b9a74d   |   4 |    17 |       17 | t      | 54f307  | 2021-02-13 01:59:43.2960000 |
| 2feb6b   |   2 |    29 |       17 | t      | 54f307  | 2021-02-13 01:59:43.2960000 |
| c4a632   |   5 |    13 |       21 | t      | 26cc98  | 2021-01-19 01:39:00.3456000 |
| e31d39   |   2 |    10 |       21 | t      | 26cc98  | 2021-01-19 01:39:00.3456000 |
| 72f5d4   |   3 |    19 |       21 | t      | 26cc98  | 2021-01-19 01:39:00.3456000 |
| 2a2353   |   3 |    57 |       21 | t      | 26cc98  | 2021-01-19 01:39:00.3456000 |
| f084eb   |   3 |    36 |       21 | t      | 26cc98  | 2021-01-19 01:39:00.3456000 |
| c4a632   |   1 |    13 |       21 | f      | ef648d  | 2021-01-27 02:18:17.1648000 |

Displaying records 1 - 10

</div>

# Case Study Questions

The following questions can be considered key business questions and metrics that the Balanced Tree team requires for their monthly reports.

Each question can be answered using a single query - but as you are writing the SQL to solve each individual problem, keep in mind how you would generate all of these metrics in a single SQL script which the Balanced Tree team can run each month.

## A. High Level Sales Analysis

**A.1 What was the total quantity sold for all products?**

``` sql
SELECT 
    SUM(qty) AS total_quantity
FROM
    sales
```

<div class="knitsql-table">

| total\_quantity |
|----------------:|
|           45216 |

1 records

</div>

------------------------------------------------------------------------

**A.2 What is the total generated revenue for all products before
discounts?**

``` sql
SELECT
    SUM(price*qty) AS Total_revenue
FROM 
    sales
```

<div class="knitsql-table">

| Total\_revenue |
|---------------:|
|        1289453 |

1 records

</div>

------------------------------------------------------------------------

**A.3 What was the total discount amount for all products?**

``` sql
SELECT
    SUM(qty*(price*(discount*0.01))) AS total_discount_amount
FROM
    sales
```

<div class="knitsql-table">

| total\_discount\_amount |
|------------------------:|
|                156229.1 |

1 records

</div>

## B. Transaction Analysis

**B.1 How many unique transactions were there?**

``` sql
SELECT
    COUNT(DISTINCT txn_id) AS count_unique_txn
FROM
    sales;
```

<div class="knitsql-table">

| count\_unique\_txn |
|-------------------:|
|               2500 |

1 records

</div>

------------------------------------------------------------------------

**B.2 What is the average unique products purchased in each
transaction?**

``` sql
WITH cte_count AS(
    SELECT 
        COUNT(DISTINCT prod_id) AS unique_count
    FROM
        sales
    GROUP BY txn_id
)

SELECT
    AVG(unique_count) AS avg_unique_count
FROM 
    cte_count;
```

<div class="knitsql-table">

| avg\_unique\_count |
|-------------------:|
|                  6 |

1 records

</div>

------------------------------------------------------------------------

**B.3 What are the 25th, 50th and 75th percentile values for the revenue
per transaction?**

``` sql
SELECT
    DISTINCT txn_id,
    PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY qty*price-(qty*price*discount*0.01))
    OVER (PARTITION BY txn_id) AS twentyfive_centile,
    PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY qty*price-(qty*price*discount*0.01))
    OVER (PARTITION BY txn_id) AS median,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY qty*price-(qty*price*discount*0.01))
    OVER (PARTITION BY txn_id) AS seventyfive_centile
FROM
    sales
GROUP BY txn_id, price, qty, discount
ORDER BY txn_id
```

<div class="knitsql-table">

| txn\_id | twentyfive\_centile | median | seventyfive\_centile |
|:--------|--------------------:|-------:|---------------------:|
| 000027  |               25.23 |  29.58 |               125.28 |
| 000106  |               50.16 |  83.60 |               105.60 |
| 000dd8  |               24.44 |  27.26 |                30.08 |
| 003920  |               29.52 |  32.80 |               164.00 |
| 003c6d  |               22.62 |  60.03 |                93.96 |
| 003ea6  |               28.20 |  36.66 |                64.86 |
| 0053d3  |               54.40 |  64.00 |               102.40 |
| 00a68b  |               35.34 | 111.60 |               212.04 |
| 00c8dc  |               18.40 |  46.92 |               106.72 |
| 00d139  |               25.84 |  27.36 |                52.44 |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**B.4 What is the average discount value per transaction?**

``` sql
SELECT
    txn_id,
    CAST(AVG(discount*price*qty*0.01) AS DECIMAL(10,2)) AS average_discount_value
FROM
    sales
GROUP BY txn_id
```

<div class="knitsql-table">

| txn\_id | average\_discount\_value |
|:--------|-------------------------:|
| 24986f  |                    15.18 |
| f8c478  |                     4.95 |
| f2c360  |                    22.25 |
| 7eb5bd  |                    10.91 |
| c00d1a  |                     0.89 |
| a1edde  |                     6.98 |
| aa7e3c  |                     9.55 |
| ff0ccc  |                     7.20 |
| 571b43  |                     9.94 |
| abc8b9  |                     8.26 |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**B.5 What is the percentage split of all transactions for members vs
non-members?**

``` sql
SELECT
    DISTINCT member,
    FORMAT(COUNT(1) * 100 / SUM(COUNT(1)) OVER() * 0.01, 'p') AS pct
FROM
    sales
GROUP BY member
```

<div class="knitsql-table">

| member | pct    |
|:-------|:-------|
| f      | 39.00% |
| t      | 60.00% |

2 records

</div>

------------------------------------------------------------------------

**B.6 What is the average revenue for member transactions and non-member
transactions?**

``` sql
SELECT
    DISTINCT member, 
    CAST(AVG(price*qty - (price*qty*discount*0.01)) AS DECIMAL(10,2)) AS avg_revenue
FROM
    sales
GROUP BY member;
```

<div class="knitsql-table">

| member | avg\_revenue |
|:-------|-------------:|
| f      |        74.54 |
| t      |        75.43 |

2 records

</div>

## C. Product Analysis

**C.1 What are the top 3 products by total revenue before discount?**

``` sql
WITH cte_total_revenue AS(
    SELECT
        prod_id,
        SUM(price*qty) AS total_revenue
    FROM
        sales
    GROUP BY prod_id
)

SELECT
    TOP 3 prod_id,
    total_revenue
FROM
    cte_total_revenue
ORDER BY total_revenue DESC;
```

<div class="knitsql-table">

| prod\_id | total\_revenue |
|:---------|---------------:|
| 2a2353   |         217683 |
| 9ec847   |         209304 |
| 5d267b   |         152000 |

3 records

</div>

------------------------------------------------------------------------

**C.2 What is the total quantity, revenue and discount for each
segment?**

``` sql
SELECT
    segment_name,
    SUM(qty) AS total_quantity,
    SUM(s.price*qty-(s.price*qty*discount*0.01)) AS total_revenue,
    SUM(s.price*qty*discount*0.01) AS total_discount
FROM sales s
    JOIN 
    product_details pd
    ON
        s.prod_id = pd.product_id
GROUP BY segment_name;
```

<div class="knitsql-table">

| segment\_name | total\_quantity | total\_revenue | total\_discount |
|:--------------|----------------:|---------------:|----------------:|
| Jacket        |           11385 |       322705.5 |        44277.46 |
| Jeans         |           11349 |       183006.0 |        25343.97 |
| Shirt         |           11265 |       356548.7 |        49594.27 |
| Socks         |           11217 |       270963.6 |        37013.44 |

4 records

</div>

------------------------------------------------------------------------

**C.3 What is the top selling product for each segment?**

``` sql
WITH cte_total_quantity AS(
    SELECT 
        segment_name,
        product_name,
        SUM(qty) AS total_quantity
    FROM
        sales s
    JOIN 
        product_details pd
    ON
        s.prod_id = pd.product_id
    GROUP BY segment_name, product_name
),

cte_rn AS(
    SELECT
        segment_name,
        product_name,
        total_quantity,
        ROW_NUMBER() OVER (PARTITION BY segment_name ORDER BY total_quantity DESC) AS rn
    FROM 
        cte_total_quantity
)

SELECT
    segment_name,
    product_name,
    total_quantity
FROM
    cte_rn
WHERE rn=1;
```

<div class="knitsql-table">

| segment\_name | product\_name                 | total\_quantity |
|:--------------|:------------------------------|----------------:|
| Jacket        | Grey Fashion Jacket - Womens  |            3876 |
| Jeans         | Navy Oversized Jeans - Womens |            3856 |
| Shirt         | Blue Polo Shirt - Mens        |            3819 |
| Socks         | Navy Solid Socks - Mens       |            3792 |

4 records

</div>

------------------------------------------------------------------------

**C.4 What is the total quantity, revenue and discount for each
category?**

``` sql
SELECT
    category_name,
    SUM(qty) AS total_quantity,
    SUM(qty*s.price-(qty*s.price*discount*0.01)) AS total_revenue,
    SUM(qty*s.price*discount*0.01) AS total_discount
FROM sales s
    JOIN 
    product_details pd
    ON
        s.prod_id = pd.product_id
GROUP BY category_name;
```

<div class="knitsql-table">

| category\_name | total\_quantity | total\_revenue | total\_discount |
|:---------------|----------------:|---------------:|----------------:|
| Mens           |           22482 |       627512.3 |        86607.71 |
| Womens         |           22734 |       505711.6 |        69621.43 |

2 records

</div>

------------------------------------------------------------------------

**C.5 What is the top selling product for each category?**

``` sql
WITH cte_total_quantity AS(
    SELECT 
        category_name,
        product_name,
        SUM(qty) AS total_quantity
    FROM
        sales s
    JOIN 
        product_details pd
    ON
        s.prod_id = pd.product_id
    GROUP BY category_name, product_name
),

cte_rn AS(
    SELECT
        category_name,
        product_name,
        total_quantity,
        ROW_NUMBER() OVER (PARTITION BY category_name ORDER BY total_quantity DESC) AS rn
    FROM 
        cte_total_quantity
)

SELECT
    category_name,
    product_name,
    total_quantity
FROM
    cte_rn
WHERE rn=1;
```

<div class="knitsql-table">

| category\_name | product\_name                | total\_quantity |
|:---------------|:-----------------------------|----------------:|
| Mens           | Blue Polo Shirt - Mens       |            3819 |
| Womens         | Grey Fashion Jacket - Womens |            3876 |

2 records

</div>

------------------------------------------------------------------------

**C.6 What is the percentage split of revenue by product for each
segment?**

``` sql
WITH cte_total_revenue AS(
    SELECT
        product_id,
        segment_name,
        product_name,
        SUM(SUM(s.price*qty - (s.price*qty*discount*0.01))) OVER (PARTITION BY segment_name) AS total_revenue
    FROM
        sales s
    JOIN 
        product_details pd
    ON
        s.prod_id = pd.product_id
    GROUP BY product_id, segment_name, product_name
)

SELECT
    segment_name,
    product_name,
    FORMAT(SUM(s.price*qty - (s.price*qty*discount*0.01)) / total_revenue,'P') AS split_pct_revenue
FROM
    cte_total_revenue tr
JOIN
    sales s
ON
    s.prod_id = tr.product_id
GROUP BY segment_name, product_name, total_revenue
ORDER BY segment_name;
```

<div class="knitsql-table">

| segment\_name | product\_name                    | split\_pct\_revenue |
|:--------------|:---------------------------------|:--------------------|
| Jacket        | Indigo Rain Jacket - Womens      | 19.44%              |
| Jacket        | Grey Fashion Jacket - Womens     | 56.99%              |
| Jacket        | Khaki Suit Jacket - Womens       | 23.57%              |
| Jeans         | Cream Relaxed Jeans - Womens     | 17.82%              |
| Jeans         | Navy Oversized Jeans - Womens    | 24.04%              |
| Jeans         | Black Straight Jeans - Womens    | 58.14%              |
| Shirt         | Blue Polo Shirt - Mens           | 53.53%              |
| Shirt         | White Tee Shirt - Mens           | 37.48%              |
| Shirt         | Teal Button Up Shirt - Mens      | 8.99%               |
| Socks         | Pink Fluro Polkadot Socks - Mens | 35.57%              |

Displaying records 1 - 10

</div>

Might later add a column with cumulative percentage making it easier to
confirm percentages.

------------------------------------------------------------------------

**C.7 What is the percentage split of revenue by segment for each
category?**

``` sql
WITH cte_total_revenue AS(
    SELECT
        product_id,
        category_name,
        segment_name,
        SUM(SUM(s.price*qty - (s.price*qty*discount*0.01))) OVER (PARTITION BY category_name) AS total_revenue
    FROM
        sales s
    JOIN 
        product_details pd
    ON
        s.prod_id = pd.product_id
    GROUP BY product_id, category_name, segment_name
)

SELECT
    category_name,
    segment_name,
    FORMAT(SUM(s.price*qty - (s.price*qty*discount*0.01)) / total_revenue,'P') AS split_pct_revenue
FROM
    cte_total_revenue tr
JOIN
    sales s
ON
    s.prod_id = tr.product_id
GROUP BY category_name, segment_name, total_revenue
ORDER BY category_name;
```

<div class="knitsql-table">

| category\_name | segment\_name | split\_pct\_revenue |
|:---------------|:--------------|:--------------------|
| Mens           | Shirt         | 56.82%              |
| Mens           | Socks         | 43.18%              |
| Womens         | Jacket        | 63.81%              |
| Womens         | Jeans         | 36.19%              |

4 records

</div>

------------------------------------------------------------------------

**C.8 What is the percentage split of total revenue by category?**

``` sql
SELECT
    DISTINCT category_name,
    FORMAT(SUM(s.price*qty - (s.price*qty*discount*0.01)) OVER(PARTITION BY category_name) / 
    SUM(s.price*qty - (s.price*qty*discount*0.01)) OVER(), 'P') AS split_pct_revenue
FROM
    sales s
JOIN
    product_details pd
ON
    s.prod_id = pd.product_id;
```

<div class="knitsql-table">

| category\_name | split\_pct\_revenue |
|:---------------|:--------------------|
| Mens           | 55.37%              |
| Womens         | 44.63%              |

2 records

</div>

------------------------------------------------------------------------

**C.9 What is the total transaction “penetration” for each product?
(hint: penetration = number of transactions where at least 1 quantity of
a product was purchased divided by total number of transactions)**

To be continued
