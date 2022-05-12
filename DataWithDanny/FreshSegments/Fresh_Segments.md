Data With Danny: Fresh Segments
================
Benjamin Sivac
2022-05-12

## Introduction

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

## Available Data

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

# Case Study Questions

The following questions can be considered key business questions that
are required to be answered for the Fresh Segments team.

Most questions can be answered using a single query however some
questions are more open ended and require additional thought and not
just a coded solution!

## A. Data Exploration and Cleansing

**A.1 Update the interest\_metrics table by modifying the month\_year
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

**A.2 What is count of records in the fresh\_segments.interest\_metrics
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

**A.3 What do you think we should do with these null values in the
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

**A.4 How many interest\_id values exist in the
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

**A.5 Summarise the id values in the fresh\_segments.interest\_map by
its total record count in this table**

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

**A.6 What sort of table join should we perform for our analysis and
why? Check your logic by checking the rows where interest\_id = 21246 in
your joined output and include all columns from
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

**A.7 Are there any records in your joined table where the month\_year
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

## B. Interest Analysis

**B.1 Which interests have been present in all month\_year dates in our
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

**B.2 Using this same total\_months measure - calculate the cumulative
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

**B.3 If we were to remove all interest\_id values which are lower than
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

**B.4 Does this decision make sense to remove these data points from a
business perspective? Use an example where there are all 14 months
present to a removed interest example for your arguments - think about
what it means to have less months present from a segment perspective.**

No they should be investigated and improved upon to garner more clicks
and interactions. The more segments there are, the harder it is to reach
these arbitrary thresholds. Removing an interest with 14 months present
vs one with 1 present months has the same impact on the cumulative
percentage.

------------------------------------------------------------------------

**B.5 After removing these interests - how many unique interests are
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

## C. Segment Analysis

**C.1 Using our filtered dataset by removing the interests with less
than 6 months worth of data, which are the top 10 and bottom 10
interests which have the largest composition values in any month\_year?
Only use the maximum composition value for each interest but you must
keep the corresponding month\_year**

Note that I was not able to join the tables for each question below this
analysis for querying interest\_name, as it resulted in an “Invalid
Descriptor Index” error when I wrote it in Rmarkdown.

``` sql
WITH cte_filtered AS(
    SELECT
        DISTINCT interest_id AS unique_interest_id,
        MAX(composition) AS max_comp
    FROM
        interest_metrics
    WHERE month_year IS NOT NULL
    GROUP BY interest_id
    HAVING COUNT(DISTINCT month_year)>5
),
cte_t1 AS(
SELECT
        unique_interest_id,
        max_comp,
        FORMAT(month_year, 'MMM yyyy') AS month_year
    FROM
        cte_filtered cte
    INNER JOIN
        interest_metrics me
        ON  cte.unique_interest_id = me.interest_id AND cte.max_comp=me.composition
)
        
SELECT TOP 10
  *
FROM
  cte_t1
ORDER BY max_comp DESC
```

<div class="knitsql-table">

| unique\_interest\_id | max\_comp | month\_year |
|:---------------------|----------:|:------------|
| 21057                |     21.20 | Dec 2018    |
| 6284                 |     18.82 | Jul 2018    |
| 39                   |     17.44 | Jul 2018    |
| 77                   |     17.19 | Jul 2018    |
| 12133                |     15.15 | Oct 2018    |
| 5969                 |     15.05 | Dec 2018    |
| 171                  |     14.91 | Jul 2018    |
| 4898                 |     14.23 | Jul 2018    |
| 6286                 |     14.10 | Jul 2018    |
| 4                    |     13.97 | Jul 2018    |

Displaying records 1 - 10

</div>

``` sql
SELECT TOP 10
  *
FROM
  cte_t1
ORDER BY max_comp
```

<div class="knitsql-table">

| unique\_interest\_id | max\_comp | month\_year |
|:---------------------|----------:|:------------|
| 33958                |      1.88 | Aug 2018    |
| 37412                |      1.94 | Oct 2018    |
| 19599                |      1.97 | Mar 2019    |
| 19635                |      2.05 | Jul 2018    |
| 19591                |      2.08 | Oct 2018    |
| 42011                |      2.09 | Jan 2019    |
| 37421                |      2.09 | Aug 2019    |
| 22408                |      2.12 | Jul 2018    |
| 34085                |      2.14 | Aug 2019    |
| 58                   |      2.18 | Jul 2018    |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**C.2 Which 5 interests had the lowest average ranking value?**

``` sql
SELECT TOP 5
    interest_id,
    AVG(ranking) AS avg_rank
FROM
    interest_metrics 
GROUP BY interest_id
ORDER BY AVG(ranking) DESC
```

<div class="knitsql-table">

| interest\_id | avg\_rank |
|:-------------|----------:|
| 42401        |      1141 |
| 42008        |      1135 |
| 45522        |      1110 |
| 43552        |      1110 |
| 46567        |      1078 |

5 records

</div>

------------------------------------------------------------------------

