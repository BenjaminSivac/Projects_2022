Data With Danny: Foodie-Fi
================
Benjamin Sivac
2022-04-01

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/Foodie-Fi/figure-gfm/dwd_ff.png"
       height="850px" width="850px"/>
</p>

### Introduction

Subscription based businesses are super popular and Danny realised that
there was a large gap in the market - he wanted to create a new
streaming service that only had food related content - something like
Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in
2020 and started selling monthly and annual subscriptions, giving their
customers unlimited on-demand access to exclusive food videos from
around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure
all future investment decisions and new features were decided using
data. This case study focuses on using subscription style digital data
to answer important business questions.

### Available Data

Danny has shared the data design for Foodie-Fi and also short
descriptions on each of the database tables - our case study focuses on
only 2 tables but there will be a challenge to create a new table for
the Foodie-Fi team.

All datasets exist within the foodie\_fi database schema - be sure to
include this reference within your SQL scripts as you start exploring
the data and answering the case study questions.

#### Entity Relationship Diagram

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/Foodie-Fi/figure-gfm/erd_ff.png"/>
</p>


#### Table 1: plans

Customers can choose which plans to join Foodie-Fi when they first sign
up.

Basic plan customers have limited access and can only stream their
videos and is only available monthly at $9.90

Pro plan customers have no watch time limits and are able to download
videos for offline viewing. Pro plans start at $19.90 a month or $199
for an annual subscription.

Customers can sign up to an initial 7 day free trial will automatically
continue with the pro monthly subscription plan unless they cancel,
downgrade to basic or upgrade to an annual pro plan at any point during
the trial.

When customers cancel their Foodie-Fi service - they will have a churn
plan record with a null price but their plan will continue until the end
of the billing period.

<div class="knitsql-table">

| plan\_id | plan\_name    | price |
|:---------|:--------------|------:|
| 0        | trial         |   0.0 |
| 1        | basic monthly |   9.9 |
| 2        | pro monthly   |  19.9 |
| 3        | pro annual    | 199.0 |
| 4        | churn         |    NA |

5 records

</div>

#### Table 2: subscriptions

Customer subscriptions show the exact date where their specific plan\_id
starts.

If customers downgrade from a pro plan or cancel their subscription -
the higher plan will remain in place until the period is over - the
start\_date in the subscriptions table will reflect the date that the
actual plan changes.

When customers upgrade their account from a basic plan to a pro or
annual pro plan - the higher plan will take effect straightaway.

When customers churn - they will keep their access until the end of
their current billing period but the start\_date will be technically the
day they decided to cancel their service.

<div class="knitsql-table">

| customer\_id | plan\_name    | price | start\_date |
|-------------:|:--------------|------:|:------------|
|            1 | trial         |   0.0 | 2020-08-01  |
|            1 | basic monthly |   9.9 | 2020-08-08  |
|            2 | trial         |   0.0 | 2020-09-20  |
|            2 | pro annual    | 199.0 | 2020-09-27  |
|           11 | trial         |   0.0 | 2020-11-19  |
|           11 | churn         |    NA | 2020-11-26  |
|           13 | trial         |   0.0 | 2020-12-15  |
|           13 | basic monthly |   9.9 | 2020-12-22  |
|           13 | pro monthly   |  19.9 | 2021-03-29  |
|           15 | trial         |   0.0 | 2020-03-17  |

Displaying records 1 - 10

</div>

### Case Study Questions

This case study is split into an initial data understanding question
before diving straight into data analysis questions before finishing
with 1 single extension challenge.

#### A. Customer Journey

Based off the 8 sample customers provided in the sample from the
subscriptions table, write a brief description about each customer’s
onboarding journey.

Try to keep it as short as possible - you may also want to run some sort
of join to make your explanations a bit easier!

<div class="knitsql-table">

| customer\_id | plan\_name    | price | start\_date |
|-------------:|:--------------|------:|:------------|
|            1 | trial         |   0.0 | 2020-08-01  |
|            1 | basic monthly |   9.9 | 2020-08-08  |

2 records

</div>

**Customer id 1** started trial on 1st of August 2020 and afterwards paid
for a basic monthly subscription on August the 8th 2020.

------------------------------------------------------------------------

<div class="knitsql-table">

| customer\_id | plan\_name | price | start\_date |
|-------------:|:-----------|------:|:------------|
|           11 | trial      |     0 | 2020-11-19  |
|           11 | churn      |    NA | 2020-11-26  |

