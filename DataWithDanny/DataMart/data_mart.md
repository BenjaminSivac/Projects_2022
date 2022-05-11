Data With Danny: Data Mart
================
Benjamin Sivac
2022-04-29

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/DataMart/figure-gfm/dwd5.png"
       height="850px" width="850px"/>
</p>

## Introduction

Data Mart is Danny’s latest venture and after running international
operations for his online supermarket that specialises in fresh produce
- Danny is asking for your support to analyse his sales performance.

In June 2020 - large scale supply changes were made at Data Mart. All
Data Mart products now use sustainable packaging methods in every single
step from the farm all the way to the customer.

Danny needs your help to quantify the impact of this change on the sales
performance for Data Mart and it’s separate business areas.

The key business question he wants you to help him answer are the
following:

-   What was the quantifiable impact of the changes introduced in June
    2020?
-   Which platform, region, segment and customer types were the most
    impacted by this change?
-   What can we do about future introduction of similar sustainability
    updates to the business to minimise impact on sales?

## Available Data

For this case study there is only a single table:
data\_mart.weekly\_sales

The Entity Relationship Diagram is shown below with the data types made
clear, please note that there is only this one table - hence why it
looks a little bit lonely!

### Column Dictionary

The columns are pretty self-explanatory based on the column names but
here are some further details about the dataset:

1.  Data Mart has international operations using a multi-region strategy
2.  Data Mart has both, a retail and online platform in the form of a
    Shopify store front to serve their customers
3.  Customer segment and customer\_type data relates to personal age and
    demographics information that is shared with Data Mart transactions
    is the count of unique purchases made through Data Mart and sales is
    the actual dollar amount of purchases
4.  Each record in the dataset is related to a specific aggregated slice
    of the underlying sales data rolled up into a week\_date value which
    represents the start of the sales week.

### Example Rows

10 random rows are shown in the table output below from
data\_mart.weekly\_sales:

<div class="knitsql-table">

| week\_date | region | platform | segment | customer\_type | transactions |    sales |
|:-----------|:-------|:---------|:--------|:---------------|-------------:|---------:|
| 31/8/20    | ASIA   | Retail   | C3      | New            |       120631 |  3656163 |
| 31/8/20    | ASIA   | Retail   | F1      | New            |        31574 |   996575 |
| 31/8/20    | USA    | Retail   | null    | Guest          |       529151 | 16509610 |
| 31/8/20    | EUROPE | Retail   | C1      | New            |         4517 |   141942 |
| 31/8/20    | AFRICA | Retail   | C2      | New            |        58046 |  1758388 |
| 31/8/20    | CANADA | Shopify  | F2      | Existing       |         1336 |   243878 |
| 31/8/20    | AFRICA | Shopify  | F3      | Existing       |         2514 |   519502 |
| 31/8/20    | ASIA   | Shopify  | F1      | Existing       |         2158 |   371417 |
| 31/8/20    | AFRICA | Shopify  | F2      | New            |          318 |    49557 |
| 31/8/20    | AFRICA | Retail   | C3      | New            |       111032 |  3888162 |

Displaying records 1 - 10

</div>

# Case Study Questions

The following case study questions require some data cleaning steps
before we start to unpack Danny’s key business questions in more depth.

## A. Data Cleansing Steps

In a single query, perform the following operations and generate a new
table in the data\_mart schema named clean\_weekly\_sales:

-   Convert the week\_date to a DATE format

-   Add a week\_number as the second column for each week\_date value,
    for example any value from the 1st of January to 7th of January will
    be 1, 8th to 14th will be 2 etc

-   Add a month\_number with the calendar month for each week\_date
    value as the 3rd column

-   Add a calendar\_year column as the 4th column containing either
    2018, 2019 or 2020 values

-   Add a new column called age\_band after the original segment column
    using the following mapping on the number inside the segment value

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/DataMart/figure-gfm/sg_ab.PNG"/>
</p>

-   Add a new demographic column using the following mapping for the
    first letter in the segment values: segment demographic

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/DataMart/figure-gfm/sg_dm.PNG"/>
</p>

-   Ensure all null string values with an “unknown” string value in the
    original segment column as well as the new age\_band and demographic
    columns

