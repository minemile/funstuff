USE URFU_MOBILE;

CREATE TABLE phone_type (ph_category CHAR(20) NOT NULL,
						ph_id INTEGER NOT NULL,
						ph_manufacturer CHAR(20) NOT NULL,
						ph_price FLOAT NOT NULL,
						CONSTRAINT prim_ph PRIMARY KEY(ph_id));

CREATE TABLE customer(cust_name CHAR(50) NOT NULL,
					  cust_surname CHAR(50) NOT NULL,
					  cust_balance FLOAT NULL,
					  vend_id INTEGER NOT NULL,
					  cust_id INTEGER NOT NULL,
					  ord_id INTEGER NOT NULL,
					  CONSTRAINT prim_cust PRIMARY KEY(cust_id),
					  CONSTRAINT foreign_ord FOREIGN KEY(ord_id) REFERENCES orders(ord_id),
					  CONSTRAINT foreign_vend FOREIGN KEY(vend_id) REFERENCES vendor(vend_id));

CREATE TABLE vendor(vend_name CHAR(50) NOT NULL,
					vend_surname CHAR(50) NOT NULL,
					vend_position CHAR(40) NOT NULL,
					vend_id INTEGER NOT NULL);

CREATE TABLE orders (ord_id INTEGER NOT NULL,
					  ord_address CHAR(20) NOT NULL,
					  ord_sum FLOAT NOT NULL DEFAULT 0,
					  ord_date DATETIME NOT NULL,
					  cust_id INTEGER NOT NULL,
					  vend_id INTEGER NOT NULL,
					  CONSTRAINT prim_id PRIMARY KEY(ord_id),
					  CONSTRAINT foreign_cust FOREIGN KEY(cust_id) REFERENCES customer(cust_id),
					  CONSTRAINT foreign_vend FOREIGN KEY(vend_id) REFERENCES vendor(vend_id));

CREATE TABLE phone (name CHAR(30) NOT NULL,
					color char(20) NOT NULL,
					ord_id INTEGER NOT NULL,
					ph_id INTEGER NOT NULL,
					id INTEGER NOT NULL,
					CONSTRAINT prim_id PRIMARY KEY(id),
					CONSTRAINT foreign_ph FOREIGN KEY(ph_id) REFERENCES phone_type(ph_id),
					CONSTRAINT foreign_ord FOREIGN KEY(ord_id) REFERENCES orders(ord_id)
					);

