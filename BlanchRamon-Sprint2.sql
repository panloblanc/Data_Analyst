# -------------------------------------------------------- NIVELL 1

#- Exercici 2 # Utilitzant JOIN realitzaràs les següents consultes:

#Llistat dels països que estan fent compres.
SELECT DISTINCT country from company
INNER JOIN transaction ON company.id = transaction.company_id
;

#Des de quants països es realitzen les compres.
SELECT count(aux.country) from (SELECT DISTINCT country from company
									INNER JOIN transaction ON company.id = transaction.company_id) aux
;

#Identifica la companyia amb la mitjana més gran de vendes.

SELECT company.company_name from (SELECT company_id, declined, avg(amount) from transaction
						GROUP BY company_id, declined
						HAVING declined=0
						ORDER BY avg(amount) DESC
						LIMIT 1) aux
JOIN company ON aux.company_id = company.id
;

# - Exercici 3 # Utilitzant només subconsultes (sense utilitzar JOIN):

#Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT id from transaction
WHERE transaction.company_id in (SELECT id from company
					 WHERE country='Germany')
;

# Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT company_name from company
WHERE id in (SELECT company_id from transaction
			WHERE amount > (SELECT avg(amount) from transaction)
            )
;

#Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT company_name DeleteCompany from company
WHERE id not in (SELECT DISTINCT company_id from transaction) 
# Totes les companyies a la taula company tenen transaccions realitzades
;

# -------------------------------------------------------- NIVELL 2

# Exercici 1
#Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
#Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT LEFT(timestamp, 10) Day, sum(amount) TotalSales from transaction
GROUP BY day
ORDER BY sum(amount) DESC
LIMIT 5;

#Exercici 2
# Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT country, avg(amount) FROM transaction
INNER JOIN company ON transaction.company_id=company.id
GROUP BY country
ORDER BY avg(amount) DESC
;

#Exercici 3
# En la teva empresa, es planteja un nou projecte per a llançar algunes
# campanyes publicitàries per a fer competència a la companyia "Non Institute". 
# Per a això, et demanen la llista de totes les transaccions realitzades per empreses 
# que estan situades en el mateix país que aquesta companyia.

# JOIN i SUBQUERYS
SELECT transaction.id, company.country country FROM transaction
JOIN company on transaction.company_id=company.id
HAVING country = (SELECT country FROM company
				  WHERE company_name='Non Institute')
;
# Només SUBQUERYS
SELECT id FROM transaction
WHERE company_id in (SELECT id FROM company
		WHERE country = (SELECT country from company
				 WHERE company_name="Non Institute"))
;

# -------------------------------------------- Nivell 3:

# Exercici 1
SELECT company_name, phone, country, timestamp, amount FROM transaction
JOIN company ON company.id = transaction.company_id
WHERE amount < 200 AND amount > 100 AND (LEFT(timestamp,10)='2021-04-10' OR LEFT(timestamp,10)='2021-07-20' OR LEFT(timestamp,10)='2022-03-30')
ORDER BY amount DESC;

# EXERCICI 2
SELECT company_name,count(transaction.id),
	CASE WHEN count(transaction.id) > 4 THEN 'Més de 4 transaccions'
	WHEN count(transaction.id) < 4 THEN 'Menys de 4 transaccions'
	END AS FourTrans
from transaction
JOIN company ON company.id = transaction.company_id
GROUP BY company_id
ORDER BY count(id) DESC;
