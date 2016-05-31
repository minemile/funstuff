use URFU_TASKS;

CREATE TABLE products(
 	id INT NOT NULL IDENTITY(1,2),
 	code CHAR(15) NOT NULL,
 	name VARCHAR(25) NOT NULL,
 	[description] NVARCHAR(1000) not null,
 	start_time SMALLDATETIME not null,
	CONSTRAINT prod_id PRIMARY KEY(id)
 );

CREATE TABLE shops(
	code CHAR(5) NOT NULL,
	name VARCHAR(50) NOT NULL UNIQUE,
	telephone VARCHAR(25),
	[address] NVARCHAR(500),
	CHECK(telephone not LIKE '%[^0-9*+() ]%'),
	CONSTRAINT prim_code PRIMARY KEY(code)
);

CREATE TABLE schedule(
	shops_code CHAR(5) NOT NULL,
	shops_week TINYINT NOT NULL CHECK(shops_week BETWEEN 1 AND 7),
	start_work_hour tinyint NOT NULL check(start_work_hour BETWEEN 0 AND 23),
 	start_work_minute tinyint NOT NULL check(start_work_minute BETWEEN 0 AND 59),
 	end_work_hour tinyint NOT NULL check(end_work_hour BETWEEN 0 AND 23),
 	end_work_minute tinyint NOT NULL check(end_work_minute BETWEEN 0 AND 59),
 	break_time BIT NOT NULL DEFAULT (0),
	CONSTRAINT prim_schedule PRIMARY KEY(shops_code, shops_week),
	CONSTRAINT prim_shops_code FOREIGN KEY(shops_code) REFERENCES shops(code),
);

CREATE TABLE register_buy(
	buy_id BIGINT NOT NULL IDENTITY(1,1),
	shops_code CHAR(5) NOT NULL,
	date_time DATETIME NOT NULL,
	prod_id INT NOT NULL,
	[count] SMALLINT NOT NULL,
	price SMALLMONEY NOT NULL,
	discount DECIMAL(4,2),
	custumer VARCHAR(100),
	CONSTRAINT buy_id PRIMARY KEY(buy_id),
	CONSTRAINT foreign_shop_code FOREIGN KEY(shops_code) REFERENCES shops(code),
	CONSTRAINT foreign_prod_id FOREIGN KEY(prod_id) REFERENCES products(id)
);