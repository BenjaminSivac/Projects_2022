Data With Danny: Clique Bait
================
Benjamin Sivac
2022-04-24

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/CliqueBait/figure-gfm/dwd6.png"
       height="850px" width="850px"/>
</p>

### Introduction

Clique Bait is not like your regular online seafood store - the founder
and CEO Danny, was also a part of a digital data analytics team and
wanted to expand his knowledge into the seafood industry!

In this case study - you are required to support Danny’s vision and
analyse his dataset and come up with creative solutions to calculate
funnel fallout rates for the Clique Bait online store.

### Available Data

For this case study there is a total of 5 datasets which you will need
to combine to solve all of the questions.

**Users**

Customers who visit the Clique Bait website are tagged via their
cookie\_id.

<div class="knitsql-table">

| user\_id | cookie\_id | start\_date |
|:---------|:-----------|:------------|
| 1        | c4ca42     | 2020-02-04  |
| 2        | c81e72     | 2020-01-18  |
| 3        | eccbc8     | 2020-02-21  |
| 4        | a87ff6     | 2020-02-22  |
| 5        | e4da3b     | 2020-02-01  |
| 6        | 167909     | 2020-01-25  |
| 7        | 8f14e4     | 2020-02-09  |
| 8        | c9f0f8     | 2020-02-12  |
| 9        | 45c48c     | 2020-02-07  |
| 10       | d3d944     | 2020-01-23  |

Displaying records 1 - 10

</div>

**Events**

Customer visits are logged in this events table at a cookie\_id level
and the event\_type and page\_id values can be used to join onto
relevant satellite tables to obtain further information about each
event.

The sequence\_number is used to order the events within each visit.

<div class="knitsql-table">

| visit\_id | cookie\_id | page\_id | event\_type | sequence\_number | event\_time                 |
|:----------|:-----------|---------:|------------:|-----------------:|:----------------------------|
| ccf365    | c4ca42     |        1 |           1 |                1 | 2020-02-04 19:16:09.1825460 |
| ccf365    | c4ca42     |        2 |           1 |                2 | 2020-02-04 19:16:17.3581910 |
| ccf365    | c4ca42     |        6 |           1 |                3 | 2020-02-04 19:16:58.4546690 |
| ccf365    | c4ca42     |        9 |           1 |                4 | 2020-02-04 19:16:58.6091420 |
| ccf365    | c4ca42     |        9 |           2 |                5 | 2020-02-04 19:17:51.7294200 |
| ccf365    | c4ca42     |       10 |           1 |                6 | 2020-02-04 19:18:11.6058150 |
| ccf365    | c4ca42     |       10 |           2 |                7 | 2020-02-04 19:19:10.5707860 |
| ccf365    | c4ca42     |       11 |           1 |                8 | 2020-02-04 19:19:46.9117280 |
| ccf365    | c4ca42     |       11 |           2 |                9 | 2020-02-04 19:20:45.2746900 |
| ccf365    | c4ca42     |       12 |           1 |               10 | 2020-02-04 19:20:52.3072440 |

Displaying records 1 - 10

</div>

**Event Identifier**

The event\_identifier table shows the types of events which are captured
by Clique Bait’s digital data systems.

<div class="knitsql-table">

| event\_type | event\_name   |
|:------------|:--------------|
| 1           | Page View     |
| 2           | Add to Cart   |
| 3           | Purchase      |
| 4           | Ad Impression |
| 5           | Ad Click      |

5 records

</div>

**Campaign Identifier**

This table shows information for the 3 campaigns that Clique Bait has
ran on their website so far in 2020.

<div class="knitsql-table">

| campaign\_id | products | campaign\_name                    | start\_date | end\_date  |
|:-------------|:---------|:----------------------------------|:------------|:-----------|
| 1            | 1-3      | BOGOF - Fishing For Compliments   | 2020-01-01  | 2020-01-14 |
| 2            | 4-5      | 25% Off - Living The Lux Life     | 2020-01-15  | 2020-01-28 |
| 3            | 6-8      | Half Off - Treat Your Shellf(ish) | 2020-02-01  | 2020-03-31 |

3 records

</div>

**Page Hierarchy**

This table lists all of the pages on the Clique Bait website which are
tagged and have data passing through from user interaction events.

<div class="knitsql-table">

