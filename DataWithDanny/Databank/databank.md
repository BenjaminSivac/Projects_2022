Data With Danny: Data Bank
================
Benjamin Sivac
2022-03-19

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/Databank/figure-gfm/dwd_pic.png"
       height="850px" width="850px"/>
</p>

### Task

There is a new innovation in the financial industry called Neo-Banks:
new aged digital only banks without physical branches.

Danny thought that there should be some sort of intersection between
these new age banks, cryptocurrency and the data world…so he decides to
launch a new initiative - Data Bank!

Data Bank runs just like any other digital bank - but it isn’t only for
banking activities, they also have the world’s most secure distributed
data storage platform!

Customers are allocated cloud data storage limits which are directly
linked to how much money they have in their accounts. There are a few
interesting caveats that go with this business model, and this is where
the Data Bank team need your help!

The management team at Data Bank want to increase their total customer
base - but also need some help tracking just how much data storage their
customers will need.

This case study is all about calculating metrics, growth and helping the
business analyse their data in a smart way to better forecast and plan
for their future developments!

### Avaiable Data

The Data Bank team have prepared a data model for this case study as
well as a few example rows from the complete dataset below to get you
familiar with their tables.

#### Entity Relationship Diagram

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/Databank/figure-gfm/erd.png"/>
</p>

#### Table 1: Regions

Just like popular cryptocurrency platforms - Data Bank is also run off a
network of nodes where both money and data is stored across the globe.
In a traditional banking sense - you can think of these nodes as bank
branches or stores that exist around the world.

This regions table contains the region\_id and their respective
region\_name values

<div class="knitsql-table">

| region\_id | region\_name |
|:-----------|:-------------|
| 1          | Australia    |
| 2          | America      |
| 3          | Africa       |
| 4          | Asia         |
| 5          | Europe       |

5 records

</div>

#### Table 2: Customer Nodes

Customers are randomly distributed across the nodes according to their
region - this also specifies exactly which node contains both their cash
and data.

This random distribution changes frequently to reduce the risk of
hackers getting into Data Bank’s system and stealing customer’s money
and data!

Below is a sample of the top 10 rows of the data\_bank.customer\_nodes

<div class="knitsql-table">

| customer\_id | region\_id | node\_id | start\_date | end\_date  |
|:-------------|-----------:|---------:|:------------|:-----------|
| 1            |          3 |        4 | 2020-01-02  | 2020-01-03 |
| 2            |          3 |        5 | 2020-01-03  | 2020-01-17 |
| 3            |          5 |        4 | 2020-01-27  | 2020-02-18 |
| 4            |          5 |        4 | 2020-01-07  | 2020-01-19 |
| 5            |          3 |        3 | 2020-01-15  | 2020-01-23 |
| 6            |          1 |        1 | 2020-01-11  | 2020-02-06 |
| 7            |          2 |        5 | 2020-01-20  | 2020-02-04 |
| 8            |          1 |        2 | 2020-01-15  | 2020-01-28 |
| 9            |          4 |        5 | 2020-01-21  | 2020-01-25 |
| 10           |          3 |        4 | 2020-01-13  | 2020-01-14 |

Displaying records 1 - 10

</div>

#### Table 3: Customer Transactions

This table stores all customer deposits, withdrawals and purchases made
using their Data Bank debit card.

<div class="knitsql-table">

| customer\_id | txn\_date  | txn\_type | txn\_amount |
|-------------:|:-----------|:----------|------------:|
|          429 | 2020-01-21 | deposit   |          82 |
|          155 | 2020-01-10 | deposit   |         712 |
|          398 | 2020-01-01 | deposit   |         196 |
|          255 | 2020-01-14 | deposit   |         563 |
|          185 | 2020-01-29 | deposit   |         626 |
|          309 | 2020-01-13 | deposit   |         995 |
|          312 | 2020-01-20 | deposit   |         485 |
|          376 | 2020-01-03 | deposit   |         706 |
|          188 | 2020-01-13 | deposit   |         601 |
|          138 | 2020-01-11 | deposit   |         520 |

Displaying records 1 - 10

</div>

### Case Study Questions

The following case study questions include some general data exploration
analysis for the nodes and transactions before diving right into the
core business questions and finishes with a challenging final request!

#### A. Customer Nodes Exploration

**A.1 How many unique nodes are there on the Data Bank system?**

``` sql
SELECT 
  COUNT(DISTINCT node_id) AS Unique_Nodes
FROM 
  dbo.customer_nodes
```

<div class="knitsql-table">

| Unique\_Nodes |
|--------------:|
|             5 |

1 records

</div>

------------------------------------------------------------------------

**A.2 What is the number of nodes per region?**

``` sql
SELECT 
  r.region_id, 
  r.region_name,
  COUNT(node_id) AS Number_of_nodes
FROM 
  dbo.customer_nodes n
JOIN 
  dbo.regions r
      ON n.region_id = r.region_id
GROUP BY r.region_id, region_name 
ORDER BY region_id;
```

<div class="knitsql-table">

