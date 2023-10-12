create table if not exists products (
	product_id serial PRIMARY KEY,
	product_name VARCHAR ( 255 ) NOT NULL,
	price real 
);
create table if not exists  shops(
	shop_id serial ,
	shop_name VARCHAR ( 255 )PRIMARY KEY
);
create table if not exists plan (
	product_id int,
	shop_name VARCHAR ( 255 ) NOT NULL,
	plan_cnt int,
	plan_date date,
    FOREIGN KEY(product_id) REFERENCES products(product_id) ON DELETE CASCADE,
	FOREIGN KEY(shop_name) REFERENCES shops(shop_name) ON DELETE CASCADE 
);
create table if not exists  shop_dns(
	fact_date date,
	product_id int,
	sales_cnt int,
	FOREIGN KEY(product_id) REFERENCES products(product_id) ON DELETE CASCADE 
);
create table if not exists  shop_mvideo(
	fact_date date,
	product_id int,
	sales_cnt real,
	FOREIGN KEY(product_id) REFERENCES products(product_id) ON DELETE CASCADE 
);
create table if not exists  shop_sitilink(
	fact_date date,
	product_id int,
	sales_cnt real,
	FOREIGN KEY(product_id) REFERENCES products(product_id) ON DELETE CASCADE 
);
INSERT INTO products (product_name, price) 
VALUES 
('broken_phone', '100'),
('word_of_mouth', '1150'),
('gramophone', '3799');

INSERT INTO shops (shop_name) 
VALUES 
('shop_dns'), 
('shop_mvideo'), 
('shop_sitilink');

COPY plan (product_id,shop_name,plan_cnt, plan_date)
FROM '/docker-entrypoint-initdb.d/data/plan.csv'
DELIMITER ','
CSV HEADER;

COPY shop_dns (fact_date,product_id, sales_cnt)
FROM '/docker-entrypoint-initdb.d/data/shop_dns.csv'
DELIMITER ','
CSV HEADER;

COPY shop_mvideo (fact_date,product_id, sales_cnt)
FROM '/docker-entrypoint-initdb.d/data/shop_mvideo.csv'
DELIMITER ','
CSV HEADER;

COPY shop_sitilink (fact_date,product_id, sales_cnt)
FROM '/docker-entrypoint-initdb.d/data/shop_sitilink.csv'
DELIMITER ','
CSV HEADER;