Data With Danny: Pizza Runner
================
Benjamin Sivac
2022-04-26

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/PizzaRunner/figure-gfm/dwd2.png"
       height="850px" width="850px"/>
</p>

### Introduction

Did you know that over 115 million kilograms of pizza is consumed daily
worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really
caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going
to help him get seed funding to expand his new Pizza Empire - so he had
one more genius idea to combine with it - he was going to Uberize it -
and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza
Runner Headquarters (otherwise known as Danny’s house) and also maxed
out his credit card to pay freelance developers to build a mobile app to
accept orders from customers.

### Available Data

Because Danny had a few years of experience as a data scientist - he was
very aware that data collection was going to be critical for his
business’ growth.

He has prepared for us an entity relationship diagram of his database
design but requires further assistance to clean his data and apply some
basic calculations so he can better direct his runners and optimise
Pizza Runner’s operations.

All datasets exist within the pizza\_runner database schema - be sure to
include this reference within your SQL scripts as you start exploring
the data and answering the case study questions.

#### Entity Relationship Diagram

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/PizzaRunner/figure-gfm/erd.PNG"/>
</p>

#### Table 1: runners

The runners table shows the registration\_date for each new runner

<div class="knitsql-table">

| runner\_id | registration\_date |
|:-----------|:-------------------|
| 1          | 2021-01-01         |
| 2          | 2021-01-03         |
| 3          | 2021-01-08         |
| 4          | 2021-01-15         |

4 records

</div>

#### Table 2: customer\_orders

Customer pizza orders are captured in the customer\_orders table with 1
row for each individual pizza that is part of the order.

<div class="knitsql-table">

| order\_id | customer\_id | pizza\_id | exclusions | extras | order\_time         |
|----------:|-------------:|----------:|:-----------|:-------|:--------------------|
|         1 |          101 |         1 |            |        | 2020-01-01 18:05:02 |
|         2 |          101 |         1 |            |        | 2020-01-01 19:00:52 |
|         3 |          102 |         1 |            |        | 2020-01-02 23:51:23 |
|         3 |          102 |         2 |            | NA     | 2020-01-02 23:51:23 |
|         4 |          103 |         1 | 4          |        | 2020-01-04 13:23:46 |
|         4 |          103 |         1 | 4          |        | 2020-01-04 13:23:46 |
|         4 |          103 |         2 | 4          |        | 2020-01-04 13:23:46 |
|         5 |          104 |         1 | null       | 1      | 2020-01-08 21:00:29 |
|         6 |          101 |         2 | null       | null   | 2020-01-08 21:03:13 |
|         7 |          105 |         2 | null       | 1      | 2020-01-08 21:20:29 |

Displaying records 1 - 10

</div>

The pizza\_id relates to the type of pizza which was ordered whilst the
exclusions are the ingredient\_id values which should be removed from
the pizza and the extras are the ingredient\_id values which need to be
added to the pizza.

Note that customers can order multiple pizzas in a single order with
varying exclusions and extras values even if the pizza is the same type!

The exclusions and extras columns will need to be cleaned up before
using them in your queries.

#### Table 3: runner\_orders

After each orders are received through the system - they are assigned to
a runner - however not all orders are fully completed and can be
cancelled by the restaurant or the customer.

<div class="knitsql-table">

| order\_id | runner\_id | pickup\_time        | distance | duration   | cancellation            |
|:----------|-----------:|:--------------------|:---------|:-----------|:------------------------|
| 1         |          1 | 2020-01-01 18:15:34 | 20km     | 32 minutes |                         |
| 2         |          1 | 2020-01-01 19:10:54 | 20km     | 27 minutes |                         |
| 3         |          1 | 2020-01-03 00:12:37 | 13.4km   | 20 mins    | NA                      |
| 4         |          2 | 2020-01-04 13:53:03 | 23.4     | 40         | NA                      |
| 5         |          3 | 2020-01-08 21:10:57 | 10       | 15         | NA                      |
| 6         |          3 | null                | null     | null       | Restaurant Cancellation |
| 7         |          2 | 2020-01-08 21:30:45 | 25km     | 25mins     | null                    |
| 8         |          2 | 2020-01-10 00:15:02 | 23.4 km  | 15 minute  | null                    |
| 9         |          2 | null                | null     | null       | Customer Cancellation   |
| 10        |          1 | 2020-01-11 18:50:20 | 10km     | 10minutes  | null                    |

