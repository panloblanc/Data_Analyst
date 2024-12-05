-- ----- Nivell 1

-- Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema 
-- d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les següents consultes:

-- - Exercici 1
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.

CREATE DATABASE Sprint4;

CREATE TABLE `users_all` (
  `id` int NOT NULL,
  `name` varchar(30) DEFAULT NULL,
  `surname` varchar(30) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `bith_date` varchar(40) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv' 
INTO TABLE users_all
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv' 
INTO TABLE users_all
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv' 
INTO TABLE users_all
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT * FROM users_all;

CREATE TABLE `companies` (
  `company_id` varchar(20) NOT NULL,
  `company_name` varchar(50) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `website` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv' 
INTO TABLE companies
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT * FROM companies;

CREATE TABLE `credit_cards` (
  `id` varchar(50) NOT NULL,
  `user_id` varchar(50) DEFAULT NULL,
  `iban` varchar(50) DEFAULT NULL,
  `pan` varchar(40) DEFAULT NULL,
  `pin` varchar(50) DEFAULT NULL,
  `cvv` varchar(50) DEFAULT NULL,
  `track1` varchar(50) DEFAULT NULL,
  `track2` varchar(50) DEFAULT NULL,
  `expiring_date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv' 
INTO TABLE credit_cards
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM credit_cards;

CREATE TABLE `products` (
  `id` varchar(15) NOT NULL,
  `product_name` varchar(50) DEFAULT NULL,
  `price` varchar(15) DEFAULT NULL,
  `colour` varchar(40) DEFAULT NULL,
  `weight` varchar(50) DEFAULT NULL,
  `warehouse_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv' 
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM credit_cards;

CREATE TABLE `transactions` (
  `id` varchar(255) NOT NULL,
  `card_id` varchar(15) DEFAULT NULL,
  `business_id` varchar(20) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `declined` tinyint(1) DEFAULT NULL,
  `product_ids` varchar(20) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `business_id` (`business_id`),
  KEY `card_id` (`card_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `companies` (`company_id`),
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`card_id`) REFERENCES `credit_cards` (`id`),
  CONSTRAINT `transaction_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users_all` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv' 
INTO TABLE transactions
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT name, surname, users_all.id, count(transactions.id) nTransaction FROM users_all
JOIN transactions ON users_all.id = transactions.user_id
GROUP BY users_all.name, users_all.surname, users_all.id
HAVING nTransaction > 30
ORDER BY nTransaction DESC;

-- - Exercici 2
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, 
-- utilitza almenys 2 taules.

SELECT credit_cards.iban, ROUND(avg(amount),2) avgSales FROM transactions
JOIN companies ON companies.company_id = transactions.business_id
JOIN credit_cards ON credit_cards.id = transactions.card_id
WHERE companies.company_name = 'Donec Ltd'
GROUP BY  credit_cards.iban;

-- ----- Nivell 2
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades i genera la següent consulta:

CREATE TABLE IF NOT EXISTS credit_card_state SELECT card_id,

	CASE WHEN card_id IN (SELECT card_id FROM (SELECT card_id, declined, count(*) nDeclined
												FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS n
													  FROM transactions) AS a1 WHERE n <= 3
													  GROUP BY card_id, declined
													  HAVING (declined=1 and nDeclined>2)) AS a2) THEN 0
                                                      
	WHEN card_id NOT IN (SELECT card_id FROM (SELECT card_id, declined, count(*) nDeclined
												FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS n
													  FROM transactions) AS b1 WHERE n <= 3
													  GROUP BY card_id, declined
													  HAVING (declined=1 and nDeclined>2)) AS b2) THEN 1
	END AS Card_Activity
    FROM transactions;

SELECT Card_Activity, count(*) FROM credit_card_state
GROUP BY Card_Activity
HAVING Card_Activity=0;


-- ----- Nivell 3
-- Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, tenint en compte que des de transaction tens product_ids. Genera la següent consulta:

CREATE TABLE numbers (
  n INT PRIMARY KEY);

INSERT INTO numbers VALUES (1),(2),(3),(4),(5),(6);

CREATE TABLE IF NOT EXISTS prodplustrans
SELECT * FROM (SELECT tr.id t_id, card_id, business_id, timestamp, amount, declined, SUBSTRING_INDEX(SUBSTRING_INDEX(tr.product_ids, ',',1), ',', -1) 
			   product_id, user_id, lat, longitude FROM numbers
               INNER JOIN transactions tr
               ON CHAR_LENGTH(tr.product_ids)
			   -CHAR_LENGTH(REPLACE(tr.product_ids, ',', ''))>=numbers.n-1
			   ORDER BY
				id, n) AS t 
		JOIN products 
		ON t.product_id = products.id;
ALTER TABLE prodplustrans DROP COLUMN id;
  
SELECT * FROM prodplustrans;
-- Exercici 1
-- Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

SELECT count(t_id) nSales ,product_id, product_name FROM prodplustrans
GROUP BY product_id, product_name
ORDER BY nSales DESC;