-   Generate a new avg\_transaction column as the sales value divided by
    transactions rounded to 2 decimal places for each record

``` sql
SELECT
    CONVERT(DATE, week_date, 3) AS week_date,
    DATEPART(WEEK, CONVERT(DATE, week_date, 3)) AS week_number,
    DATEPART(MONTH, CONVERT(DATE, week_date, 3)) AS month_number,
    DATEPART(YEAR, CONVERT(DATE, week_date, 3)) AS calender_year,
    region,
    platform,
    CASE 
        WHEN segment='null' THEN 'Unknown'
        ELSE segment END AS segment,
    CASE 
        WHEN CHARINDEX('1', segment, 2) > 0 THEN 'Young Adults'
        WHEN CHARINDEX('2', segment, 2) > 0 THEN 'Middle Aged'
        WHEN CHARINDEX('3', segment, 2) > 0 OR CHARINDEX('4', segment, 2) > 0 THEN 'Retirees' 
        ELSE 'Unknown' END as age_band,
    CASE 
        WHEN CHARINDEX('C', segment, 1) > 0 THEN 'Couples'
        WHEN CHARINDEX('F', segment, 1) > 0 THEN 'Families'
        ELSE 'Unknown' END as demographic,
        
    customer_type,
    transactions,
    ROUND((sales/CAST(transactions AS FLOAT)),2) AS avg_transaction,
    sales
INTO
    clean_weekly_sales
FROM
    data_mart.weekly_sales;
```

<div class="knitsql-table">

| week\_date | week\_number | month\_number | calender\_year | region | platform | segment | age\_band    | demographic | customer\_type | transactions | avg\_transaction |    sales |
|:-----------|-------------:|--------------:|---------------:|:-------|:---------|:--------|:-------------|:------------|:---------------|-------------:|-----------------:|---------:|
| 2020-08-31 |           36 |             8 |           2020 | ASIA   | Retail   | C3      | Retirees     | Couples     | New            |       120631 |            30.31 |  3656163 |
| 2020-08-31 |           36 |             8 |           2020 | ASIA   | Retail   | F1      | Young Adults | Families    | New            |        31574 |            31.56 |   996575 |
| 2020-08-31 |           36 |             8 |           2020 | USA    | Retail   | Unknown | Unknown      | Unknown     | Guest          |       529151 |            31.20 | 16509610 |
| 2020-08-31 |           36 |             8 |           2020 | EUROPE | Retail   | C1      | Young Adults | Couples     | New            |         4517 |            31.42 |   141942 |
| 2020-08-31 |           36 |             8 |           2020 | AFRICA | Retail   | C2      | Middle Aged  | Couples     | New            |        58046 |            30.29 |  1758388 |
| 2020-08-31 |           36 |             8 |           2020 | CANADA | Shopify  | F2      | Middle Aged  | Families    | Existing       |         1336 |           182.54 |   243878 |
| 2020-08-31 |           36 |             8 |           2020 | AFRICA | Shopify  | F3      | Retirees     | Families    | Existing       |         2514 |           206.64 |   519502 |
| 2020-08-31 |           36 |             8 |           2020 | ASIA   | Shopify  | F1      | Young Adults | Families    | Existing       |         2158 |           172.11 |   371417 |
| 2020-08-31 |           36 |             8 |           2020 | AFRICA | Shopify  | F2      | Middle Aged  | Families    | New            |          318 |           155.84 |    49557 |
| 2020-08-31 |           36 |             8 |           2020 | AFRICA | Retail   | C3      | Retirees     | Couples     | New            |       111032 |            35.02 |  3888162 |

Displaying records 1 - 10

</div>

## B. Data Exploration

**B.1 What day of the week is used for each week\_date value?**

``` sql
SELECT
    DATENAME(WEEKDAY, week_date) AS weekday
FROM
    clean_weekly_sales
```

<div class="knitsql-table">

| weekday |
|:--------|
| Monday  |
| Monday  |
| Monday  |
| Monday  |
| Monday  |
| Monday  |
| Monday  |
| Monday  |
| Monday  |
| Monday  |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**B.2 What range of week numbers are missing from the dataset?**

