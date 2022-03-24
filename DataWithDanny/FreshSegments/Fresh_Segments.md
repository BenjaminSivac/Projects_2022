Data With Danny: Fresh Segments
================
Benjamin Sivac
2022-03-24

<p align="center">
  <img src= "https://github.com/BenjaminSivac/Projects_2022/blob/main/DataWithDanny/FreshSegments/fs.png"
       height="850px" width="850px"/>
</p>

### Task

Danny created Fresh Segments, a digital marketing agency that helps
other businesses analyse trends in online ad click behaviour for their
unique customer base.

Clients share their customer lists with the Fresh Segments team who then
aggregate interest metrics and generate a single dataset worth of
metrics for further analysis.

In particular - the composition and rankings for different interests are
provided for each client showing the proportion of their customer list
who interacted with online assets related to each interest for each
month.

Danny has asked for your assistance to analyse aggregated metrics for an
example client and provide some high level insights about the customer
list and their interests.

### Available Data

For this case study there is a total of 2 datasets which you will need
to use to solve the questions.

### Interest Metrics

This table contains information about aggregated interest metrics for a
specific major client of Fresh Segments which makes up a large
proportion of their customer base.

Each record in this table represents the performance of a specific
interest\_id based on the client’s customer base interest measured
through clicks and interactions with specific targeted advertising
content.

<div class="knitsql-table">

| \_month | \_year | interest\_id | composition | index\_value | ranking | percentile\_ranking | month\_year |
|:--------|:-------|:-------------|------------:|-------------:|--------:|--------------------:|:------------|
| 7       | 2018   | 32486        |       11.89 |         6.19 |       1 |               99.86 | 2018-07-01  |
| 7       | 2018   | 6106         |        9.93 |         5.31 |       2 |               99.73 | 2018-07-01  |
| 7       | 2018   | 18923        |       10.85 |         5.29 |       3 |               99.59 | 2018-07-01  |
| 7       | 2018   | 6344         |       10.32 |         5.10 |       4 |               99.45 | 2018-07-01  |
| 7       | 2018   | 100          |       10.77 |         5.04 |       5 |               99.31 | 2018-07-01  |
| 7       | 2018   | 69           |       10.82 |         5.03 |       6 |               99.18 | 2018-07-01  |
| 7       | 2018   | 79           |       11.21 |         4.97 |       7 |               99.04 | 2018-07-01  |
| 7       | 2018   | 6111         |       10.71 |         4.83 |       8 |               98.90 | 2018-07-01  |
| 7       | 2018   | 6214         |        9.71 |         4.83 |       8 |               98.90 | 2018-07-01  |
| 7       | 2018   | 19422        |       10.11 |         4.81 |      10 |               98.63 | 2018-07-01  |

Displaying records 1 - 10

</div>

For example for the first row, in July 2018, the composition metric is
11.89, meaning that 11.89% of the client’s customer list interacted with
the interest interest\_id = 32486 - we can link interest\_id to a
separate mapping table to find the segment name called “Vacation Rental
Accommodation Researchers”

The index\_value is 6.19, means that the composition value is 6.19x the
average composition value for all Fresh Segments clients’ customer for
this particular interest in the month of July 2018.

The ranking and percentage\_ranking relates to the order of index\_value
records in each month year.

### Interest Map

This mapping table links the interest\_id with their relevant interest
information. You will need to join this table onto the previous
interest\_details table to obtain the interest\_name as well as any
details about the summary information.

<div class="knitsql-table">