2 records

</div>

Customer id 11 started trial on 19th of november 2020 and let it run out
with no renewal.

------------------------------------------------------------------------

<div class="knitsql-table">

| customer\_id | plan\_name  | price | start\_date |
|-------------:|:------------|------:|:------------|
|           15 | trial       |   0.0 | 2020-03-17  |
|           15 | pro monthly |  19.9 | 2020-03-24  |
|           15 | churn       |    NA | 2020-04-29  |

3 records

</div>

Customer id 15 started trial on 17 of March 2020, upgraded to a pro
monthly subscription right after which has added benefits, then canceled
his subscription on April the 29th, having access to his account until
24th of May.

#### B. Data Analysis Questions

**1. How many customers has Foodie-Fi ever had?**

``` sql
SELECT
    COUNT(DISTINCT customer_id)
FROM
    subscriptions
```

<div class="knitsql-table">

|      |
|-----:|
| 1000 |

1 records

</div>

------------------------------------------------------------------------

**2. What is the monthly distribution of trial plan start\_date values
for our dataset - use the start of the month as the group by value**

``` sql
SELECT
    MONTH(start_date) AS month_of_year,
    COUNT(plan_id) AS count
FROM 
    subscriptions
WHERE plan_id = 0
GROUP BY MONTH(start_date) 
ORDER BY MONTH(start_date)
```

<div class="knitsql-table">

| month\_of\_year | count |
|:----------------|------:|
| 1               |    88 |
| 2               |    68 |
| 3               |    94 |
| 4               |    81 |
| 5               |    88 |
| 6               |    79 |
| 7               |    89 |
| 8               |    88 |
| 9               |    87 |
| 10              |    79 |
| 11              |    75 |
| 12              |    84 |

Displaying records 1 - 12

</div>

------------------------------------------------------------------------

**3. What plan start\_date values occur after the year 2020 for our
dataset? Show the breakdown by count of events for each plan\_name**

``` sql
SELECT 
    plan_name,
    COUNT(plan_name) AS count_2021
FROM 
    subscriptions s
    RIGHT JOIN
    plans p
    ON
    s.plan_id = p.plan_id
WHERE start_date >= '2021-01-01'
GROUP BY plan_name
```

<div class="knitsql-table">

| plan\_name    | count\_2021 |
|:--------------|------------:|
| basic monthly |           8 |
| churn         |          71 |
| pro annual    |          63 |
| pro monthly   |          60 |

4 records

</div>

Trial have 0 occurences and does not show in the table.

------------------------------------------------------------------------

**4. What is the customer count and percentage of customers who have
churned rounded to 1 decimal place?**

``` sql
SELECT 
    COUNT(customer_id) AS count,
    ROUND(CAST(100 * COUNT(customer_id) AS FLOAT) / (
        SELECT 
            count(DISTINCT customer_id)
        FROM
            subscriptions),1) AS pct
FROM
    subscriptions
WHERE plan_id = 4
```

<div class="knitsql-table">

| count |  pct |
|------:|-----:|
|   307 | 30.7 |

1 records

</div>

------------------------------------------------------------------------

**5. How many customers have churned straight after their initial free
trial - what percentage is this rounded to the nearest whole number?**

``` sql
WITH cte_seq AS (
    SELECT 
        plan_id,
        lead(plan_id) OVER (order by customer_id) AS next_plan
    FROM 
        subscriptions
)

SELECT
    COUNT(*) AS count,
    ROUND(CAST(100*COUNT(*) AS FLOAT) / (
        SELECT
            COUNT(DISTINCT customer_id)
        FROM 
            subscriptions),1) AS pct
FROM
    cte_seq
WHERE plan_id = 0
AND next_plan = 4
```

<div class="knitsql-table">

| count | pct |
|------:|----:|
|    92 | 9.2 |

1 records

</div>

------------------------------------------------------------------------

**6. What is the number and percentage of customer plans after their
initial free trial?**

``` sql
WITH cte_seq AS (
    SELECT 
        plan_id,
        lead(plan_id) OVER (order by customer_id) AS next_plan
    FROM 
        subscriptions
)

SELECT
    next_plan AS new_plan,
    COUNT(*) AS count,
    ROUND(CAST(100*COUNT(*) AS FLOAT) / (
        SELECT
            COUNT(DISTINCT customer_id)
        FROM 
            subscriptions),1) AS pct
FROM
    cte_seq
WHERE plan_id = 0
GROUP BY next_plan;
```