Displaying records 1 - 10

</div>

The pickup\_time is the timestamp at which the runner arrives at the
Pizza Runner headquarters to pick up the freshly cooked pizzas. The
distance and duration fields are related to how far and long the runner
had to travel to deliver the order to the respective customer.

There are some known data issues with this table so be careful when
using this in your queries - make sure to check the data types for each
column in the schema SQL!

#### Table 4: pizza\_names

At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers
or Vegetarian!

<div class="knitsql-table">

| pizza\_id | pizza\_name |
|:----------|:------------|
| 1         | Meatlovers  |
| 2         | Vegetarian  |

2 records

</div>

#### Table 5: pizza\_recipes

Each pizza\_id has a standard set of toppings which are used as part of
the pizza recipe.

<div class="knitsql-table">

| pizza\_id | toppings                |
|:----------|:------------------------|
| 1         | 1, 2, 3, 4, 5, 6, 8, 10 |
| 2         | 4, 6, 7, 9, 11, 12      |

2 records

</div>

#### Table 6: pizza\_toppings

This table contains all of the topping\_name values with their
corresponding topping\_id value

<div class="knitsql-table">

| topping\_id | topping\_name |
|:------------|:--------------|
| 1           | Bacon         |
| 2           | BBQ Sauce     |
| 3           | Beef          |
| 4           | Cheese        |
| 5           | Chicken       |
| 6           | Mushrooms     |
| 7           | Onions        |
| 8           | Pepperoni     |
| 9           | Peppers       |
| 10          | Salami        |

Displaying records 1 - 10

</div>

### Case Study Questions

This case study has LOTS of questions - they are broken up by area of
focus including:

-   Pizza Metrics
-   Runner and Customer Experience
-   Ingredient Optimisation
-   Pricing and Ratings

Each of the following case study questions can be answered using a
single SQL statement.

Again, there are many questions in this case study - please feel free to
pick and choose which ones you’d like to try!

#### Clean tables

Before you start writing your SQL queries however - you might want to
investigate the data, you may want to do something with some of those
null values and data types in the customer\_orders and runner\_orders
tables!

**Clean customer\_orders table:**

``` sql
UPDATE dbo.customer_orders 
SET exclusions = NULLIF(exclusions, 'null'),
    extras = NULLIF(extras, 'null');

UPDATE dbo.customer_orders 
SET 
    exclusions = NULLIF(exclusions, ''),
    extras = NULLIF(extras, '');

-- See end result
SELECT
  *
FROM
  customer_orders
```

<div class="knitsql-table">

| order\_id | customer\_id | pizza\_id | exclusions | extras | order\_time                 |
|----------:|-------------:|----------:|:-----------|:-------|:----------------------------|
|         1 |          101 |         1 | NA         | NA     | 2020-01-01 18:05:02.0000000 |
|         2 |          101 |         1 | NA         | NA     | 2020-01-01 19:00:52.0000000 |
|         3 |          102 |         1 | NA         | NA     | 2020-01-02 23:51:23.0000000 |
|         3 |          102 |         2 | NA         | NA     | 2020-01-02 23:51:23.0000000 |
|         4 |          103 |         1 | 4          | NA     | 2020-01-04 13:23:46.0000000 |
|         4 |          103 |         1 | 4          | NA     | 2020-01-04 13:23:46.0000000 |
|         4 |          103 |         2 | 4          | NA     | 2020-01-04 13:23:46.0000000 |
|         5 |          104 |         1 | NA         | 1      | 2020-01-08 21:00:29.0000000 |
|         6 |          101 |         2 | NA         | NA     | 2020-01-08 21:03:13.0000000 |
|         7 |          105 |         2 | NA         | 1      | 2020-01-08 21:20:29.0000000 |

