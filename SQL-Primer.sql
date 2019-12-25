-- Let's say there are three SQL data sets named "user_details", "customers" and "items". 

-- SELECT
-- The most basic but important command. If you want to select the last_name column of the user_details table,

SELECT last_name FROM user_details / SELECT user_details.last_name FROM user_details

-- Unique selection
-- If you want to extract unique information of a column without duplicates, you can do:

SELECT distinct last_name FROM user_details

-- Sorting / Selecting specific number of entries(rows)
-- If you want to get user_id and gender information from only the first 5 rows
SELECT user_id, gender FROM user_details LIMIT 5

-- Getting first names ordered by alphabetical order
SELECT first_name FROM user_details ORDER BY first_name

-- Getting username and first names sorted by reverse-alphabetical order of last names
SELECT username, first_name FROM user_details ORDER BY last_name DESC

-- Filtering
-- Getting usernames whose gender is female
SELECT username FROM user_details WHERE gender='Female'

-- Getting usernames whose user id number is in between 25 and 30
SELECT username FROM user_details WHERE user_id BETWEEN 25 AND 30

-- Getting usernames whose user id number is less than 9 and whose gender is male at the same time
SELECT username FROM user_details WHERE user_id < 9 AND gender='Male'

-- Getting usernames whose user id number is equal to or greater than 10 or whose gender is male
SELECT username FROM user_details WHERE user_id >= 10 OR gender='Male'

-- Make sure when you use parenthesis appropriately when incorporating complex AND and OR statements into the query expression
SELECT username FROM user_details WHERE (user_id>=5 OR user_id < 3) AND gender='Male' 

-- Advanced Filtering with IN, LIKE and REGEX
-- Using 'IN' has the same effect as using multiple OR statements
SELECT * FROM `user_details` WHERE first_name IN ('Morgan','Mike','David') ORDER BY first_name

-- 'NOT IN' has the opposite effect of 'IN'
SELECT * FROM `user_details` WHERE first_name NOT IN ('Morgan','Mike','David') ORDER BY first_name