<div class="knitsql-table">

| new\_plan | count |  pct |
|:----------|------:|-----:|
| 1         |   546 | 54.6 |
| 2         |   325 | 32.5 |
| 3         |    37 |  3.7 |
| 4         |    92 |  9.2 |

4 records

</div>

------------------------------------------------------------------------

**7. What is the customer count and percentage breakdown of all 5
plan\_name values at 2020-12-31?**

``` sql
WITH cte_seq AS (
    SELECT 
        customer_id,
        plan_id,
        start_date,
        lead(start_date) OVER(PARTITION BY customer_id ORDER BY start_date) AS next_date
    FROM 
        subscriptions
    WHERE start_date <= '2020-12-31' -- To cut-off before 2021.
) 

SELECT
    plan_id,
    COUNT(DISTINCT customer_id) AS count,
    ROUND(CAST(100* COUNT(DISTINCT customer_id) AS FLOAT) /
        (SELECT count(DISTINCT customer_id) 
         FROM subscriptions),1) AS pct
FROM
    cte_seq
WHERE next_date IS NULL -- To get the final subscription plan for each distinct customer.
GROUP BY plan_id;
```

<div class="knitsql-table">

| plan\_id | count |  pct |
|:---------|------:|-----:|
| 0        |    19 |  1.9 |
| 1        |   224 | 22.4 |
| 2        |   326 | 32.6 |
| 3        |   195 | 19.5 |
| 4        |   236 | 23.6 |

5 records

</div>

------------------------------------------------------------------------

**8. How many customers have upgraded to an annual plan in 2020?**

``` sql
SELECT
    COUNT(DISTINCT customer_id) AS count
FROM subscriptions
WHERE start_date <= '2020-12-31'
AND plan_id = 3
```

<div class="knitsql-table">

| count |
|------:|
|   195 |

1 records

</div>

------------------------------------------------------------------------

**9. How many days on average does it take for a customer to an annual
plan from the day they join Foodie-Fi?**

``` sql
WITH cte_join_day AS(
    SELECT 
        DISTINCT customer_id,
        start_date AS join_date
    FROM
        subscriptions
    WHERE plan_id=0
),
cte_annual_day AS(
    SELECT
        DISTINCT customer_id,
        start_date AS annual_date
    FROM
        subscriptions
    WHERE plan_id=3
)

SELECT
    AVG(DATEDIFF(DAY, join_date, annual_date)) AS avg_days_to_upgrade
FROM cte_join_day t
JOIN cte_annual_day a
  ON t.customer_id = a.customer_id;
```

<div class="knitsql-table">

| avg\_days\_to\_upgrade |
|-----------------------:|
|                    104 |

1 records

</div>

------------------------------------------------------------------------

**10. Can you further breakdown this average value into 30 day periods
(i.e. 0-30 days, 31-60 days etc)**

``` sql
WITH cte_join_day AS(
    SELECT 
        DISTINCT customer_id,
        start_date AS join_date
    FROM
        subscriptions
    WHERE plan_id=0
),
cte_annual_day AS(
    SELECT
        DISTINCT customer_id,
        start_date AS annual_date
    FROM
        subscriptions
    WHERE plan_id=3
),

cte_count_days AS(
    SELECT
        DATEDIFF(DAY, join_date, annual_date) AS days_to_upgrade
    FROM cte_join_day t
    JOIN cte_annual_day a
        ON t.customer_id = a.customer_id
)

SELECT
    COUNT(CASE WHEN days_to_upgrade <31 THEN 1 END) AS '0-30',
    COUNT(CASE WHEN days_to_upgrade > 30 AND days_to_upgrade < 61 THEN 1 END) AS '31-60',
    COUNT(CASE WHEN days_to_upgrade > 60 AND days_to_upgrade < 91 THEN 1 END) AS '61-90',
    COUNT(CASE WHEN days_to_upgrade > 90 AND days_to_upgrade < 121 THEN 1 END) AS '91-120',
    COUNT(CASE WHEN days_to_upgrade > 120 AND days_to_upgrade < 151 THEN 1 END) AS '121-150',
    COUNT(CASE WHEN days_to_upgrade > 150 AND days_to_upgrade < 181 THEN 1 END) AS '151-180',
    COUNT(CASE WHEN days_to_upgrade > 180 AND days_to_upgrade < 211 THEN 1 END) AS '181-210',
    COUNT(CASE WHEN days_to_upgrade > 210 AND days_to_upgrade < 241 THEN 1 END) AS '211-240',
    COUNT(CASE WHEN days_to_upgrade > 240 AND days_to_upgrade < 271 THEN 1 END) AS '241-270',
    COUNT(CASE WHEN days_to_upgrade > 270 AND days_to_upgrade < 301 THEN 1 END) AS '271-300',
    COUNT(CASE WHEN days_to_upgrade > 300 AND days_to_upgrade < 331 THEN 1 END) AS '301-330',
    COUNT(CASE WHEN days_to_upgrade > 330 THEN 1 END) AS '331-360'
FROM
    cte_count_days;
```