|  id | interest\_name            | interest\_summary                                                                  |
|----:|:--------------------------|:-----------------------------------------------------------------------------------|
|   1 | Fitness Enthusiasts       | Consumers using fitness tracking apps and websites.                                |
|   2 | Gamers                    | Consumers researching game reviews and cheat codes.                                |
|   3 | Car Enthusiasts           | Readers of automotive news and car reviews.                                        |
|   4 | Luxury Retail Researchers | Consumers researching luxury product reviews and gift ideas.                       |
|   5 | Brides & Wedding Planners | People researching wedding ideas and vendors.                                      |
|   6 | Vacation Planners         | Consumers reading reviews of vacation destinations and accommodations.             |
|   7 | Motorcycle Enthusiasts    | Readers of motorcycle news and reviews.                                            |
|   8 | Business News Readers     | Readers of online business news content.                                           |
|  12 | Thrift Store Shoppers     | Consumers shopping online for clothing at thrift stores and researching locations. |
|  13 | Advertising Professionals | People who read advertising industry news.                                         |

Displaying records 1 - 10

</div>

#### 1. Data Exploration and Cleansing

**1.Update the interest\_metrics table by modifying the month\_year
column to be a date data type with the start of the month**

MSQL can’t convert MM-YYYY format to date, so we’ll instead create
another column with DATE type, set new column equal to old values +
another date stamp, remove old one, and finally rename the new column to
month\_year

``` sql
ALTER TABLE interest_metrics 
ADD month DATE;

UPDATE interest_metrics
SET month='01-' + [month_year] -- Only way I can add another date element, but the server thinks it is month.

UPDATE interest_metrics
SET month= FORMAT(month,'dd/MM/yyyy') -- Now it's in a correct format !

ALTER TABLE interest_metrics
DROP COLUMN month_year -- drop old column

exec sp_RENAME 'interest_metrics.month','month_year', 'COLUMN' -- rename our new column.
-- Annoying but what can you do...
```

------------------------------------------------------------------------

**2. What is count of records in the fresh\_segments.interest\_metrics
for each month\_year value sorted in chronological order (earliest to
latest) with the null values appearing first?**

``` sql
SELECT 
    month_year,
    COUNT(month_year) AS count_records
FROM
    interest_metrics
GROUP BY month_year
ORDER BY month_year
```

<div class="knitsql-table">

| month\_year | count\_records |
|:------------|---------------:|
| NA          |              0 |
| 2018-07-01  |            729 |
| 2018-08-01  |            767 |
| 2018-09-01  |            780 |
| 2018-10-01  |            857 |
| 2018-11-01  |            928 |
| 2018-12-01  |            995 |
| 2019-01-01  |            973 |
| 2019-02-01  |           1121 |
| 2019-03-01  |           1136 |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**3. What do you think we should do with these null values in the
fresh\_segments.interest\_metrics**

``` sql
SELECT 
    *
FROM
    interest_metrics
ORDER BY month_year
```

<div class="knitsql-table">

| \_month | \_year | interest\_id | composition | index\_value | ranking | percentile\_ranking | month\_year |
|:--------|:-------|:-------------|------------:|-------------:|--------:|--------------------:|:------------|
| NA      | NA     | NA           |        6.57 |         2.81 |      51 |               95.73 | NA          |
| NA      | NA     | NA           |        7.13 |         2.84 |      45 |               96.23 | NA          |
| NA      | NA     | NA           |        5.96 |         2.83 |      47 |               96.06 | NA          |
| NA      | NA     | NA           |        6.15 |         2.82 |      48 |               95.98 | NA          |
| NA      | NA     | NA           |        6.05 |         2.81 |      51 |               95.73 | NA          |
| NA      | NA     | NA           |        6.04 |         2.81 |      51 |               95.73 | NA          |
| NA      | NA     | NA           |        5.74 |         2.81 |      51 |               95.73 | NA          |
| NA      | NA     | NA           |        4.93 |         2.77 |      57 |               95.23 | NA          |
| NA      | NA     | NA           |        5.73 |         2.76 |      58 |               95.14 | NA          |
| NA      | NA     | NA           |        6.12 |         2.85 |      43 |               96.40 | NA          |

Displaying records 1 - 10

</div>

All but 1 record with month\_year as NULL has NULL values in
interest\_id. It’d be hard to identify clients without the id and time
stamp, so we either drop or filter em out.

------------------------------------------------------------------------