| region\_id | region\_name | Number\_of\_nodes |
|:-----------|:-------------|------------------:|
| 1          | Australia    |               770 |
| 2          | America      |               735 |
| 3          | Africa       |               714 |
| 4          | Asia         |               665 |
| 5          | Europe       |               616 |

5 records

</div>

------------------------------------------------------------------------

**A.3 How many customers are allocated to each region?**

``` sql
SELECT 
    region_id, 
    COUNT(DISTINCT customer_id) AS Number_of_Customers
FROM dbo.customer_nodes
GROUP BY region_id
ORDER BY region_id;
```

<div class="knitsql-table">

| region\_id | Number\_of\_Customers |
|:-----------|----------------------:|
| 1          |                   110 |
| 2          |                   105 |
| 3          |                   102 |
| 4          |                    95 |
| 5          |                    88 |

5 records

</div>

------------------------------------------------------------------------

**A.4 How many days on average are customers reallocated to a different
node?** 

Not entirely sure that I understood the question. I interpret it
as “*After* how many days…”, rather than “How many *times*…”, on average
are they reallocated.

``` sql
WITH cte_day_diff AS (
    SELECT 
    customer_id, 
    node_id,
    start_date,
    end_date,
    DATEDIFF(day,start_date, end_date) AS diff
FROM    
    dbo.customer_nodes
WHERE end_date != '9999-12-31'
GROUP BY customer_id, node_id, start_date, end_date), 
cte_sum_diff AS (
    SELECT 
        customer_id, node_id, sum(diff) AS sum_diff
        FROM cte_day_diff
        GROUP BY customer_id, node_id)

SELECT 
  AVG(sum_diff) AS avg_reallocation_days
FROM cte_sum_diff; 
```

<div class="knitsql-table">

| avg\_reallocation\_days |
|------------------------:|
|                      23 |

1 records

</div>

------------------------------------------------------------------------

**A.5 What is the median, 80th and 95th percentile for this same
reallocation days metric for each region?** 

Re-used the same CTE from quesiton 4 and added another select query utilizing percentile\_disc
functions, returning a current value rather than an interpolated value.

``` sql
WITH cte_day_diff AS (
    SELECT 
    region_id, 
    node_id,
    start_date,
    end_date,
    DATEDIFF(day,start_date, end_date) AS diff
FROM    
    dbo.customer_nodes
WHERE end_date != '9999-12-31'
GROUP BY region_id, node_id, start_date, end_date 
)

SELECT
    DISTINCT d.region_id,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY diff) 
    OVER (PARTITION BY d.region_id) AS Median,
    PERCENTILE_DISC(0.8) WITHIN GROUP (ORDER BY diff) 
    OVER (PARTITION BY d.region_id) AS eighty_centile,
    PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY diff) 
    OVER (PARTITION BY d.region_id) AS ninetyfive_centile
FROM
    cte_day_diff AS d
    JOIN dbo.regions r
    ON 
        d.region_id = r.region_id
GROUP BY d.region_id, diff
ORDER BY d.region_id
```

<div class="knitsql-table">

| region\_id | Median | eighty\_centile | ninetyfive\_centile |
|:-----------|-------:|----------------:|--------------------:|
| 1          |     15 |              24 |                  29 |
| 2          |     15 |              24 |                  29 |
| 3          |     15 |              24 |                  29 |
| 4          |     15 |              24 |                  29 |
| 5          |     15 |              24 |                  29 |

5 records

</div>

------------------------------------------------------------------------

#### B. Customer Transactions

**B.1 What is the unique count and total amount for each transaction
type?**

``` sql
SELECT 
  txn_type, 
  COUNT(txn_type) AS count, 
  SUM(txn_amount) AS total_amount
FROM dbo.customer_transactions
GROUP BY txn_type
```

<div class="knitsql-table">

| txn\_type  | count | total\_amount |
|:-----------|------:|--------------:|
| withdrawal |  1580 |        793003 |
| deposit    |  2671 |       1359168 |
| purchase   |  1617 |        806537 |

3 records

</div>

------------------------------------------------------------------------

**B.2 What is the average total historical deposit counts and amounts for
all customers?** 

Making do with just a subquery over another CTE.

``` sql
SELECT 
  AVG(t.counts) AS average_deposit_count, 
  AVG(t.sums) AS average_amount
FROM 
  (SELECT COUNT(txn_type) AS counts, AVG(txn_amount) AS sums
        FROM 
          dbo.customer_transactions
        WHERE txn_type = 'deposit'
        GROUP BY customer_id) AS t
```

<div class="knitsql-table">

| average\_deposit\_count | average\_amount |
|------------------------:|----------------:|
|                       5 |             508 |

1 records

</div>

------------------------------------------------------------------------

**B.3 For each month - how many Data Bank customers make more than 1
deposit and either 1 purchase or 1 withdrawal in a single month?** 

Using case expression to create a counter for each transaction type and then
issuing proper filter conditions.