Displaying records 1 - 10

</div>

**Clean runner\_orders table:**

``` sql
-- Fix duration column.
UPDATE dbo.runner_orders 
SET 
    duration = TRIM(REPLACE(duration, 'minutes', ''))
UPDATE dbo.runner_orders 
SET 
    duration = TRIM(REPLACE(duration, 'mins', ''));
UPDATE dbo.runner_orders 
SET 
    duration = TRIM(REPLACE(duration, 'null', ''));
UPDATE dbo.runner_orders 
SET 
    duration = TRIM(REPLACE(duration, 'minute', ''));

ALTER TABLE dbo.runner_orders 
ALTER COLUMN duration FLOAT;

-- Fix distance column
UPDATE dbo.runner_orders 
SET 
    distance = TRIM(REPLACE(distance, 'km', ''))
UPDATE dbo.runner_orders 
SET 
    distance = TRIM(REPLACE(distance, 'null', ''));
ALTER TABLE dbo.runner_orders 
ALTER COLUMN distance FLOAT;

-- Fix cancellation column
UPDATE dbo.runner_orders 
SET 
    cancellation = ISNULL(cancellation, '');
UPDATE dbo.runner_orders 
SET 
    cancellation = TRIM(REPLACE(cancellation, 'null', ''));

-- Fix pickup_time column
UPDATE dbo.runner_orders 
SET 
    pickup_time = NULLIF(pickup_time, 'null');
ALTER TABLE dbo.runner_orders 
ALTER COLUMN pickup_time DATETIME2;

ALTER TABLE dbo.pizza_names
ALTER COLUMN pizza_name NVARCHAR(100);

-- See end result:
SELECT
  *
FROM
  runner_orders
```

<div class="knitsql-table">

| order\_id | runner\_id | pickup\_time                | distance | duration | cancellation            |
|:----------|-----------:|:----------------------------|---------:|---------:|:------------------------|
| 1         |          1 | 2020-01-01 18:15:34.0000000 |     20.0 |       32 |                         |
| 2         |          1 | 2020-01-01 19:10:54.0000000 |     20.0 |       27 |                         |
| 3         |          1 | 2020-01-03 00:12:37.0000000 |     13.4 |       20 |                         |
| 4         |          2 | 2020-01-04 13:53:03.0000000 |     23.4 |       40 |                         |
| 5         |          3 | 2020-01-08 21:10:57.0000000 |     10.0 |       15 |                         |
| 6         |          3 | NA                          |      0.0 |        0 | Restaurant Cancellation |
| 7         |          2 | 2020-01-08 21:30:45.0000000 |     25.0 |       25 |                         |
| 8         |          2 | 2020-01-10 00:15:02.0000000 |     23.4 |       15 |                         |
| 9         |          2 | NA                          |      0.0 |        0 | Customer Cancellation   |
| 10        |          1 | 2020-01-11 18:50:20.0000000 |     10.0 |       10 |                         |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

#### A. Pizza Metrics

**A.1 How many pizzas were ordered?**

``` sql
SELECT
    COUNT(*) AS ordered_pizzas
FROM
    customer_orders;
```

<div class="knitsql-table">

| ordered\_pizzas |
|----------------:|
|              14 |

1 records

</div>

------------------------------------------------------------------------

**A.2 How many unique customer orders were made?**

``` sql
SELECT
    customer_id,
    COUNT(customer_id) AS nbr_of_orders
FROM
    customer_orders
GROUP BY customer_id;
```

<div class="knitsql-table">