``` sql
WITH series AS(
    SELECT 
        n 
    FROM 
        GenerateSequence(1, 52)
)
SELECT
    n
FROM
    series s
LEFT OUTER JOIN
    clean_weekly_sales c
    ON s.n = c.week_number
WHERE c.week_number IS NULL
ORDER BY n;
```

<div class="knitsql-table">

| n   |
|:----|
| 1   |
| 2   |
| 3   |
| 4   |
| 5   |
| 6   |
| 7   |
| 8   |
| 9   |
| 10  |

Displaying records 1 - 10

</div>

There are 18 more rows that are not displayed.

------------------------------------------------------------------------

**B.3 How many total transactions were there for each year in the
dataset?**

``` sql
SELECT
    calender_year,
    COUNT(transactions) AS nbr_transactions
FROM
    clean_weekly_sales
GROUP BY calender_year
ORDER BY calender_year DESC;
```

<div class="knitsql-table">

| calender\_year | nbr\_transactions |
|---------------:|------------------:|
|           2020 |              5711 |
|           2019 |              5708 |
|           2018 |              5698 |

3 records

</div>

------------------------------------------------------------------------

**B.4 What is the total sales for each region for each month?**

``` sql
SELECT
    region,
    month_number,
    SUM(CAST(sales AS FLOAT)) AS total_sales
FROM
    clean_weekly_sales
GROUP BY region, month_number
ORDER BY region, month_number;
```

<div class="knitsql-table">

| region | month\_number | total\_sales |
|:-------|--------------:|-------------:|
| AFRICA |             3 |    567767480 |
| AFRICA |             4 |   1911783504 |
| AFRICA |             5 |   1647244738 |
| AFRICA |             6 |   1767559760 |
| AFRICA |             7 |   1960219710 |
| AFRICA |             8 |   1809596890 |
| AFRICA |             9 |    276320987 |
| ASIA   |             3 |    529770793 |
| ASIA   |             4 |   1804628707 |
| ASIA   |             5 |   1526285399 |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**B.5 What is the total count of transactions for each platform**

``` sql
SELECT
    platform,
    SUM(transactions) AS nbr_txn
FROM
    clean_weekly_sales
GROUP BY platform;
```

<div class="knitsql-table">

| platform |   nbr\_txn |
|:---------|-----------:|
| Retail   | 1081934227 |
| Shopify  |    5925169 |

2 records

</div>

------------------------------------------------------------------------

**B.6 What is the percentage of sales for Retail vs Shopify for each
month?**

``` sql
WITH cte_platform_sales AS(
    SELECT
        calender_year,
        month_number,
        CASE
            WHEN platform = 'Retail' THEN SUM(CAST(sales AS FLOAT)) / SUM(SUM(CAST(sales AS FLOAT))) OVER(PARTITION BY calender_year, month_number) END AS retail_pct,
        CASE
            WHEN platform = 'shopify' THEN SUM(CAST(sales AS FLOAT)) / SUM(SUM(CAST(sales AS FLOAT))) OVER(PARTITION BY calender_year, month_number) END AS shopify_pct
    FROM
        clean_weekly_sales
    GROUP BY calender_year, month_number, platform
)
SELECT
    calender_year,
    month_number,
    FORMAT(MAX(retail_pct),'p') AS retail_pct_sales,
    FORMAT(MAX(shopify_pct),'p') AS shopify_pct_sales
FROM
    cte_platform_sales
    GROUP BY calender_year, month_number;
```

<div class="knitsql-table">

| calender\_year | month\_number | retail\_pct\_sales | shopify\_pct\_sales |
|---------------:|--------------:|:-------------------|:--------------------|
|           2018 |             3 | 97.92%             | 2.08%               |
|           2018 |             4 | 97.93%             | 2.07%               |
|           2018 |             5 | 97.73%             | 2.27%               |
|           2018 |             6 | 97.76%             | 2.24%               |
|           2018 |             7 | 97.75%             | 2.25%               |
|           2018 |             8 | 97.71%             | 2.29%               |
|           2018 |             9 | 97.68%             | 2.32%               |
|           2019 |             3 | 97.71%             | 2.29%               |
|           2019 |             4 | 97.80%             | 2.20%               |
|           2019 |             5 | 97.52%             | 2.48%               |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**B.7 What is the percentage of sales by demographic for each year in
the dataset?**