| page\_id | page\_name     | product\_category | product\_id |
|:---------|:---------------|:------------------|------------:|
| 1        | Home Page      | NA                |          NA |
| 2        | All Products   | NA                |          NA |
| 3        | Salmon         | Fish              |           1 |
| 4        | Kingfish       | Fish              |           2 |
| 5        | Tuna           | Fish              |           3 |
| 6        | Russian Caviar | Luxury            |           4 |
| 7        | Black Truffle  | Luxury            |           5 |
| 8        | Abalone        | Shellfish         |           6 |
| 9        | Lobster        | Shellfish         |           7 |
| 10       | Crab           | Shellfish         |           8 |

Displaying records 1 - 10

</div>

### Case Study Questions

#### A. Digital Analysis

Using the available datasets - answer the following questions using a
single query for each one:

**1.How many users are there?**

``` sql
SELECT 
    COUNT(DISTINCT user_id) AS nbr_users
FROM
    clique_bait.users;
```

<div class="knitsql-table">

| nbr\_users |
|-----------:|
|        500 |

1 records

</div>

------------------------------------------------------------------------

**2.How many cookies does each user have on average?**

``` sql
SELECT 
    AVG(count) AS avg_nbr_cookies
FROM
    (SELECT 
            user_id,
            COUNT(cookie_id) AS count
    FROM 
        clique_bait.users
    GROUP BY user_id) AS countd_cookies;
```

<div class="knitsql-table">

| avg\_nbr\_cookies |
|------------------:|
|                 3 |

1 records

</div>

------------------------------------------------------------------------

**3. What is the unique number of visits by all users per month?**

``` sql
SELECT
    MONTH(event_time) AS month,
    COUNT(DISTINCT visit_id) AS unique_visits
FROM
    clique_bait.events
GROUP BY MONTH(event_time)
ORDER BY MONTH(event_time);
```

<div class="knitsql-table">

| month | unique\_visits |
|:------|---------------:|
| 1     |            876 |
| 2     |           1488 |
| 3     |            916 |
| 4     |            248 |
| 5     |             36 |

5 records

</div>

------------------------------------------------------------------------

**4. What is the number of events for each event type?**

``` sql
SELECT
    event_name,
    COUNT(*) AS nbr_events
FROM
    clique_bait.events ev 
JOIN
    clique_bait.event_identifier id
ON  ev.event_type = id.event_type
GROUP BY event_name
ORDER BY nbr_events DESC
```

<div class="knitsql-table">

| event\_name   | nbr\_events |
|:--------------|------------:|
| Page View     |       20928 |
| Add to Cart   |        8451 |
| Purchase      |        1777 |
| Ad Impression |         876 |
| Ad Click      |         702 |

5 records

</div>

------------------------------------------------------------------------

**5. What is the percentage of visits which have a purchase event?**

``` sql
SELECT
    FORMAT(0.01 * COUNT(DISTINCT visit_id)
    / (SELECT COUNT(DISTINCT visit_id) FROM clique_bait.events), 'P') AS pct_purchase
FROM
    clique_bait.events
WHERE event_type=3
```

<div class="knitsql-table">

| pct\_purchase |
|:--------------|
| 0.50%         |

1 records

</div>

------------------------------------------------------------------------

**6. What is the percentage of visits which view the checkout page but
do not have a purchase event?**

``` sql
WITH cte_checkout_purchase AS (
    SELECT
        MAX(CASE WHEN event_type = 3 THEN 1 ELSE 0 END) AS purchase,
        MAX(CASE WHEN page_id = 12 THEN 1 ELSE 0 END) AS checkout
    FROM 
        clique_bait.events
    GROUP BY visit_id
)

SELECT 
  FORMAT(CAST(SUM(checkout) - SUM(purchase) AS FLOAT) / SUM(checkout), 'P') as pct_visits_no_purchase
FROM cte_checkout_purchase;
```

<div class="knitsql-table">

| pct\_visits\_no\_purchase |
|:--------------------------|
| 15.50%                    |

1 records

</div>

------------------------------------------------------------------------

**7. What are the top 3 pages by number of views?**

``` sql
SELECT TOP 3 
    page_name,
    COUNT(*) as nbr_views
FROM
    clique_bait.events ev 
JOIN
    clique_bait.page_hierarchy ph
ON  ev.page_id = ph.page_id
GROUP BY page_name
ORDER BY nbr_views DESC;
```

<div class="knitsql-table">

| page\_name   | nbr\_views |
|:-------------|-----------:|
| All Products |       4752 |
| Lobster      |       2515 |
| Crab         |       2513 |