| customer\_id | nbr\_of\_orders |
|:-------------|----------------:|
| 101          |               3 |
| 102          |               3 |
| 103          |               4 |
| 104          |               3 |
| 105          |               1 |

5 records

</div>

------------------------------------------------------------------------

**A.3 How many successful orders were delivered by each runner?**

``` sql
SELECT
    runner_id,
    COUNT(order_id) AS succesful_orders
FROM
    runner_orders
WHERE pickup_time IS NOT NULL
GROUP BY runner_id;
```

<div class="knitsql-table">

| runner\_id | succesful\_orders |
|:-----------|------------------:|
| 1          |                 4 |
| 2          |                 3 |
| 3          |                 1 |

3 records

</div>

------------------------------------------------------------------------

**A.4 How many of each type of pizza was delivered?**

``` sql
SELECT
    pizza_id,
    COUNT(pizza_id) AS delievered
FROM
    runner_orders ro
JOIN
    customer_orders co
    ON ro.order_id = co.order_id
WHERE pickup_time IS NOT NULL
GROUP BY pizza_id;
```

<div class="knitsql-table">

| pizza\_id | delievered |
|:----------|-----------:|
| 1         |          9 |
| 2         |          3 |

2 records

</div>

------------------------------------------------------------------------

**A.5 How many Vegetarian and Meatlovers were ordered by each customer?**

``` sql
SELECT
    customer_id,
    pizza_name,
    COUNT(order_id) AS orders
FROM
    customer_orders co
JOIN
    pizza_names pn
    ON co.pizza_id=pn.pizza_id
GROUP BY co.customer_id, pizza_name
ORDER BY customer_id
```

<div class="knitsql-table">

| customer\_id | pizza\_name | orders |
|-------------:|:------------|-------:|
|          101 | Meatlovers  |      2 |
|          101 | Vegetarian  |      1 |
|          102 | Meatlovers  |      2 |
|          102 | Vegetarian  |      1 |
|          103 | Meatlovers  |      3 |
|          103 | Vegetarian  |      1 |
|          104 | Meatlovers  |      3 |
|          105 | Vegetarian  |      1 |

8 records

</div>

------------------------------------------------------------------------

**A.6 What was the maximum number of pizzas delivered in a single
order?**

``` sql
WITH cte_pizza_count AS (
    SELECT 
            COUNT(co.order_id) as orders 
        FROM customer_orders co 
        JOIN runner_orders ro 
            ON co.order_id=ro.order_id 
        WHERE pickup_time IS NOT NULL 
        GROUP BY co.order_id
)

SELECT
    MAX(orders) AS most_pizzas_ordered
FROM
    cte_pizza_count;
```

<div class="knitsql-table">

| most\_pizzas\_ordered |
|----------------------:|
|                     3 |

1 records

</div>

------------------------------------------------------------------------

**A.7 For each customer, how many delivered pizzas had at least 1 change
and how many had no changes?**

``` sql
SELECT
    customer_id,
    SUM(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1 ELSE 0 END) AS orders_with_changes,
    SUM(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 ELSE 0 END) AS orders_without_changes
FROM 
    customer_orders co 
JOIN 
    runner_orders ro 
    ON co.order_id=ro.order_id 
WHERE pickup_time IS NOT NULL 
GROUP BY customer_id;
```

<div class="knitsql-table">

| customer\_id | orders\_with\_changes | orders\_without\_changes |
|:-------------|----------------------:|-------------------------:|
| 101          |                     0 |                        2 |
| 102          |                     0 |                        3 |
| 103          |                     3 |                        0 |
| 104          |                     2 |                        1 |
| 105          |                     1 |                        0 |

5 records

</div>

------------------------------------------------------------------------

**A.8 How many pizzas were delivered that had both exclusions and
extras?**

``` sql
SELECT
    SUM(CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1 ELSE 0 END) AS excluded_and_added
FROM 
    customer_orders co 
JOIN 
    runner_orders ro 
    ON co.order_id=ro.order_id 
WHERE pickup_time IS NOT NULL;
```