``` sql
WITH cte_demographic_sales AS(
    SELECT
        calender_year,
        demographic,
        CASE
            WHEN demographic = 'Families' THEN SUM(CAST(sales AS FLOAT)) / SUM(SUM(CAST(sales AS FLOAT))) OVER(PARTITION BY calender_year) END AS families_pct,
        CASE
            WHEN demographic = 'Couples' THEN SUM(CAST(sales AS FLOAT)) / SUM(SUM(CAST(sales AS FLOAT))) OVER(PARTITION BY calender_year) END AS couples_pct,
        CASE    
            WHEN demographic = 'Unknown' THEN SUM(CAST(sales AS FLOAT)) / SUM(SUM(CAST(sales AS FLOAT))) OVER(PARTITION BY calender_year) END AS unknown_pct
    FROM
        clean_weekly_sales
    GROUP BY calender_year, demographic
)
SELECT
    calender_year,
    FORMAT(MAX(families_pct),'p') AS families_pct_sales,
    FORMAT(MAX(couples_pct),'p') AS couples_pct_sales,
    FORMAT(MAX(unknown_pct),'p') AS unknown_pct_sales
FROM
    cte_demographic_sales
GROUP BY calender_year
```

<div class="knitsql-table">

| calender\_year | families\_pct\_sales | couples\_pct\_sales | unknown\_pct\_sales |
|:---------------|:---------------------|:--------------------|:--------------------|
| 2018           | 31.99%               | 26.38%              | 41.63%              |
| 2019           | 32.47%               | 27.28%              | 40.25%              |
| 2020           | 32.73%               | 28.72%              | 38.55%              |

3 records

</div>

------------------------------------------------------------------------

**B.8 Which age\_band and demographic values contribute the most to
Retail sales?**

``` sql
SELECT
    age_band,
    demographic,
    SUM(CAST(sales AS FLOAT)) AS total_sales,
    FORMAT(SUM(CAST(sales AS FLOAT)) / SUM(SUM(CAST(sales AS FLOAT))) OVER(),'p') AS pct_sales
FROM
    clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY total_sales DESC;
```

<div class="knitsql-table">

| age\_band    | demographic | total\_sales | pct_sales   |
|:-------------|:------------|-------------:|:-------|
| Unknown      | Unknown     |  16067285533 | 40.52% |
| Retirees     | Families    |   6634686916 | 16.73% |
| Retirees     | Couples     |   6370580014 | 16.07% |
| Middle Aged  | Families    |   4354091554 | 10.98% |
| Young Adults | Couples     |   2602922797 | 6.56%  |
| Middle Aged  | Couples     |   1854160330 | 4.68%  |
| Young Adults | Families    |   1770889293 | 4.47%  |

7 records

</div>

------------------------------------------------------------------------

**B.9 Can we use the avg\_transaction column to find the average
transaction size for each year for Retail vs Shopify? If not - how would
you calculate it instead?**

``` sql
SELECT
    calender_year,
    platform,
    ROUND(AVG(avg_transaction),2) AS avg_by_row,
    ROUND(SUM(CAST(sales AS FLOAT)) / SUM(transactions),2) AS avg_by_year
FROM    
    clean_weekly_sales
GROUP BY calender_year, platform
ORDER BY calender_year
```

<div class="knitsql-table">

| calender\_year | platform | avg\_by\_row | avg\_by\_year |
|---------------:|:---------|-------------:|--------------:|
|           2018 | Retail   |        42.91 |         36.56 |
|           2018 | Shopify  |       188.28 |        192.48 |
|           2019 | Retail   |        41.97 |         36.83 |
|           2019 | Shopify  |       177.56 |        183.36 |
|           2020 | Shopify  |       174.87 |        179.03 |
|           2020 | Retail   |        40.64 |         36.56 |

6 records

</div>

Using the avg\_transaction column gets us the average transaction size
by each row of each year, while calculating the total sum by number of
transactions per year in the next column is more accurate.

## C. Before & After Analysis

This technique is usually used when we inspect an important event and
want to inspect the impact before and after a certain point in time.

Taking the week\_date value of **2020-06-15** as the baseline week where
the Data Mart sustainable packaging changes came into effect.

We would include all week\_date values for **2020-06-15** as the start
of the period after the change and the previous week\_date values would
be before