3 records

</div>

------------------------------------------------------------------------

**8. What is the number of views and cart adds for each product
category?**

``` sql
SELECT
    product_category,
    SUM(CASE WHEN event_type = 1 THEN 1 ELSE 0 END) AS views,
    SUM(CASE WHEN event_type = 2 THEN 1 ELSE 0 END) AS cart_adds
FROM
    clique_bait.events ev
JOIN
    clique_bait.page_hierarchy ph
ON
    ev.page_id = ph.page_id
WHERE product_category IS NOT NULL
GROUP BY product_category;
```

<div class="knitsql-table">

| product\_category | views | cart\_adds |
|:------------------|------:|-----------:|
| Fish              |  4633 |       2789 |
| Luxury            |  3032 |       1870 |
| Shellfish         |  6204 |       3792 |

3 records

</div>

------------------------------------------------------------------------

**9. What are the top 3 products by purchases?**

``` sql
SELECT TOP 3
    page_name,
    SUM(CASE WHEN event_type = 2 THEN 1 ELSE 0 END) AS bought
FROM
    clique_bait.events ev1
JOIN
    clique_bait.page_hierarchy ph
ON
    ev1.page_id = ph.page_id
WHERE EXISTS (SELECT 1 FROM clique_bait.events ev2 WHERE ev1.visit_id = ev2.visit_id AND ev2.event_type=3)
GROUP BY page_name
ORDER BY bought DESC;
```

<div class="knitsql-table">

| page\_name | bought |
|:-----------|-------:|
| Lobster    |    754 |
| Oyster     |    726 |
| Crab       |    719 |

3 records

</div>

------------------------------------------------------------------------

#### B. Product Funnel Analysis

Using a single SQL query - create a new output table which has the
following details:

-   **How many times was each product viewed?**
-   **How many times was each product added to cart?**
-   **How many times was each product added to a cart but not purchased
    (abandoned)?**
-   **How many times was each product purchased?**

``` sql
WITH cte_t1 AS (
    SELECT
        page_name,
        SUM(CASE WHEN ev.event_type = 1 THEN 1 ELSE 0 END) AS product_view,
        SUM(CASE WHEN ev.event_type = 2 THEN 1 ELSE 0 END) AS added_to_cart
    FROM
        clique_bait.events ev
    JOIN
        clique_bait.page_hierarchy ph
    ON ev.page_id = ph.page_id
    WHERE product_id IS NOT NULL
    GROUP BY page_name
),

cte_bought AS (
    SELECT
        page_name,
        SUM(CASE WHEN event_type = 2 THEN 1 ELSE 0 END) AS bought
    FROM
        clique_bait.events ev1
    JOIN
        clique_bait.page_hierarchy ph
    ON ev1.page_id = ph.page_id
    WHERE EXISTS (SELECT 1 FROM clique_bait.events ev2 WHERE ev1.visit_id = ev2.visit_id AND ev2.event_type=3) 
        AND product_id IS NOT NULL
    GROUP BY page_name
),

cte_not_bought AS (
    SELECT
        page_name,
        SUM(CASE WHEN event_type = 2 THEN 1 ELSE 0 END) AS abandoned
    FROM
        clique_bait.events ev1
    JOIN
        clique_bait.page_hierarchy ph
    ON ev1.page_id = ph.page_id
    WHERE NOT EXISTS (SELECT 1 FROM clique_bait.events ev2 WHERE ev1.visit_id = ev2.visit_id AND ev2.event_type = 3) 
        AND product_id IS NOT NULL
    GROUP BY page_name
)

SELECT
    t.page_name AS product_name,
    product_view,
    added_to_cart,
    abandoned,
    bought

FROM
    cte_t1 t
JOIN
    cte_bought bt
    ON t.page_name = bt.page_name
JOIN
    cte_not_bought nbt
    ON t.page_name = nbt.page_name;
```

<div class="knitsql-table">

| product\_name  | product\_view | added\_to\_cart | abandoned | bought |
|:---------------|--------------:|----------------:|----------:|-------:|
| Abalone        |          1525 |             932 |       233 |    699 |
| Black Truffle  |          1469 |             924 |       217 |    707 |
| Crab           |          1564 |             949 |       230 |    719 |
| Kingfish       |          1559 |             920 |       213 |    707 |
| Lobster        |          1547 |             968 |       214 |    754 |
| Oyster         |          1568 |             943 |       217 |    726 |
| Russian Caviar |          1563 |             946 |       249 |    697 |
| Salmon         |          1559 |             938 |       227 |    711 |
| Tuna           |          1515 |             931 |       234 |    697 |