**C.3 Which 5 interests had the largest standard deviation in their
percentile\_ranking value?**

``` sql
WITH cte_sd AS(
    SELECT TOP 5
        interest_id,
        STDEV(percentile_ranking) AS sd_centile_rank
    FROM
        interest_metrics 
    GROUP BY interest_id
    ORDER BY STDEV(percentile_ranking) DESC
)
SELECT
    interest_id,
    ROUND(sd_centile_rank,2) AS sd_centile_rank
FROM
    cte_sd sd
ORDER BY sd_centile_rank DESC;
```

<div class="knitsql-table">

| interest\_id | sd\_centile\_rank |
|:-------------|------------------:|
| 6260         |             41.27 |
| 131          |             30.72 |
| 150          |             30.36 |
| 23           |             30.18 |
| 20764        |             28.97 |

5 records

</div>

------------------------------------------------------------------------

**C.4 For the 5 interests found in the previous question - what was
minimum and maximum percentile\_ranking values for each interest and its
corresponding year\_month value? Can you describe what is happening for
these 5 interests?**

``` sql
WITH cte_sd AS(
    SELECT TOP 5
        interest_id,
        MAX(percentile_ranking) AS max_centile,
        MIN(percentile_ranking) AS min_centile
    FROM
        interest_metrics 
    GROUP BY interest_id
    ORDER BY STDEV(percentile_ranking) DESC
),
cte_max_month AS(
    SELECT
        sd.interest_id as interest_id,
        max_centile,
        min_centile,
        month_year AS max_month_year
    FROM
        cte_sd sd
    INNER JOIN
        interest_metrics t1
        ON  sd.interest_id = t1.interest_id AND max_centile=t1.percentile_ranking
)
SELECT
    mm.interest_id,
    max_centile,
    FORMAT(max_month_year, 'MMM yyyy') AS max_month_year,
    min_centile,
    FORMAT(t2.month_year, 'MMM yyyy') AS min_month_year
FROM
    cte_max_month mm
INNER JOIN
    interest_metrics t2
    ON  mm.interest_id = t2.interest_id AND min_centile=t2.percentile_ranking
```

<div class="knitsql-table">

| interest\_id | max\_centile | max\_month\_year | min\_centile | min\_month\_year |
|:-------------|-------------:|:-----------------|-------------:|:-----------------|
| 150          |        93.28 | Jul 2018         |        10.01 | Aug 2019         |
| 23           |        86.69 | Jul 2018         |         7.92 | Aug 2019         |
| 20764        |        86.15 | Jul 2018         |        11.23 | Aug 2019         |
| 131          |        75.03 | Jul 2018         |         4.84 | Mar 2019         |
| 6260         |        60.63 | Jul 2018         |         2.26 | Aug 2019         |

5 records

</div>

Probably not the most efficient solution for retrieving an output with
months for each max and min value on the same row. I’d bet that there is
an obviously better format, perhaps by doing it in a long format and not
minding any null values, but I thought this would look somewhat nicer.

------------------------------------------------------------------------

**C.5 How would you describe our customers in this segment based off
their composition and ranking values? What sort of products or services
should we show to these customers and what should we avoid?**

The interest id’s are in order: ‘Tv Junkies’, ‘Techies’, ‘Entertainment
Industry Decision Makers’, ‘Android Fans’, and ‘Blackbuster Movie Fans’.

As for my observations; There’s a High variation by seasons, and a big
reliance on new products and shows to engage them. I believe new
flagship phones do release in July, and hype for seasonal tv shows peak
for their finales in late july, resulting in a following drought before
the next season begins.

## D. Index Analysis

**D.1 What is the top 10 interests by the average composition for each
month?**

``` sql
WITH cte_rn AS(
    SELECT
        interest_id,
        ROUND(composition / index_value, 2) AS avg_composition,
        ROW_NUMBER() OVER(PARTITION BY month_year ORDER BY ROUND(composition / index_value, 2) DESC) AS rank,
        month_year
    FROM
        interest_metrics
)
SELECT
    interest_id,
    avg_composition,
    FORMAT(month_year, 'MMM yyyy') AS month_year
FROM
    cte_rn rn
WHERE rank < 11 AND interest_id IS NOT NULL
ORDER BY month_year, rank
```

<div class="knitsql-table">

| interest\_id | avg\_composition | month\_year |
|:-------------|-----------------:|:------------|
| 6065         |             6.28 | Apr 2019    |
| 7541         |             6.21 | Apr 2019    |
| 5969         |             6.05 | Apr 2019    |
| 21245        |             6.02 | Apr 2019    |
| 18783        |             6.01 | Apr 2019    |
| 10981        |             5.65 | Apr 2019    |
| 19620        |             5.52 | Apr 2019    |
| 34           |             5.39 | Apr 2019    |
| 15878        |             5.30 | Apr 2019    |
| 13497        |             5.07 | Apr 2019    |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**D.2. For all of these top 10 interests - which interest appears the
most often?**

