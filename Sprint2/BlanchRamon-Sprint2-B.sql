# -------------------------------------------------------- NIVELL 1

#- Exercici 2 # Utilitzant JOIN realitzaràs les següents consultes:

#Llistat dels països que estan fent compres.
SELECT DISTINCT country from company
INNER JOIN transaction ON company.id = transaction.company_id
ORDER BY country
;

#Des de quants països es realitzen les compres.
SELECT COUNT(DISTINCT company.country) FROM transaction
INNER JOIN company ON company.id = transaction.company_id;

#Identifica la companyia amb la mitjana més gran de vendes.

SELECT company.company_name from transaction
JOIN company ON transaction.company_id = company.id
GROUP BY company_id, declined
HAVING declined=0
ORDER BY avg(amount) DESC
LIMIT 1;

# - Exercici 3 # Utilitzant només subconsultes (sense utilitzar JOIN):

#Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT DISTINCT id transaction_id, company_id from transaction
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
WHERE NOT EXISTS (SELECT DISTINCT company_id from transaction) 
# Totes les companyies a la taula company tenen transaccions realitzades
;

# -------------------------------------------------------- NIVELL 2

# Exercici 1
#Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
#Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT DATE(timestamp) Day, sum(amount) TotalSales from transaction
WHERE declined=0
GROUP BY day
ORDER BY sum(amount) DESC
LIMIT 5;

#Exercici 2
# Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT ROUND(avg(amount),2) avgSales, country FROM transaction
INNER JOIN company ON transaction.company_id=company.id
where declined=0
GROUP BY country
ORDER BY avg(amount) DESC
;

#Exercici 3
# En la teva empresa, es planteja un nou projecte per a llançar algunes
# campanyes publicitàries per a fer competència a la companyia "Non Institute". 
# Per a això, et demanen la llista de totes les transaccions realitzades per empreses 
# que estan situades en el mateix país que aquesta companyia.

# JOIN i SUBQUERYS
SELECT DISTINCT transaction.id transaction_id, company_id, company.country country FROM transaction
JOIN company on transaction.company_id=company.id
HAVING country = (SELECT country FROM company
				  WHERE company_name='Non Institute')
;

# Només SUBQUERYS
SELECT DISTINCT transaction.id transaction_id, company_id FROM transaction
WHERE company_id in (SELECT id FROM company
		WHERE country = (SELECT country from company
				 WHERE company_name="Non Institute"))
;

# -------------------------------------------- Nivell 3:

# Exercici 1
SELECT company_name, phone, country, DATE(timestamp) Dia, amount FROM transaction
JOIN company ON company.id = transaction.company_id
WHERE declined=0 AND amount BETWEEN 100 AND 200 AND DATE(timestamp) IN ('2021-04-29','2021-07-20','2022-03-13')
ORDER BY amount DESC;

# EXERCICI 2
SELECT company_name,count(transaction.id) NumTrans,
	CASE WHEN count(transaction.id) > 4 THEN 'Més de 4 transaccions'
	WHEN count(transaction.id) < 4 THEN 'Menys de 4 transaccions'
	END AS TransaccioMesMenysde4
from transaction
JOIN company ON company.id = transaction.company_id
GROUP BY company_id
ORDER BY count(id) DESC;