<div class="knitsql-table">

| excluded\_and\_added |
|---------------------:|
|                    1 |

1 records

</div>

------------------------------------------------------------------------

**A.9 What was the total volume of pizzas ordered for each hour of the
day?**

``` sql
SELECT
    DATEPART(HOUR,order_time) AS hour_of_day,
    COUNT(order_id) AS nbr_pizza_ordered
FROM
    customer_orders
GROUP BY DATEPART(HOUR,order_time);
```

<div class="knitsql-table">

| hour\_of\_day | nbr\_pizza\_ordered |
|--------------:|--------------------:|
|            11 |                   1 |
|            13 |                   3 |
|            18 |                   3 |
|            19 |                   1 |
|            21 |                   3 |
|            23 |                   3 |

6 records

</div>

------------------------------------------------------------------------

**A.10 What was the volume of orders for each day of the week?**

``` sql
SELECT
    DATENAME(WEEKDAY,order_time) AS day_of_week,
    COUNT(order_id) AS nbr_pizza_ordered
FROM
    customer_orders
GROUP BY DATENAME(WEEKDAY,order_time);
```

<div class="knitsql-table">

| day\_of\_week | nbr\_pizza\_ordered |
|:--------------|--------------------:|
| Friday        |                   1 |
| Saturday      |                   5 |
| Thursday      |                   3 |
| Wednesday     |                   5 |

4 records

</div>

------------------------------------------------------------------------

#### B. Runner and Customer Experience

**B.1 How many runners signed up for each 1 week period? (i.e. week
starts 2021-01-01)**

``` sql
SELECT
    DATEPART(WEEK,registration_date) AS week,
    COUNT(runner_id) AS nbr_runners
FROM
    runners
GROUP BY DATEPART(WEEK,registration_date);
```

<div class="knitsql-table">

| week | nbr\_runners |
|:-----|-------------:|
| 1    |            1 |
| 2    |            2 |
| 3    |            1 |

3 records

</div>

------------------------------------------------------------------------

**B.2 What was the average time in minutes it took for each runner to
arrive at the Pizza Runner HQ to pickup the order?**

``` sql
SELECT
    AVG(duration) AS avg_pickup_time_mins
FROM
    runner_orders;
```

<div class="knitsql-table">

| avg\_pickup\_time\_mins |
|------------------------:|
|                    18.4 |

1 records

</div>

------------------------------------------------------------------------

**B.3 Is there any relationship between the number of pizzas and how long
the order takes to prepare?**

``` sql
WITH cte_prep_time AS(
    SELECT
        COUNT(co.order_id) AS number_of_pizzas,
        AVG(DATEDIFF(MINUTE, order_time, pickup_time)) AS prep_time
    FROM
        runner_orders ro
    JOIN
        customer_orders co
        ON  ro.order_id = co.order_id
    WHERE pickup_time IS NOT NULL
    GROUP BY co.order_id
)
SELECT
    number_of_pizzas,
    AVG(prep_time)
FROM
    cte_prep_time
GROUP BY number_of_pizzas;
```

<div class="knitsql-table">

| number\_of\_pizzas |     |
|:-------------------|----:|
| 1                  |  12 |
| 2                  |  18 |
| 3                  |  30 |

3 records

</div>

------------------------------------------------------------------------

**B.4 What was the average distance travelled for each customer?**

``` sql
SELECT
    customer_id,
    ROUND(AVG(distance),2) AS avg_distance
FROM
    customer_orders co
JOIN
    runner_orders ro
    ON  co.order_id=ro.order_id
WHERE pickup_time IS NOT NULL
GROUP BY customer_id;
```

<div class="knitsql-table">

| customer\_id | avg\_distance |
|:-------------|--------------:|
| 101          |         20.00 |
| 102          |         16.73 |
| 103          |         23.40 |
| 104          |         10.00 |
| 105          |         25.00 |