9 records

</div>

------------------------------------------------------------------------

**Additionally, create another table which further aggregates the data
for the above points but this time for each product category instead of
individual products.**

``` sql
SELECT
    product_category,
    SUM(product_view) AS views,
    SUM(added_to_cart) AS added_to_carts,
    SUM(abandoned) AS abandoned,
    SUM(bought) AS bought
FROM
    #temp_products tp
LEFT JOIN 
    clique_bait.page_hierarchy ph
    ON  tp.product_name = ph.page_name
GROUP BY product_category;
```

<div class="knitsql-table">

| product\_category | views | added\_to\_carts | abandoned | bought |
|:------------------|------:|-----------------:|----------:|-------:|
| Fish              |  4633 |             2789 |       674 |   2115 |
| Luxury            |  3032 |             1870 |       466 |   1404 |
| Shellfish         |  6204 |             3792 |       894 |   2898 |

3 records

</div>

I turned the previous table into a temporary table called
***\#temp\_products*** so I did not have to repeat all the code.

------------------------------------------------------------------------

Use your 2 new output tables - answer the following questions:

**Which product had the most views, cart adds and purchases?**

``` sql
SELECT TOP 1
    (SELECT TOP 1 product_name FROM #temp_products ORDER BY product_view DESC) AS most_views,
    (SELECT TOP 1 product_name FROM #temp_products ORDER BY added_to_cart DESC) AS most_added_to_cart,
    (SELECT TOP 1 product_name FROM #temp_products ORDER BY bought DESC) AS most_bought
FROM
    #temp_products;
```

<div class="knitsql-table">

| most\_views | most\_added\_to\_cart | most\_bought |
|:------------|:----------------------|:-------------|
| Oyster      | Lobster               | Lobster      |

1 records

</div>

------------------------------------------------------------------------

**Which product was most likely to be abandoned?**

``` sql
SELECT TOP 1
    product_name AS most_abandoned
FROM
    #temp_products
ORDER BY abandoned DESC;
```

<div class="knitsql-table">

| most\_abandoned |
|:----------------|
| Russian Caviar  |

1 records

</div>

------------------------------------------------------------------------

**Which product had the highest view to purchase percentage?**

``` sql
SELECT TOP 1 
    product_name,
    FORMAT(ROUND(CAST(bought AS FLOAT)/product_view,3), 'P') AS view_to_purchase_pct
FROM
    #temp_products
ORDER BY view_to_purchase_pct DESC;
```

<div class="knitsql-table">

| product\_name | view\_to\_purchase\_pct |
|:--------------|:------------------------|
| Lobster       | 48.70%                  |

1 records

</div>

------------------------------------------------------------------------

**What is the average conversion rate from view to cart add?**

``` sql
SELECT
    FORMAT(ROUND(AVG(CAST(added_to_cart AS FLOAT)/product_view),3), 'P') AS avg_cart_add_conversion
FROM
    #temp_products;
```

<div class="knitsql-table">

| avg\_cart\_add\_conversion |
|:---------------------------|
| 61.00%                     |

1 records

</div>

------------------------------------------------------------------------

**What is the average conversion rate from cart add to purchase?**

``` sql
SELECT
    FORMAT(ROUND(AVG(CAST(bought AS FLOAT)/added_to_cart),3), 'P') AS avg_purchase_conversion
FROM
    #temp_products;
```

<div class="knitsql-table">

| avg\_purchase\_conversion |
|:--------------------------|
| 75.90%                    |

1 records

</div>

------------------------------------------------------------------------

#### C. Campaigns Analysis

Generate a table that has 1 single row for every unique visit\_id record
and has the following columns:

-   **user\_id**
-   **visit\_id**
-   **visit\_start\_time**: the earliest event\_time for each visit
-   **page\_views**: count of page views for each visit
-   **cart\_adds**: count of product cart add events for each visit
-   **purchase**: 1/0 flag if a purchase event exists for each visit
-   **campaign\_name**: map the visit to a campaign if the
    visit\_start\_time falls between the start\_date and end\_date
-   **impression**: count of ad impressions for each visit
-   **click**: count of ad clicks for each visit
-   **(Optional column) cart\_products**: a comma separated text value
    with products added to the cart sorted by the order they were added
    to the cart (hint: use the sequence\_number)

