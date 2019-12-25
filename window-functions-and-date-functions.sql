-- Window Funtions (e.g. RANK, FIRST_VALUE, LAG, LAST_VALUE, SUM, MAX, MIN, AVG)

--Imagine you have a table with some line items that report revenue along with the U.S state it came from. Your task is to determine the percent of revenue each line item contributed to its state’s total revenue. The window function is specified by the OVER clause. By summing revenue partitioned by state you get an aggregated value for each state associated with each individual line item. This makes getting that percent contribution number you care about a matter of simple division.

with state_totals as (
  SELECT state, revenue, 
    SUM(revenue) OVER (PARTITION BY state) as state_revenue
  FROM state_line_items)SELECT state, 
  revenue/state_revenue as percent_of_state_revenue
FROM state_totals;

-- Calculating channel’s percentage of total pageviews

SELECT
date,
channelGrouping,
pageviews,
sum(pageviews) OVER w1 as total_pageviews,
pageviews / sum(pageviews) OVER w1 as pct_of_pageviews
FROM (
  SELECT
  date,
  channelGrouping,
  sum(totals.pageViews) as pageviews
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` 
  GROUP BY channelGrouping, date
)
WINDOW w1 as (PARTITION BY date)
ORDER BY pct_of_pageviews desc

-- Dates

-- https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#extract

-- Extract day, week number, and formatted date from raw date information

SELECT
date_value,
EXTRACT(DAY from date_value) as day,
EXTRACT(WEEK from date_value) as day_of_week,
FORMAT_DATE("%Y-%m", date_value) AS yyyymm
FROM
(
  SELECT 
  PARSE_DATE('%Y%m%d', date) as date_value
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801` 
)