**4. How many interest\_id values exist in the
fresh\_segments.interest\_metrics table but not in the
fresh\_segments.interest\_map table? What about the other way around?**

``` sql
SELECT
    COUNT(DISTINCT(interest_id)) AS interest_id_count,
    COUNT(DISTINCT(id)) AS id_count,
    SUM(CASE WHEN interest_id IS NULL THEN 1 END) AS not_in_map,
    SUM(CASE WHEN id IS NULL THEN 1 END) AS not_in_metric
FROM
    interest_metrics metrics
    RIGHT OUTER JOIN 
        interest_map map
        ON
            metrics.interest_id = map.id
```

<div class="knitsql-table">

| interest\_id\_count | id\_count | not\_in\_map | not\_in\_metric |
|--------------------:|----------:|-------------:|----------------:|
|                1202 |      1209 |            7 |              NA |

1 records

</div>

There are 7 id values in interest\_map that are not in
interest\_metrics, and 0 interest id values in interest\_metrics that
are not in interest\_map.

------------------------------------------------------------------------

**5. Summarise the id values in the fresh\_segments.interest\_map by its
total record count in this table**

``` sql
SELECT
  COUNT(*) AS total_record_count
FROM
  interest_map
```

<div class="knitsql-table">

| total\_record\_count |
|---------------------:|
|                 1209 |

1 records

</div>

An unusually simple question…

------------------------------------------------------------------------

**6. What sort of table join should we perform for our analysis and why?
Check your logic by checking the rows where interest\_id = 21246 in your
joined output and include all columns from
fresh\_segments.interest\_metrics and all columns from
fresh\_segments.interest\_map except from the id column.**

To query all columns from both tables, while filtering for only id
21245, we can use INNER JOIN.

``` sql
SELECT _month, _year, interest_id, composition, index_value, ranking, percentile_ranking, month_year,
      interest_name, interest_summary
FROM interest_metrics metrics
INNER JOIN interest_map map
  ON metrics.interest_id = map.id
WHERE interest_id = 21246
```

<div class="knitsql-table">

| \_month | \_year | interest\_id | composition | index\_value | ranking | percentile\_ranking | month\_year | interest\_name                   | interest\_summary                                     |
|:--------|:-------|:-------------|------------:|-------------:|--------:|--------------------:|:------------|:---------------------------------|:------------------------------------------------------|
| 7       | 2018   | 21246        |        2.26 |         0.65 |     722 |                0.96 | 2018-07-01  | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |
| 8       | 2018   | 21246        |        2.13 |         0.59 |     765 |                0.26 | 2018-08-01  | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |
| 9       | 2018   | 21246        |        2.06 |         0.61 |     774 |                0.77 | 2018-09-01  | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |
| 10      | 2018   | 21246        |        1.74 |         0.58 |     855 |                0.23 | 2018-10-01  | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |
| 11      | 2018   | 21246        |        2.25 |         0.78 |     908 |                2.16 | 2018-11-01  | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |
| 12      | 2018   | 21246        |        1.97 |         0.70 |     983 |                1.21 | 2018-12-01  | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |
| 1       | 2019   | 21246        |        2.05 |         0.76 |     954 |                1.95 | 2019-01-01  | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |
| 2       | 2019   | 21246        |        1.84 |         0.68 |    1109 |                1.07 | 2019-02-01  | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |
| 3       | 2019   | 21246        |        1.75 |         0.67 |    1123 |                1.14 | 2019-03-01  | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |
| 4       | 2019   | 21246        |        1.58 |         0.63 |    1092 |                0.64 | 2019-04-01  | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. |

Displaying records 1 - 10

</div>

Note that we get one record with NULL time stamps values, which wont
neccesarily disturb our analysis unless we are specifically interested
in said time stamps. Also, there’s no convenient way to exclude one
column, like id, from a \* query. So I had to list each column name.

------------------------------------------------------------------------

**7. Are there any records in your joined table where the month\_year
value is before the created\_at value from the
fresh\_segments.interest\_map table? Do you think these values are valid
and why?**