``` sql
WITH month_transactions AS (
    SELECT 
      MONTH(txn_date) AS month,
        customer_id, 
        SUM(CASE WHEN txn_type = 'deposit' THEN 0 ELSE 1 END) AS count_deposit,
        SUM(CASE WHEN txn_type = 'purchase' THEN 0 ELSE 1 END) AS count_purchase,
        SUM(CASE WHEN txn_type = 'withdrawal' THEN 0 ELSE 1 END) AS count_withdrawal
    FROM 
      dbo.customer_transactions 
    GROUP BY customer_id, MONTH(txn_date))

SELECT 
  month, 
  COUNT(customer_id) AS count
FROM 
  month_transactions
WHERE count_deposit > 1
AND (count_purchase = 1 OR count_withdrawal = 1)
GROUP BY month;
```

<div class="knitsql-table">

| month | count |
|:------|------:|
| 1     |    24 |
| 2     |    54 |
| 3     |    57 |
| 4     |    26 |

4 records

</div>

------------------------------------------------------------------------

**B.4 What is the closing balance for each customer at the end of the
month?** 

Could have utilized more CTE’s for more readability, but I
prefer it being more compact. Note that I will revisit at a later point
to fill in for months with no transactions!

``` sql
WITH cte_closing_balance AS (
    SELECT 
        customer_id,
        EOMONTH(txn_date) AS end_of_month,
        SUM(txn_amount*CASE WHEN txn_type = 'deposit' THEN 1
            ELSE -1 END) AS closing_balance,
        ROW_NUMBER() OVER (PARTITION BY customer_id, MONTH(txn_date) ORDER BY DAY(txn_date) DESC) AS txn_order
    FROM
        dbo.customer_transactions
    GROUP BY customer_id, txn_date)

SELECT 
    customer_id,
    end_of_month,
    closing_balance 
FROM 
  cte_closing_balance
WHERE txn_order = 1
ORDER BY customer_id, end_of_month
```

<div class="knitsql-table">

| customer\_id | end\_of\_month | closing\_balance |
|-------------:|:---------------|-----------------:|
|            1 | 2020-01-31     |              312 |
|            1 | 2020-03-31     |             -664 |
|            2 | 2020-01-31     |              549 |
|            2 | 2020-03-31     |               61 |
|            3 | 2020-01-31     |              144 |
|            3 | 2020-02-29     |             -965 |
|            3 | 2020-03-31     |             -188 |
|            3 | 2020-04-30     |              493 |
|            4 | 2020-01-31     |              390 |
|            4 | 2020-03-31     |             -193 |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**B.5 What is the percentage of customers who increase their closing
balance by more than 5%?** 

Again, trying to minimize the amount of CTE’s
but I still ended up making 4 of them. We use DISTINCT in the end to get
the percentage of customers who at least once experienced more than 5%
growth.

``` sql
WITH cte_closing_balance AS (
    SELECT 
        customer_id,
        EOMONTH(txn_date) AS end_of_month,
        SUM(txn_amount*CASE WHEN txn_type = 'deposit' THEN 1
            ELSE -1 END) AS closing_balance,
        ROW_NUMBER() OVER (PARTITION BY customer_id, MONTH(txn_date) ORDER BY DAY(txn_date) DESC) AS txn_order
    FROM
        dbo.customer_transactions
    GROUP BY customer_id, txn_date),

cte_lead_balance AS(
SELECT
    customer_id,
    end_of_month,
    closing_balance,
    txn_order,
    LEAD(closing_balance) OVER (PARTITION BY customer_id ORDER BY end_of_month) AS next_balance
FROM 
  cte_closing_balance
WHERE txn_order = 1
),

cte_percent_growth AS (
SELECT
    customer_id,
    end_of_month,
    closing_balance,
    next_balance,
    FORMAT(CASE 
        WHEN closing_balance = 0 THEN NULL 
        WHEN closing_balance < 0 THEN ((CAST(next_balance AS FLOAT) - CAST(closing_balance AS FLOAT)) / CAST(closing_balance AS FLOAT)) * -1
        ELSE ((CAST(next_balance AS FLOAT)- CAST(closing_balance AS FLOAT)) / CAST(closing_balance AS FLOAT))
    END, 'P') AS percent_growth
FROM 
  cte_lead_balance
),

cte_filter AS (
SELECT
    customer_id,
    end_of_month,
    closing_balance,
    next_balance,
    percent_growth
FROM
    cte_percent_growth
GROUP BY customer_id, end_of_month, closing_balance, next_balance, percent_growth
HAVING percent_growth > FORMAT(5, 'P') -- We make another CTE as the prior one can't filter by the different case clauses.
AND percent_growth NOT LIKE '-%')

SELECT 
    FORMAT(ROUND(CAST(COUNT(DISTINCT customer_id) AS FLOAT) / (SELECT CAST(COUNT(DISTINCT customer_id) AS FLOAT)
FROM 
  cte_percent_growth),2), 'P') AS percentage_of_customers
FROM 
  cte_filter; 
```

<div class="knitsql-table">

| percentage\_of\_customers |
|:--------------------------|
| 28.00%                    |

1 records

</div>

------------------------------------------------------------------------