``` sql
WITH cte_rn AS(
    SELECT
        interest_id,
        ROUND(composition / index_value, 2) AS avg_composition,
        ROW_NUMBER() OVER(PARTITION BY month_year ORDER BY ROUND(composition / index_value, 2) DESC) AS rank,
        month_year
    FROM
        interest_metrics
)
SELECT
    interest_id,
    COUNT(interest_id) AS count
FROM
    cte_rn rn
WHERE rank < 11 AND interest_id IS NOT NULL
GROUP BY interest_id
ORDER BY count DESC
```

<div class="knitsql-table">

| interest\_id | count |
|:-------------|------:|
| 5969         |    10 |
| 6065         |    10 |
| 7541         |    10 |
| 18783        |     9 |
| 21245        |     9 |
| 10981        |     9 |
| 34           |     8 |
| 21057        |     8 |
| 10977        |     6 |
| 4898         |     5 |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**D.3 What is the average of the average composition for the top 10
interests for each month?**

``` sql
WITH cte_rn AS(
    SELECT
        interest_id,
        ROUND(composition / index_value, 2) AS avg_composition,
        ROW_NUMBER() OVER(PARTITION BY month_year ORDER BY ROUND(composition / index_value, 2) DESC) AS rank,
        month_year
    FROM
        interest_metrics
)
SELECT
    DISTINCT FORMAT(month_year, 'MMM yyyy') AS month_year,
    AVG(avg_composition) OVER(PARTITION BY month_year) AS avg_avg_comp
FROM
    cte_rn rn
WHERE rank < 11 AND interest_id IS NOT NULL
ORDER BY month_year DESC
```

<div class="knitsql-table">

| month\_year | avg\_avg\_comp |
|:------------|---------------:|
| Sep 2018    |          6.895 |
| Oct 2018    |          7.066 |
| Nov 2018    |          6.623 |
| May 2019    |          3.537 |
| Mar 2019    |          6.168 |
| Jun 2019    |          2.427 |
| Jul 2019    |          2.765 |
| Jul 2018    |          6.038 |
| Jan 2019    |          6.399 |
| Feb 2019    |          6.579 |

Displaying records 1 - 10

</div>

------------------------------------------------------------------------

**D.4 What is the 3 month rolling average of the max average composition
value from September 2018 to August 2019 and include the previous top
ranking interests in the same output shown below.**

``` sql
WITH cte_rn AS(
    SELECT
        interest_id,
        ROUND(composition / index_value, 2) AS avg_composition,
        ROW_NUMBER() OVER(PARTITION BY month_year ORDER BY ROUND(composition / index_value, 2) DESC) AS rank,
        month_year
    FROM
        interest_metrics
    WHERE month_year BETWEEN '2018-07-01' AND '2019-08-01'
),
cte_max AS(
    SELECT
        DISTINCT CAST(month_year AS DATE) AS month_year,
        MAX(avg_composition) OVER(PARTITION BY month_year) AS max_avg_comp
    FROM
        cte_rn rn
),
cte_lags AS(
    SELECT
        month_year,
        max_avg_comp,
        LAG(max_avg_comp, 1, 0) OVER (ORDER BY CAST(month_year AS DATE)) AS _1_month_ago,
        LAG(max_avg_comp, 2, 0) OVER (ORDER BY CAST(month_year AS DATE)) AS _2_months_ago
    FROM
        cte_max max
)
SELECT
    month_year,
    max_avg_comp,
    ROUND((max_avg_comp + _1_month_ago + _2_months_ago)/3,2) AS _3_month_moving_avg,
    _1_month_ago,
    _2_months_ago
FROM
    cte_lags lags
WHERE month_year >= '2018-09-01'
```

<div class="knitsql-table">

| month\_year | max\_avg\_comp | \_3\_month\_moving\_avg | \_1\_month\_ago | \_2\_months\_ago |
|:------------|---------------:|------------------------:|----------------:|-----------------:|
| 2018-09-01  |           8.26 |                    7.61 |            7.21 |             7.36 |
| 2018-10-01  |           9.14 |                    8.20 |            8.26 |             7.21 |
| 2018-11-01  |           8.28 |                    8.56 |            9.14 |             8.26 |
| 2018-12-01  |           8.31 |                    8.58 |            8.28 |             9.14 |
| 2019-01-01  |           7.66 |                    8.08 |            8.31 |             8.28 |
| 2019-02-01  |           7.66 |                    7.88 |            7.66 |             8.31 |
| 2019-03-01  |           6.54 |                    7.29 |            7.66 |             7.66 |
| 2019-04-01  |           6.28 |                    6.83 |            6.54 |             7.66 |
| 2019-05-01  |           4.41 |                    5.74 |            6.28 |             6.54 |
| 2019-06-01  |           2.77 |                    4.49 |            4.41 |             6.28 |

Displaying records 1 - 10

</div>

I dislike hardcoding the average but I didn’t find another solution
since the AVG() function doesn’t work across multiple columns. I have
yet to add interest\_name and concatenate it with the lagged values,
it’ll likely require 1-2 more CTEs to pull off.
