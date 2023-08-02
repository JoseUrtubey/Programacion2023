-- Active: 1686662840338@@127.0.0.1@3306
USE sakila;

select f.title 
from film as f
inner join film_actor as fa on fa.film_id=f.film_id
where (select count(fa.actor_id))
GROUP BY fa.actor_id;

--Obtener los pares de pagos realizados por el mismo cliente, considerar los clientes cuyo nombre comienza con alguna vocal. Mostrar el nombre del cliente y los 2 montos.

SELECT DISTINCT c.first_name, c.last_name, COUNT(p.customer_id)
FROM customer as c
INNER JOIN payment AS p ON p.customer_id=c.customer_id
WHERE (SELECT c.first_name LIKE "A%") 
GROUP BY p.customer_id;


SELECT f.LENGTH, f.title FROM film as f WHERE f.LENGTH not in
(SELECT f.LENGTH < MIN(f.LENGTH) AND f.LENGTH > MAX(f.LENGTH))
ORDER BY f.LENGTH ASC;


--Practice

--Get all the films that are not max or min length

SELECT title, length
FROM film as f1
WHERE EXISTS (
    SELECT * 
    FROM film as f2
    WHERE f2.length > f1.length
)
AND EXISTS( SELECT *
FROM film as f3
WHERE f3.length < f1.length
)
ORDER BY length ASC;


-- Get a list of the pair of payments done by the same customer, the customer's name has to start with a vocal, show the customers name and the 2 payments

SELECT c.first_name, p1.amount, p2.amount
FROM payment AS p1
JOIN payment AS p2 ON p1.customer_id=p2.customer_id
JOIN customer AS c ON c.customer_id=p1.customer_id
WHERE c.first_name LIKE "A%"
GROUP BY c.first_name, p1.amount, p2.amount
HAVING COUNT(*)=2;

--To get all the customer names that starts with a vowel you have to make a REGEXP that is like '^[AEIOU]'



--More Practice

--List All the actors that share the last name, show them in order

SELECT a1.first_name, a1.last_name
FROM actor as a1
WHERE a1.last_name IN ( SELECT a2.last_name
FROM actor as a2
WHERE a1.last_name=a2.last_name)
ORDER BY a1.last_name;


--Find actors that dont work in any film
SELECT a.first_name, a.last_name
FROM actor as a
WHERE a.actor_id NOT IN(
    SELECT f.title
    FROM film AS f
    JOIN film_actor as fa ON f.film_id=fa.film_id
    WHERE fa.actor_id = a.actor_id
);

--find customers that rented only one film


--list the actors that acted in "BETRAYED REAR" or in "CATCH AMISTAD"

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor AS fa
    JOIN film ON fa.film_id = film.film_id
    WHERE film.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
);

SELECT film_id(
    SELECT title 
    FROM film 
    WHERE film_id=fm.film_id
) AS title,
(SELECT GROUP_CONCAT((SELECT CONCAT(first_name,'', last_name)
FROM actor 
WHERE actor_id=fa2.actor_id) SEPARATOR ","
)FROM film_actor AS fa2 
WHERE fa2.film_id=fm.film_id) AS actors,
(
    SELECT COUNT(actor_id) 
    FROM film_actor 
    WHERE film_id=fm.film_id 
) AS cantidad
FROM film_actor AS fm 
GROUP BY fm.film_id
HAVING cantidad < (
    SELECT AVG(cantidad) 
    FROM (
        SELECT COUNT(actor_id) AS cantidad
        FROM film_actor +
    )
)





--Generar un informe que muestre la cantidad total recaudada por producto por categoria, el informe mostrara el nombre de la categoria, 
--nombre de producto y cantidad total recaudada en todas las ordenes. Solo mostrar los productos cuya cantidad total de productos 
--sea menor que la cantidad maxima vendida de todas las ordenes

SELECT CAT.CategoryName AS Categoria, PR.ProductName AS Producto, SUM(OD.Quantity * OD.UnitPrice) AS TotalRecaudado
FROM Categories AS CAT
    JOIN Products AS PR ON CAT.CategoryID = PR.CategoryID
    JOIN `Order Details` AS OD ON PR.ProductID = OD.ProductID
WHERE OD.Quantity < (
        SELECT MAX(Quantity)
        FROM `Order Details`
    )
GROUP BY
    CAT.CategoryName,
    PR.ProductName;

SELECT
    E1.EmployeeID AS JefeID,
    E1.FirstName AS JefeNombre,
    E1.LastName AS JefeApellido,
    (SELECT GROUP_CONCAT(E2.FirstName, ' ', E2.LastName)
     FROM Employees E2
     WHERE E2.ReportsTo = E1.EmployeeID) AS Empleados
FROM
    Employees E1
WHERE
    E1.ReportsTo IS NULL;

SELECT
    E1.EmployeeID AS JefeID,
    E1.FirstName AS JefeNombre,
    E1.LastName AS JefeApellido,
    GROUP_CONCAT(E2.FirstName, ' ', E2.LastName) AS Empleados
FROM
    Employees E1
    LEFT JOIN Employees E2 ON E1.EmployeeID = E2.ReportsTo
WHERE
    E1.ReportsTo IS NULL
GROUP BY
    E1.EmployeeID,
    E1.FirstName,
    E1.LastName;

SELECT
    E1.EmployeeID,
    E1.FirstName,
    E1.LastName,
    YEAR(CURDATE()) - YEAR(E1.BirthDate) - (RIGHT(CURDATE(), 5) < RIGHT(E1.BirthDate, 5)) AS Age
FROM
    Employees E1
WHERE
    E1.Title = 'Sales Representative'
    AND YEAR(CURDATE()) - YEAR(E1.BirthDate) - (RIGHT(CURDATE(), 5) < RIGHT(E1.BirthDate, 5)) >
    (
        SELECT MAX(YEAR(CURDATE()) - YEAR(E2.BirthDate) - (RIGHT(CURDATE(), 5) < RIGHT(E2.BirthDate, 5)))
        FROM Employees E2
        WHERE E2.Title = 'Sales Representative'
    )
    AND EXISTS (
        SELECT *
        FROM EmployeeTerritories ET
        JOIN Territories T ON ET.TerritoryID = T.TerritoryID
        WHERE ET.EmployeeID = E1.EmployeeID
        AND T.TerritoryDescription IN ('Seattle', 'Beachwood', 'Hollis', 'Denver')
    );