<div class="knitsql-table">

| 0-30 | 31-60 | 61-90 | 91-120 | 121-150 | 151-180 | 181-210 | 211-240 | 241-270 | 271-300 | 301-330 | 331-360 |
|-----:|------:|------:|-------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|--------:|
|   49 |    24 |    34 |     35 |      42 |      36 |      26 |       4 |       5 |       1 |       1 |       1 |

1 records

</div>

A simple but tedious solution to hardcode each bin. Could also do it in
a long format with 3 columns but it requires an additional CTE:

``` sql
WITH cte_join_day AS(
    SELECT 
        DISTINCT customer_id,
        start_date AS join_date
    FROM
        subscriptions
    WHERE plan_id=0
),
cte_annual_day AS(
    SELECT
        DISTINCT customer_id,
        start_date AS annual_date
    FROM
        subscriptions
    WHERE plan_id=3
),

cte_count_days AS(
    SELECT
        DATEDIFF(DAY, join_date, annual_date) AS days_to_upgrade
    FROM cte_join_day t
    JOIN cte_annual_day a
        ON t.customer_id = a.customer_id
),

cte_day_bracket AS(
    SELECT 
        CASE 
            WHEN days_to_upgrade <31 THEN '0-30'
            WHEN days_to_upgrade > 30 AND days_to_upgrade < 61 THEN  '31-60'
            WHEN days_to_upgrade > 60 AND days_to_upgrade < 91 THEN  '61-90'
            WHEN days_to_upgrade > 90 AND days_to_upgrade < 121 THEN  '91-120'
            WHEN days_to_upgrade > 120 AND days_to_upgrade < 151 THEN  '121-150'
            WHEN days_to_upgrade > 150 AND days_to_upgrade < 181 THEN  '151-180'
            WHEN days_to_upgrade > 180 AND days_to_upgrade < 211 THEN  '181-210'
            WHEN days_to_upgrade > 210 AND days_to_upgrade < 241 THEN  '211-240'
            WHEN days_to_upgrade > 240 AND days_to_upgrade < 271 THEN  '241-270'
            WHEN days_to_upgrade > 270 AND days_to_upgrade < 301 THEN  '271-300'
            WHEN days_to_upgrade > 300 AND days_to_upgrade < 331 THEN  '301-330'
            WHEN days_to_upgrade > 330 THEN '331-360'
            ELSE 'NA'
        END AS day_bracket,
        days_to_upgrade
    FROM
        cte_count_days
)

SELECT
    day_bracket,
    COUNT(days_to_upgrade) AS count
FROM
    cte_day_bracket
GROUP BY
    day_bracket
ORDER BY day_bracket;
```

<div class="knitsql-table">

| day\_bracket | count |
|:-------------|------:|
| 0-30         |    49 |
| 121-150      |    42 |
| 151-180      |    36 |
| 181-210      |    26 |
| 211-240      |     4 |
| 241-270      |     5 |
| 271-300      |     1 |
| 301-330      |     1 |
| 31-60        |    24 |
| 331-360      |     1 |

Displaying records 1 - 10

</div>

**Reminder** I need to order it

------------------------------------------------------------------------

**11. How many customers downgraded from a pro monthly to a basic
monthly plan in 2020?**

``` sql
WITH cte_seq AS (
    SELECT 
        plan_id,
        lead(plan_id) OVER (PARTITION BY customer_id ORDER BY customer_id) AS next_plan
    FROM 
        subscriptions
)

SELECT
    COUNT(*) AS count
FROM
    cte_seq
WHERE plan_id = 2
AND next_plan = 1
-- 0.
```

<div class="knitsql-table">

| count |
|------:|
|     0 |

1 records

</div>

------------------------------------------------------------------------