Using this analysis approach - answer the following questions:

**C.1 What is the total sales for the 4 weeks before and after
2020-06-15? What is the growth or reduction rate in actual values and
percentage of sales?**

``` sql
WITH cte_weekly_sales AS (
    SELECT
        week_number,
        SUM(CAST(sales AS FLOAT)) AS weekly_sales
    FROM
        clean_weekly_sales
    WHERE calender_year = 2020 
        AND week_number BETWEEN 21 AND 28
    GROUP BY week_number
),
cte_categorise AS(
    SELECT
        SUM(CASE WHEN week_number < 25 THEN weekly_sales END) AS total_sales_before,
        SUM(CASE WHEN week_number >= 25 THEN weekly_sales END) AS total_sales_after
    FROM
        cte_weekly_sales
)
SELECT
    total_sales_before,
    total_sales_after,
    total_sales_after - total_sales_before AS total_change,
    FORMAT((total_sales_after - total_sales_before) / total_sales_before, 'p') AS pct_change
FROM
    cte_categorise;
```

<div class="knitsql-table">

| total\_sales\_before | total\_sales\_after | total\_change | pct\_change |
|---------------------:|--------------------:|--------------:|:------------|
|           2345878357 |          2318994169 |     -26884188 | -1.15%      |

1 records

</div>

------------------------------------------------------------------------

**C.2 What about the entire 12 weeks before and after?**

``` sql
WITH cte_weekly_sales AS (
    SELECT
        week_number,
        SUM(CAST(sales AS FLOAT)) AS weekly_sales
    FROM
        clean_weekly_sales
    WHERE calender_year = 2020 
        AND week_number BETWEEN 13 AND 36
    GROUP BY week_number
),
cte_categorise AS(
    SELECT
        SUM(CASE WHEN week_number < 25 THEN weekly_sales END) AS total_sales_before,
        SUM(CASE WHEN week_number >= 25 THEN weekly_sales END) AS total_sales_after
    FROM
        cte_weekly_sales
)
SELECT
    total_sales_before,
    total_sales_after,
    total_sales_after - total_sales_before AS total_change,
    FORMAT((total_sales_after - total_sales_before) / total_sales_before, 'p') AS pct_change
FROM
    cte_categorise;
```

<div class="knitsql-table">

| total\_sales\_before | total\_sales\_after | total\_change | pct\_change |
|---------------------:|--------------------:|--------------:|:------------|
|           7126273147 |          6973947753 |    -152325394 | -2.14%      |

1 records

</div>

------------------------------------------------------------------------

**C.3 How do the sale metrics for these 2 periods before and after
compare with the previous years in 2018 and 2019?**

**For the 4 week before- and after periods:**

``` sql
WITH cte_weekly_sales AS (
    SELECT
        calender_year,
        week_number,
        SUM(CAST(sales AS FLOAT)) AS weekly_sales
    FROM
        clean_weekly_sales
    WHERE week_number BETWEEN 21 AND 28
    GROUP BY calender_year, week_number
),
cte_categorise AS(
    SELECT
        calender_year,
        SUM(CASE WHEN week_number < 25 THEN weekly_sales END) AS total_sales_before,
        SUM(CASE WHEN week_number >= 25 THEN weekly_sales END) AS total_sales_after
    FROM
        cte_weekly_sales
    GROUP BY calender_year
)
SELECT
    calender_year,
    total_sales_before,
    total_sales_after,
    total_sales_after - total_sales_before AS total_change,
    FORMAT((total_sales_after - total_sales_before) / total_sales_before, 'p') AS pct_change
FROM
    cte_categorise;
```

<div class="knitsql-table">

| calender\_year | total\_sales\_before | total\_sales\_after | total\_change | pct\_change |
|:---------------|---------------------:|--------------------:|--------------:|:------------|
| 2018           |           2125140809 |          2129242914 |       4102105 | 0.19%       |
| 2019           |           2249989796 |          2252326390 |       2336594 | 0.10%       |
| 2020           |           2345878357 |          2318994169 |     -26884188 | -1.15%      |

3 records

</div>

**For the 12 week before- and after periods:**