``` sql
SELECT 
    COUNT(*)
FROM interest_metrics me
INNER JOIN interest_map ma
  ON me.interest_id = ma.id
WHERE MONTH(month_year) < MONTH(created_at)
```

<div class="knitsql-table">

|      |
|-----:|
| 4972 |

1 records

</div>

We’ll cross reference with the \_month column and find out if we get the
same number of observations.

``` sql
SELECT 
    COUNT(*)
FROM interest_metrics me
INNER JOIN interest_map ma
  ON me.interest_id = ma.id
WHERE _month < MONTH(created_at)
```

<div class="knitsql-table">

|      |
|-----:|
| 4972 |

1 records

</div>

Confirmed to also be 4972 observations. I assume that the interest\_map
table was created at a later date which is what the created\_at column
is referring to. It would then not share any connections to the other
time stamp columns, and is therefore valid and accurate.

------------------------------------------------------------------------

#### B. Interest Analysis

**1. Which interests have been present in all month\_year dates in our
dataset?**

``` sql
WITH cte_total_months AS(
    SELECT 
        interest_id,
        COUNT(DISTINCT month_year) AS total_months 
    FROM
        interest_metrics
    WHERE month_year IS NOT NULL
    GROUP BY interest_id
)

SELECT 
    COUNT(DISTINCT interest_id) AS countd_interests,
    total_months
FROM
    cte_total_months
WHERE total_months = 14
GROUP BY total_months;
```

<div class="knitsql-table">

| countd\_interests | total\_months |
|------------------:|--------------:|
|               480 |            14 |

1 records

</div>

------------------------------------------------------------------------

**2. Using this same total\_months measure - calculate the cumulative
percentage of all records starting at 14 months - which total\_months
value passes the 90% cumulative percentage value?**

``` sql
WITH cte_total_months AS(
    SELECT 
        interest_id,
        COUNT(DISTINCT month_year) AS total_months 
    FROM
        interest_metrics
    WHERE month_year IS NOT NULL
    GROUP BY interest_id
),
cte_countd_interests AS(
    SELECT
        COUNT(DISTINCT interest_id) as countd_interests,
        total_months
    FROM
        cte_total_months
    GROUP BY total_months
)

SELECT 
    total_months,
    countd_interests,
    100 * SUM(countd_interests) OVER (ORDER BY total_months DESC) /
      SUM(countd_interests) OVER () AS cumulative_percentage -- running sum of all interests, by total_months, divided by sum of all interests.
FROM
    cte_countd_interests;
```

<div class="knitsql-table">

| total\_months | countd\_interests | cumulative\_percentage |
|--------------:|------------------:|-----------------------:|
|            14 |               480 |                     39 |
|            13 |                82 |                     46 |
|            12 |                65 |                     52 |
|            11 |                94 |                     59 |
|            10 |                86 |                     67 |
|             9 |                95 |                     75 |
|             8 |                67 |                     80 |
|             7 |                90 |                     88 |
|             6 |                33 |                     90 |
|             5 |                38 |                     94 |

Displaying records 1 - 10

</div>

Cumulative percentaget value passes 90% by 6 months and above. Rest have
relatively low clicks and interactions.

------------------------------------------------------------------------

**3. If we were to remove all interest\_id values which are lower than
the total\_months value we found in the previous question - how many
total data points would we be removing?**

``` sql
WITH cte_total_months AS(
    SELECT 
        interest_id,
        COUNT(DISTINCT month_year) AS total_months 
    FROM
        interest_metrics
    WHERE month_year IS NOT NULL
    GROUP BY interest_id
),
cte_low_months AS(
    SELECT
        COUNT(DISTINCT interest_id) as countd_interests,
        total_months
    FROM
        cte_total_months
    GROUP BY total_months
    HAVING total_months < 6
)
SELECT
    SUM(countd_interests) AS nbr_data_pts
FROM 
    cte_low_months;
```

<div class="knitsql-table">