-- Getting user id, username and first names of users whose last name starts with letter 'b' (other letters after 'b' don't matter)
SELECT user_id, username, first_name FROM user_details WHERE last_name LIKE 'b%'

-- Getting user id, username and first names of users whose last name has the letter 'b' in the middle somewhere
SELECT user_id, username, first_name FROM user_details WHERE last_name LIKE '%b%'

-- Getting user id, username and first names of users whose last name starts with letter 'm' and ends with letter 'r'. For instance, users who have the last name 'miller' would be selected.
SELECT user_id, username, first_name FROM user_details WHERE last_name LIKE 'm%r'

-- Getting user id, username, first name and last names of users whose last name has the form '_iller' in which '_' is a placeholder for a single letter
SELECT user_id, username, first_name, last_name FROM user_details WHERE last_name LIKE '_iller'

-- Getting username and first names of users who has the word 'miller' in any of their last names
SELECT username, first_name FROM user_details WHERE last_name REGEXP 'Miller'

-- Getting usernames, first and last names of users who have the word 'miller' or 'rogers in any of their last names ('|' means OR in regular expressions)
SELECT username, first_name, last_name FROM user_details WHERE last_name REGEXP 'rogers|miller'

-- Getting username, first name and last names of users whose username has the form 'rogers__' but excluding rogers63 in particular. '__' in this case can be anything as long as the username starts with 'rogers'.
SELECT username, first_name, last_name FROM user_details WHERE username REGEXP 'rogers[^63]'

Creating custom columns
-- Creating a column that combines first name, last name and gender in a particular format. In this case, the new column would look something like this: josh kim, Male
SELECT CONCAT(first_name, ' ', last_name, ', ', gender) FROM user_details

-- Setting a name of the custom column
SELECT CONCAT(first_name, ' ', last_name, ', ', gender) AS new_user_info FROM user_details

Functions
-- Getting user id number and first name that has been capitalized
SELECT user_id, UPPER(first_name) FROM user_details

-- Getting counts of users whose last name is miller using the COUNT( ) function
SELECT COUNT(user_id) FROM user_details WHERE last_name = "miller"

-- Other functions include:
SORT( ) / AVG( ) / SUM( )

-- Using multiple functions! From the "items" table, if you want to get counts of items that were sold by the seller with id 106, maximum cost among those items and minimum cost among those items:
SELECT COUNT(cost) AS count,
MAX(cost),
MIN(cost),
FROM items WHERE seller_id= 106

-- Group By
-- Getting last name and counts (with column name as "count") of all the users grouped by their last names
SELECT last_name, COUNT(*) AS count FROM user_details GROUP BY last_name 

-- "HAVING" can be considered as the "WHERE" command for GROUP BYs
SELECT last_name, COUNT(*) AS count FROM user_details GROUP BY last_name HAVING COUNT(*)>=40 

-- We can combine GROUP BY, HAVING and ORDER BY
SELECT last_name, COUNT(*) AS count FROM user_details GROUP BY last_name HAVING COUNT(*)>=40 ORDER BY count DESC

-- Subqueries
-- Getting name and costs for items that are more expensive than the average cost of items sorted by descending numerical order of costs
SELECT name, cost FROM items WHERE cost> (
SELECT AVG(cost) FROM items
) ORDER BY cost DESC

-- Getting username and last names of users whose last name starts with letter 'c' and whose user id number matches with those whose last name ends with letter 'r'
SELECT username, last_name FROM user_details WHERE last_name LIKE 'c%' AND user_id IN(
    SELECT user_id FROM user_details WHERE last_name LIKE '%r'
    )

-- Merging Tables
-- Inner join of "customers" table and the "items" table on "id" and "seller_id" columns respectively (id information is the shared column between the two tables)
SELECT customers.id, customers.name, items.name items.cost
FROM customers,items
WHERE customers.id = seller_id
ORDER BY customers

-- Outer join of two tables (Outer joining "items" table onto "customers" table)
SELECT customers.name, items.name FROM customers LEFT OUTER JOIN 
items ON customers.id = seller_id

-- Giving tables nick names
SELECT i.seller_id, i.name, c.id
FROM customers AS c, items AS i
WHERE i.seller_id = c.id

-- Union
-- Basically has the same effect as an AND statement but when queries become more convoluted, using UNION command can be very useful
SELECT user_id, username FROM user_details WHERE last_name = 'miller'
UNION
SELECT user_id, username FROM user_details WHERE last_name = 'john'

-- More complicated UNION Query

WITH sales as (
  SELECT 'sale' as type
  FROM sale_transactions
WHERE day >= '2017-09-01'),
buys as (
  SELECT 'buy' as type
  FROM buy_transactions
WHERE day >= '2017-09-01'),
unioned as (
  SELECT type
  FROM buys
  UNION ALL
  SELECT type
FROM sales) 
SELECT type, count(1) as num_transactions
FROM unioned
GROUP BY type;

-- Full Text Search
-- Has to first designate a column to be a full text (Setting "last_name" column as full text)
ALTER TABLE user_details ADD FULLTEXT(last_name)

-- Getting last name and usernames of users whose last name has the word miller in it
SELECT last_name, username FROM user_details WHERE Match(last_name) Against('miller')

-- Getting last name and usernames of users whose last name has miller but doesn't have john in it
SELECT last_name, username FROM user_details WHERE Match(last_name) Against('+miller -john' IN BOOLEAN MODE)

-- Creating a new table
-- Datatypes: TEXT, varchar, NUMERIC, REAL, NONE

-- Creating a new table named "students" with column names listed as "id"(integer), "firstname"(string with maximum 30 characters), "lastname"(string with max 20 characters). Also setting the primary key to be the "id" column.
CREATE TABLE students(
id int,
firstname varchar(30),
lastname varchar(20),
PRIMARY KEY(id)
)

-- Creating a new table named "bacon". But specifying that the "id" column can't be null and automatically increases by one every time a new data is inserted. If a new entry in which the "id" column is null, an error message will appear.
CREATE TABLE bacon(
id int NOT NULL AUTO_INCREMENT,
username varchar(30) NOT NULL,
password varchar(30) NOT NULL,
PRIMARY KEY(id)
)

-- CREATE TABLE groceries (id INTEGER PRIMARY KEY, name TEXT, quantity INTEGER);
INSERT INTO groceries VALUES (1, “Bananas”, 4);
INSERT INTO groceries VALUES (2, “Peanut Butter”, 1);

-- Inserting data
-- Inserting one entry of data into the table
INSERT INTO user_details VALUES(1001,'juemrdl','josh','kim','Male','efker3fkdf93dfl24jdf','1')

-- Inserting multiple entries of data into the table
INSERT INTO user_details(user_id, username, first_name, last_name, gender, password, status)
VALUES
(1003,'ang','elise','joan','Female','erjflefa3','1'),
(1004,'hang','jack','back','Male','23rjfd32jsdfa','1'),
(1005,'swat','colette','heit','Female','3234jaf32k','1')

-- Inserting data that has been selected from another table into the current table
INSERT INTO items(id, name, cost, seller_id, bids) SELECT
id, name, cost,seller_id, bids FROM faketable WHERE cost < 10

-- Updating / Deleting data
-- In the "items" table, replacing the current information in the "name" column where the id number is 106 with the word "frog paste"
UPDATE items SET name="frog paste", bids=66 WHERE id=106

-- Delete the row where the id number is 104
DELETE FROM items WHERE id=104

-- Add / Drop columns
-- Adding a new column named "new_col" in which strings with max 10 characters can be stored
ALTER TABLE bacon ADD new_col varchar(10)

-- Dropping(removing) the column named "new_col" from the "bacon" table
ALTER TABLE bacon DROP COLUMN new_col

-- Renaming tables
RENAME TABLE customers TO users

-- Creating views
-- Similar to storing a portion of a dataframe into a global variable in objected oriented programming languages
CREATE VIEW mostbids AS
SELECT id, name, bids FROM items BY bids DESC LIMIT 10

-- Window Functions (e.g. RANK, FIRST_VALUE, LAG)

-- Imagine you have a table with some line items that report revenue along with the U.S state it came from. 
-- Your task is to determine the percent of revenue each line item contributed to its state’s total revenue. 
-- The window function is specified by the OVER clause. By summing revenue partitioned by state you get an aggregated value 
-- for each state associated with each individual line item. This makes getting that percent contribution number you care about 
-- a matter of simple division.

WITH state_totals as (
  SELECT state, revenue, 
    SUM(revenue) OVER (PARTITION BY state) as state_revenue
  FROM state_line_items)SELECT state, 
  revenue/state_revenue as percent_of_state_revenue
FROM state_totals;

