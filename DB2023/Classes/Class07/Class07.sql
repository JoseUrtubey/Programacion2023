-- Active: 1686662840338@@127.0.0.1@3306@sakila
/*Activities
1-Find the films with less duration, show the title and rating.
2-Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
3-Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
4-Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.
*/
-- Activity 1:
SELECT title, rating, length
FROM film
WHERE length <= 
(SELECT MIN(length) FROM film);


--Activity 2:
SELECT title, rating, length
FROM film AS f1
WHERE length <= 
(SELECT MIN(length) FROM film)
  AND NOT EXISTS
  (SELECT * FROM film AS f2 WHERE f2.film_id <> f1.film_id AND f2.length <= f1.length);


--Activity 3:
SELECT first_name, last_name, a.address, MIN(p.amount) AS lowest_payment
FROM customer
         INNER JOIN payment as p ON customer.customer_id = p.customer_id
         INNER JOIN address a on customer.address_id = a.address_id
GROUP BY first_name, last_name, a.address;


--Activity 4:
SELECT first_name, last_name, a.address, MIN(p.amount) AS lowest_payment, MAX(p.amount) AS highest_payment
from customer
         INNER JOIN payment p on customer.customer_id = p.customer_id
         INNER JOIN address a on customer.address_id = a.address_id
GROUP BY first_name, last_name, a.address;