| nbr\_data\_pts |
|---------------:|
|            110 |

1 records

</div>

110 observations have less than 6 months of interests and is expected to
be removed.

------------------------------------------------------------------------

**4. Does this decision make sense to remove these data points from a
business perspective? Use an example where there are all 14 months
present to a removed interest example for your arguments - think about
what it means to have less months present from a segment perspective.**

No they should be investigated and improved upon to garner more clicks
and interactions. The more segments there are, the harder it is to reach
these arbitrary thresholds. Removing an interest with 14 months present
vs one with 1 present months has the same impact on the cumulative
percentage.

------------------------------------------------------------------------

**5. After removing these interests - how many unique interests are
there for each month?** We first count distinct months per interest\_id,
filter by number of months, and then summarise each unique interest by
month.

``` sql
WITH cte_total_months AS(
    SELECT 
        DISTINCT interest_id AS unique_interests,
        COUNT(DISTINCT month_year) AS total_months
    FROM
        interest_metrics
    WHERE month_year IS NOT NULL
    GROUP BY interest_id
),
cte_filter AS ( 
    SELECT
        COUNT(unique_interests) as nbr_unique_interests,
        metrics.month_year,
        total_months
    FROM
        cte_total_months cte
        INNER JOIN
            interest_metrics metrics
        ON
            cte.unique_interests = metrics.interest_id      
    GROUP BY total_months, metrics.month_year
    HAVING total_months > 5
)
SELECT
    SUM(nbr_unique_interests) AS count_unique_interests,
    month_year
FROM
    cte_filter
GROUP BY month_year;
```

<div class="knitsql-table">

| count\_unique\_interests | month\_year |
|-------------------------:|:------------|
|                        1 | NA          |
|                      709 | 2018-07-01  |
|                      752 | 2018-08-01  |
|                      774 | 2018-09-01  |
|                      853 | 2018-10-01  |
|                      925 | 2018-11-01  |
|                      986 | 2018-12-01  |
|                      966 | 2019-01-01  |
|                     1072 | 2019-02-01  |
|                     1078 | 2019-03-01  |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

#### C. Segment Analysis

**1. Using our filtered dataset by removing the interests with less than
6 months worth of data, which are the top 10 and bottom 10 interests
which have the largest composition values in any month\_year? Only use
the maximum composition value for each interest but you must keep the
corresponding month\_year**

``` sql
WITH cte_total_months AS(
    SELECT 
        DISTINCT interest_id AS unique_interests,
        COUNT(DISTINCT month_year) AS total_months
    FROM
        interest_metrics
    WHERE month_year IS NOT NULL
    GROUP BY interest_id
),
cte_filter AS(
    SELECT
        unique_interests,
        me.month_year,
        MAX(composition) AS max_comp
    FROM
        cte_total_months cte
        INNER JOIN
            interest_metrics me
        ON
            cte.unique_interests = me.interest_id       
    GROUP BY total_months, me.month_year, composition, unique_interests
    HAVING total_months > 5
)
SELECT
    month_year,
    max_comp,
    unique_interests
FROM
    cte_filter
GROUP BY month_year, max_comp, unique_interests
ORDER BY unique_interests
```

<div class="knitsql-table">

| month\_year | max\_comp | unique\_interests |
|:------------|----------:|:------------------|
| 2018-07-01  |      7.02 | 1                 |
| 2018-08-01  |      3.44 | 1                 |
| 2018-09-01  |      2.44 | 1                 |
| 2018-10-01  |      3.71 | 1                 |
| 2018-11-01  |      2.79 | 1                 |
| 2018-12-01  |      2.94 | 1                 |
| 2019-01-01  |      2.38 | 1                 |
| 2019-02-01  |      2.55 | 1                 |
| 2019-03-01  |      2.76 | 1                 |
| 2019-04-01  |      2.28 | 1                 |

Displaying records 1 - 10

</div>

WIP. Query unique\_interests by max\_comp.

------------------------------------------------------------------------
