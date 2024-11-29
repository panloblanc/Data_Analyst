----- % Nivell 1
----- - Exercici 1
-- La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre 
-- les targetes de crèdit. La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir 
-- una relació adequada amb les altres dues taules ("transaction" i "company"). Després de crear la taula serà 
-- necessari que ingressis la informació del document denominat "dades_introduir_credit". Recorda mostrar el 
-- diagrama i realitzar una breu descripció d'aquest.

CREATE DATABASE IF NOT EXISTS transactions;
USE transactions;

CREATE TABLE `company` (
  `id` varchar(15) NOT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

-- CREATE TABLE `user` (
--   `id` int NOT NULL,
--   `name` varchar(100) DEFAULT NULL,
--   `surname` varchar(100) DEFAULT NULL,
--   `phone` varchar(150) DEFAULT NULL,
--   `email` varchar(150) DEFAULT NULL,
--   `birth_date` varchar(100) DEFAULT NULL,
--   `country` varchar(150) DEFAULT NULL,
--   `city` varchar(150) DEFAULT NULL,
--   `postal_code` varchar(100) DEFAULT NULL,
--   `address` varchar(255) DEFAULT NULL,
--   PRIMARY KEY (`id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
-- ;

CREATE TABLE `credit_card` (
    id varchar(20) NOT NULL,
    iban varchar(50),
    pan varchar(20),
    pin varchar(4),
    cvv CHAR(3),
    expiring_date CHAR(8),
	PRIMARY KEY (`id`)
);

CREATE TABLE `transaction` (
  `id` varchar(255) NOT NULL,
  `credit_card_id` varchar(15) DEFAULT NULL,
  `company_id` varchar(20) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `declined` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `card_id` (`credit_card_id`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`),
  CONSTRAINT `transaction_ibfk_3` FOREIGN KEY (`credit_card_id`) REFERENCES `credit_card` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

----- - Exercici 2
-- El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. La 
-- informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi 
-- es va realitzar.

SELECT * FROM credit_card
WHERE id = 'CcU-2938';

UPDATE credit_card
SET iban = 'R323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT * FROM credit_card
WHERE id = 'CcU-2938';

----- - Exercici 3
-- En la taula "transaction" ingressa un nou usuari amb la següent informació:
-- Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
-- credit_card_id	CcU-9999
-- company_id	b-9999
-- user_id	9999
-- lat	829.999
-- longitude	-117.999
-- amount	111.11
-- declined	0

INSERT INTO credit_card (id)
VALUES ('CcU-9999'); 

INSERT INTO company (id)
VALUES ('b-9999'); 

INSERT INTO transaction (id,credit_card_id,company_id,user_id,lat,longitude,amount,declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999','9999','829.999','-117.999','111.11','0'); 

SELECT * FROM transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

----- - Exercici 4
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

alter table credit_card drop column pan;

SELECT * FROM credit_card
LIMIT 5;


----- --  % Nivell 2
----- Exercici 1
-- Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.

DELETE FROM transaction 
WHERE id='2C6201E-D90A-1859-B4EE-88D2986D3B02';

SELECT * FROM transaction WHERE id='2C6201E-D90A-1859-B4EE-88D2986D3B02';

-- ----- Exercici 2
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. Serà 
-- necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. 
-- Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. Presenta la vista creada, 
-- ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS
SELECT company_name, phone, country, ROUND(avg(amount),2) AvgSales FROM company
JOIN transaction ON transaction.company_id=company.id
WHERE declined=0 and company_name is not null
GROUP BY company.id
ORDER BY AvgSales DESC;

SELECT * FROM transactions.vistamarketing
;

-- ----- Exercici 3
-- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT * FROM vistamarketing
WHERE country='Germany';

-- ----- % Nivell 3
-- --- Exercici 1
-- La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar modificacions 
-- en la base de dades, però no recorda com les va realitzar. Et demana que l'ajudis a deixar els comandos executats per a obtenir 
-- el següent diagrama:

CREATE DATABASE IF NOT EXISTS transactions;
USE transactions;

CREATE TABLE `company` (
  `id` varchar(15) NOT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

CREATE TABLE `credit_card` (
  `id` varchar(20) NOT NULL,
  `iban` varchar(50) DEFAULT NULL,
  `pin` varchar(4) DEFAULT NULL,
  `cvv` char(3) DEFAULT NULL,
  `expiring_date` varchar(20) DEFAULT NULL,
  `fecha_actual` DATE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

CREATE TABLE `data_user` (
  `id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `phone` varchar(150) DEFAULT NULL,
  `personal_email` varchar(150) DEFAULT NULL,
  `birth_date` varchar(100) DEFAULT NULL,
  `country` varchar(150) DEFAULT NULL,
  `city` varchar(150) DEFAULT NULL,
  `postal_code` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

CREATE TABLE `transaction` (
  `id` varchar(255) NOT NULL,
  `credit_card_id` varchar(15) DEFAULT NULL,
  `company_id` varchar(20) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `declined` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id` (`company_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `card_id` (`credit_card_id`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`),
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `data_user` (`id`),
  CONSTRAINT `transaction_ibfk_3` FOREIGN KEY (`credit_card_id`) REFERENCES `credit_card` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
;

-- ----- Exercici 2
-- L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:

-- ID de la transacció
-- Nom de l'usuari/ària
-- Cognom de l'usuari/ària
-- IBAN de la targeta de crèdit usada.
-- Nom de la companyia de la transacció realitzada.
-- Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.

CREATE VIEW InformeTecnico AS 
SELECT transaction.id ID_Transaction, data_user.surname, credit_card.iban, company_name FROM transaction
JOIN company ON transaction.company_id=company.id
JOIN user ON data_user.id = transaction.user_id
JOIN credit_card ON credit_card.id= transaction.credit_card_id
ORDER BY ID_Transaction ASC;

SELECT * FROM transactions.InformeTecnico;