``` sql
WITH cte_weekly_sales AS (
    SELECT
        calender_year,
        week_number,
        SUM(CAST(sales AS FLOAT)) AS weekly_sales
    FROM
        clean_weekly_sales
    WHERE week_number BETWEEN 13 AND 36
    GROUP BY calender_year, week_number
),
cte_categorise AS(
    SELECT
        calender_year,
        SUM(CASE WHEN week_number < 25 THEN weekly_sales END) AS total_sales_before,
        SUM(CASE WHEN week_number >= 25 THEN weekly_sales END) AS total_sales_after
    FROM
        cte_weekly_sales
    GROUP BY calender_year
)
SELECT
    calender_year,
    total_sales_before,
    total_sales_after,
    total_sales_after - total_sales_before AS total_change,
    FORMAT((total_sales_after - total_sales_before) / total_sales_before, 'p') AS pct_change
FROM
    cte_categorise;
```

<div class="knitsql-table">

| calender\_year | total\_sales\_before | total\_sales\_after | total\_change | pct\_change |
|:---------------|---------------------:|--------------------:|--------------:|:------------|
| 2018           |           6396562317 |          6500818510 |     104256193 | 1.63%       |
| 2019           |           6883386397 |          6862646103 |     -20740294 | -0.30%      |
| 2020           |           7126273147 |          6973947753 |    -152325394 | -2.14%      |

3 records

</div>

## Bonus Question

**Which areas of the business have the highest negative impact in sales
metrics performance in 2020 for the 12 week before and after period?**

-   **region**
-   **platform**
-   **age\_band**
-   **demographic**
-   **customer\_type**

The only way I can think of solving this question is to group up and
calculating the difference in amount and rate, similar to the questions
in C. It wont naturally tell us which of columns are to blame for the
negative impact, but we can see which specific areas are doing the
worst.

I’ll insert the query into a new table, that way I avoid duplicating the
code for just reordering the results by amount and rate respectively.

``` sql
WITH cte_sales AS (
    SELECT
        region,
        platform,
        age_band,
        demographic,
        customer_type,
        week_number,
        SUM(CAST(sales AS FLOAT)) AS sales
    FROM
        clean_weekly_sales
    WHERE week_number BETWEEN 13 AND 36
    GROUP BY region,
        platform,
        age_band,
        demographic,
        customer_type,
        week_number
),
cte_categorise AS(
    SELECT
        region,
        platform,
        age_band,
        demographic,
        customer_type,
        SUM(CASE WHEN week_number < 25 THEN sales END) AS total_sales_before,
        SUM(CASE WHEN week_number >= 25 THEN sales END) AS total_sales_after
    FROM
        cte_sales
    GROUP BY region,
        platform,
        age_band,
        demographic,
        customer_type
)
SELECT
    region,
    platform,
    age_band,
    demographic,
    customer_type,
    total_sales_before,
    total_sales_after,
    total_sales_after - total_sales_before AS total_change,
    ROUND(100*((total_sales_after - total_sales_before) / total_sales_before),2) AS pct_change
INTO
    temp_sales_metrics
FROM
    cte_categorise;
```

Highest negative impact on sales in terms of amount:

``` sql
SELECT TOP 1
    *
FROM
    temp_sales_metrics
ORDER BY pct_change;
```

<div class="knitsql-table">

| region        | platform | age\_band | demographic | customer\_type | total\_sales\_before | total\_sales\_after | total\_change | pct\_change |
|:--------------|:---------|:----------|:------------|:---------------|---------------------:|--------------------:|--------------:|------------:|
| SOUTH AMERICA | Retail   | Unknown   | Unknown     | Existing       |               609879 |              456009 |       -153870 |      -25.23 |

1 records

</div>

Highest negative impact on sales in terms of rate of decrease:

``` sql
SELECT TOP 1
    *
FROM
    temp_sales_metrics
ORDER BY total_change;
```

<div class="knitsql-table">

| region | platform | age\_band | demographic | customer\_type | total\_sales\_before | total\_sales\_after | total\_change | pct\_change |
|:-------|:---------|:----------|:------------|:---------------|---------------------:|--------------------:|--------------:|------------:|
| ASIA   | Retail   | Unknown   | Unknown     | Guest          |           1775661158 |          1740139393 |     -35521765 |          -2 |

1 records

</div>
