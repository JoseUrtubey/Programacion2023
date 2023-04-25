--1. List all the actors that share the last name. Show them in order

SELECT first_name, last_name
FROM actor AS a1
WHERE EXISTS ( SELECT last_name FROM actor AS a2 WHERE  a1.last_name = a2.last_name and a1.actor_id != a2.actor_id)
ORDER BY last_name;

--2Find actors that don't work in any film

SELECT * FROM actor
WHERE actor_id NOT IN( SELECT DISTINCT actor_id FROM film_actor);

--3.Find customers that rented only one film

SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id FROM rental
    GROUP BY customer_id HAVING COUNT(*) > 1
);

--4.Find customers that rented more than one film

SELECT customer_id FROM customer AS c
WHERE EXISTS( SELECT rental.customer_id from rental WHERE c.customer_id = rental.customer_id)
ORDER BY customer_id;

--5.List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'

SELECT actor.first_name, actor.last_name
FROM actor AS a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor AS fa
    JOIN film ON fa.film_id = film.film_id
    WHERE film.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
);

--6.List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor AS fa
    JOIN film ON fa.film_id = film.film_id
    WHERE film.title = 'BETRAYED REAR'
) AND a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor
    JOIN film ON fa.film_id = film.film_id
    WHERE film.title = 'CATCH AMISTAD'
);

--7.List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor AS fa
    JOIN film ON fa.film_id = film.film_id
    WHERE film.title = 'BETRAYED REAR'
) AND a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor
    JOIN film ON fa.film_id = film.film_id
    WHERE film.title = 'CATCH AMISTAD'
);


--8.List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'

ELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor AS fa
    JOIN film ON fa.film_id = film.film_id
    WHERE film.title IN ('BETRAYED REAR', 'CATCH AMISTAD')
);