5 records

</div>

------------------------------------------------------------------------

**B.5 What was the difference between the longest and shortest delivery
times for all orders?**

``` sql
SELECT
    MAX(DATEDIFF(MINUTE, order_time, pickup_time)) AS max_delivery_difference
FROM
    runner_orders ro
JOIN
    customer_orders co
    ON  ro.order_id = co.order_id
WHERE pickup_time IS NOT NULL;
```

<div class="knitsql-table">

| max\_delivery\_difference |
|--------------------------:|
|                        30 |

1 records

</div>

------------------------------------------------------------------------

**B.6 What was the average speed for each runner for each delivery and do
you notice any trend for these values?**

``` sql
SELECT
    runner_id,
    co.order_id,
    COUNT(co.order_id) AS nbr_pizzas,
    distance,
    duration,
    ROUND(AVG(distance/duration*60),2) AS km_h
FROM
    runner_orders ro
JOIN
    customer_orders co
    ON  ro.order_id = co.order_id
WHERE duration != 0
GROUP BY runner_id, co.order_id, distance, duration
ORDER BY runner_id, co.order_id;
```

<div class="knitsql-table">

| runner\_id | order\_id | nbr\_pizzas | distance | duration | km\_h |
|-----------:|----------:|------------:|---------:|---------:|------:|
|          1 |         1 |           1 |     20.0 |       32 | 37.50 |
|          1 |         2 |           1 |     20.0 |       27 | 44.44 |
|          1 |         3 |           2 |     13.4 |       20 | 40.20 |
|          1 |        10 |           2 |     10.0 |       10 | 60.00 |
|          2 |         4 |           3 |     23.4 |       40 | 35.10 |
|          2 |         7 |           1 |     25.0 |       25 | 60.00 |
|          2 |         8 |           1 |     23.4 |       15 | 93.60 |
|          3 |         5 |           1 |     10.0 |       15 | 40.00 |

8 records

</div>

------------------------------------------------------------------------

**B.7 What is the successful delivery percentage for each runner?**

``` sql
SELECT
    runner_id,
    FORMAT(CAST(SUM(CASE WHEN pickup_time IS NOT NULL THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*), 'p') AS delivery_pct
FROM
    runner_orders
GROUP BY runner_id;
```

<div class="knitsql-table">

| runner\_id | delivery\_pct |
|:-----------|:--------------|
| 1          | 100.00%       |
| 2          | 75.00%        |
| 3          | 50.00%        |

3 records

</div>

------------------------------------------------------------------------

#### C. Ingredient Optimisation

**C.1 What are the standard ingredients for each pizza?**

``` sql
WITH cte_split AS (
    SELECT
        *
    FROM
        pizza_recipes CROSS APPLY STRING_SPLIT(toppings,',')
)

SELECT
    pn.pizza_name,
    STRING_AGG(CAST(topping_name AS VARCHAR), ', ') AS ingredients
FROM
    cte_split t
JOIN
    dbo.pizza_toppings pt
    ON  t.value = pt.topping_id
JOIN
    pizza_names pn
    ON  t.pizza_id = pn.pizza_id
GROUP BY pn.pizza_name;
```

<div class="knitsql-table">

| pizza\_name | ingredients                                                           |
|:------------|:----------------------------------------------------------------------|
| Meatlovers  | Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami |
| Vegetarian  | Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce            |

2 records

</div>

------------------------------------------------------------------------

**C.2 What was the most commonly added extra?**

``` sql
WITH cte_split AS(
    SELECT
        value AS topping,
        COUNT(*) AS count
    FROM
        customer_orders co CROSS APPLY STRING_SPLIT(extras,',')
    GROUP BY value
)
SELECT TOP 1
    topping_name AS most_common_extra,
    count
FROM
    cte_split t
JOIN
    pizza_toppings pt
    ON  t.topping = pt.topping_id
ORDER BY count DESC;
```
<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/PizzaRunner/figure-gfm/c.2.PNG"/>
</p>