``` sql
SELECT
    user_id,
    visit_id,
    MIN(event_time) AS visit_start_time,
    SUM(1) AS page_views,
    SUM(CASE WHEN event_type=2 THEN 1 ELSE 0 END)  AS cart_adds,
    MAX(CASE WHEN event_type=3 THEN 1 ELSE 0 END) AS purchase,
    c_id.campaign_name,
    SUM(CASE WHEN event_type=4 THEN 1 ELSE 0 END) AS impression,
    SUM(CASE WHEN event_type=5 THEN 1 ELSE 0 END) AS click,
    STRING_AGG(CASE 
                  WHEN ph.product_id IS NOT NULL AND ev.event_type=2 
                  THEN ph.page_name ELSE NULL END, ', ') 
                  WITHIN GROUP (ORDER BY sequence_number) AS cart_products
FROM
    clique_bait.events ev
INNER JOIN
	clique_bait.users u
	ON 
		ev.cookie_id = u.cookie_id
LEFT JOIN
	clique_bait.campaign_identifier c_id
	ON
		ev.event_time BETWEEN c_id.start_date AND c_id.end_date
LEFT JOIN
	clique_bait.page_hierarchy ph
	ON
		ev.page_id = ph.page_id
GROUP BY user_id, visit_id, campaign_name
```

<div class="knitsql-table">

| user\_id | visit\_id | visit\_start\_time          | page\_views | cart\_adds | purchase | campaign\_name                    | impression | click | cart\_products                                                              |
|---------:|:----------|:----------------------------|------------:|-----------:|---------:|:----------------------------------|-----------:|------:|:----------------------------------------------------------------------------|
|        1 | 02a5d5    | 2020-02-26 16:57:26.2608710 |           4 |          0 |        0 | Half Off - Treat Your Shellf(ish) |          0 |     0 | NA                                                                          |
|        1 | 0826dc    | 2020-02-26 05:58:37.9186180 |           1 |          0 |        0 | Half Off - Treat Your Shellf(ish) |          0 |     0 | NA                                                                          |
|        1 | 0fc437    | 2020-02-04 17:49:49.6029760 |          19 |          6 |        1 | Half Off - Treat Your Shellf(ish) |          1 |     1 | Tuna, Russian Caviar, Black Truffle, Abalone, Crab, Oyster                  |
|        1 | 30b94d    | 2020-03-15 13:12:54.0239360 |          19 |          7 |        1 | Half Off - Treat Your Shellf(ish) |          1 |     1 | Salmon, Kingfish, Tuna, Russian Caviar, Abalone, Lobster, Crab              |
|        1 | 41355d    | 2020-03-25 00:11:17.8606550 |           7 |          1 |        0 | Half Off - Treat Your Shellf(ish) |          0 |     0 | Lobster                                                                     |
|        1 | ccf365    | 2020-02-04 19:16:09.1825460 |          11 |          3 |        1 | Half Off - Treat Your Shellf(ish) |          0 |     0 | Lobster, Crab, Oyster                                                       |
|        1 | eaffde    | 2020-03-25 20:06:32.3429890 |          21 |          8 |        1 | Half Off - Treat Your Shellf(ish) |          1 |     1 | Salmon, Tuna, Russian Caviar, Black Truffle, Abalone, Lobster, Crab, Oyster |
|        1 | f7c798    | 2020-03-15 02:23:26.3125430 |          13 |          3 |        1 | Half Off - Treat Your Shellf(ish) |          0 |     0 | Russian Caviar, Crab, Oyster                                                |
|        2 | 0635fb    | 2020-02-16 06:42:42.7357300 |          14 |          4 |        1 | Half Off - Treat Your Shellf(ish) |          0 |     0 | Salmon, Kingfish, Abalone, Crab                                             |
|        2 | 1f1198    | 2020-02-01 21:51:55.0787750 |           1 |          0 |        0 | Half Off - Treat Your Shellf(ish) |          0 |     0 | NA                                                                          |

Displaying records 1 - 10

</div>

Pretty clean. I first planned to filter everything on first
sequence\_number by adding another join, and just SUM by partition of
visit\_id for each column, but STRING\_AGG() wasn’t “a valid windowing
function” and it “cannot be used with the OVER() clause”, so I settled
on using group by instead and removed the partitions. I also learnt that
it’s possible to join tables by time !
