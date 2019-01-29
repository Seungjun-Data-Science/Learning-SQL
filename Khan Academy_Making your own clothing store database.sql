-- Practice Making your own Store Database! (Khan Academy)
-- Create your own store! Your store should sell one type of things, 
-- like clothing or bikes, whatever you want your store to specialize in. 
-- You should have a table for all the items in your store, and at least 5 columns for the kind of data you think you'd need to store. 
-- You should sell at least 15 items, and use select statements to order your items by price and show at least one statistic about the 
-- items.

CREATE TABLE store (id INTEGER PRIMARY KEY, name TEXT,
target_gender TEXT, fabric TEXT, price NUMERIC);

INSERT INTO store VALUES (1, "hoodie", "MW", "Cotton", 20);
INSERT INTO store VALUES (2, "sweater", "M", "Wool", 30);
INSERT INTO store VALUES (3, "cap", "M", "polyester", 15);
INSERT INTO store VALUES (4, "T-Shirt", "MW", "Cotton", 10);
INSERT INTO store VALUES (5, "Underwear", "W", "wool",8);
INSERT INTO store VALUES (6, "Underwear", "M", "wool", 8);
INSERT INTO store VALUES (7, "Party Dress", "W", "silk", 23);
INSERT INTO store VALUES (8, "jean jacket", "MW", "jean", 25);
INSERT INTO store VALUES (9, "leather jacket", "MW", "leather", 18);
INSERT INTO store VALUES (10, "Suit", "M", "polyester", 50);
INSERT INTO store VALUES (11, "Winter Coat", "M", "Wool", 70);
INSERT INTO store VALUES (12, "Winter Coat", "W", "Wool", 70);
INSERT INTO store VALUES (13, "Slippers", "MW", "polyester",10);
INSERT INTO store VALUES (14, "Skirt", "W", "silk", 20);
INSERT INTO store VALUES (15, "Sneakers", "MW", "polyester", 22);

-- Buy items that are for men or for both men and women and are cheaper than 20 dollars
SELECT * FROM store WHERE (target_gender=='M' OR target_gender='MW') AND price < 20;

SELECT AVG(price) FROM store WHERE (target_gender=='M' OR target_gender='MW') AND price < 20;