This and the following code ran properly on SQL server but I kept
getting “Invalid Descriptor Index” trying to run it in rmarkdown… I’ll
just add pictures of the result from SQL server.

------------------------------------------------------------------------

**C.3 What was the most common exclusion?**

``` sql
WITH cte_split AS(
    SELECT
        value AS topping,
        COUNT(*) AS count
    FROM
        customer_orders co CROSS APPLY STRING_SPLIT(exclusions,',')
    GROUP BY value
)
SELECT TOP 1
    topping_name AS most_excluded_topping,
    count
FROM
    cte_split t
JOIN
    pizza_toppings pt
    ON  t.topping = pt.topping_id
ORDER BY COUNT DESC;
```
<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/PizzaRunner/figure-gfm/c.3.PNG"/>
</p>

------------------------------------------------------------------------

**C.4 Generate an order item for each record in the customers\_orders
table in the format of one of the following:**

-   **Meat Lovers**
-   **Meat Lovers - Exclude Beef**
-   **Meat Lovers - Extra Bacon**
-   **Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers**

``` sql
SELECT
    order_id,
    CASE
        WHEN CHARINDEX('1', extras) > 0 THEN 'Meat Lovers - Extra Bacon'
        WHEN CHARINDEX('3', exclusions) > 0 THEN 'Meat Lovers - Exclude Beef'
        WHEN CHARINDEX('4', exclusions) > 0 AND CHARINDEX('1', exclusions) > 0
            AND CHARINDEX('1', extras) > 0 AND CHARINDEX('6', extras) > 0 
            AND CHARINDEX('9', extras) > 0 THEN 'Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers'
        WHEN pizza_id=1 THEN 'Meat Lovers' 
        ELSE 'Vegetarian' END as ordered_item
FROM
    customer_orders
```

<div class="knitsql-table">

| order\_id | ordered\_item             |
|----------:|:--------------------------|
|         1 | Meat Lovers               |
|         2 | Meat Lovers               |
|         3 | Meat Lovers               |
|         3 | Vegetarian                |
|         4 | Meat Lovers               |
|         4 | Meat Lovers               |
|         4 | Vegetarian                |
|         5 | Meat Lovers - Extra Bacon |
|         6 | Vegetarian                |
|         7 | Meat Lovers - Extra Bacon |

Displaying records 1 - 10

</div>

Not a very dynamic or elegant solution, but the question had very
specific instructions. I did however add ‘Vegetarian’ as one label.

------------------------------------------------------------------------

#### D. Pricing and Ratings

**D.1 If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there
were no charges for changes - how much money has Pizza Runner made so
far if there are no delivery fees?**

``` sql
SELECT
    SUM(CASE WHEN pizza_id=1 THEN 12 ELSE 10 END) AS total_income
FROM
    customer_orders co
JOIN
    runner_orders ro
    ON  co.order_id=ro.order_id
WHERE pickup_time IS NOT NULL;
```

<div class="knitsql-table">

| total\_income |
|--------------:|
|           138 |

1 records

</div>

------------------------------------------------------------------------

**D.2 What if there was an additional $1 charge for any pizza extras?**

``` sql
SELECT
    SUM(CASE 
            WHEN pizza_id=1 AND extras IS NOT NULL THEN 13
            WHEN pizza_id=1 THEN 12
            WHEN pizza_id=2 AND extras IS NOT NULL THEN 11 ELSE 10 END) AS total_income
FROM
    customer_orders co
JOIN
    runner_orders ro
    ON  co.order_id=ro.order_id
WHERE pickup_time IS NOT NULL;
```

<div class="knitsql-table">

| total\_income |
|--------------:|
|           141 |

1 records

</div>

------------------------------------------------------------------------
