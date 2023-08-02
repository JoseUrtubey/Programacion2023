use sakiladb
-- 1.   Show title and special_features of films that are PG-13

        SELECT title, special features FROM film 
        WHERE rating LIKE "PG-13";

-- 2.   Get a list of all the different films duration.

        SELECT DISTINCT length
        FROM film;


-- 3.   Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00

        SELECT title, rental_rate, replacement_cost FROM film
        WHERE replacement_cost BETWEEN 20.00 AND 24.00;

-- 4.   Show title, category and rating of films that have 'Behind the Scenes' as special_features

        SELECT film.title, category.name AS category, film.rating FROM film
        INNER JOIN film_category ON film.film_id = film_category.film_id
        INNER JOIN category ON film_category.category_id = category.category_id
        WHERE film.special_features LIKE '%Behind the Scenes%';
        

-- 5.   Show first name and last name of actors that acted in 'ZOOLANDER FICTION'

        SELECT actor.first_name, actor.last_name FROM actor
        INNER JOIN film_actor ON actor.actor_id = film.actor.actor_id
        INNER JOIN film ON film_actor.film_id = film.film_id
        WHERE title LIKE "ZOOLANDER FICTION";

-- 6.   Show the address, city and country of the store with id 1

        SELECT address.address, city.city, country.country FROM store
        INNER JOIN address ON store.address_id = address.address_id
        INNER JOIN city ON address.city_id = city.city_id
        INNER JOIN country ON city.country_id = country.country_id
        WHERE store.store_id = 1;


-- 7.   Show pair of film titles and rating of films that have the same rating.

        SELECT f1.title, f1.rating, f2.title, f2.rating FROM film f1
        INNER JOIN film f2 ON f1.film_id <> f2.film_id AND f1.rating = f2.rating
        ORDER BY f1.rating;


-- 8.   Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).

        SELECT film.title, staff.first_name, staff.last_name FROM inventory
        INNER JOIN store ON inventory.store_id = store.store_id
        INNER JOIN film ON inventory.film_id = film.film_id
        INNER JOIN store AS store_manager ON store.manager_staff_id = store_manager.staff_id
        INNER JOIN staff ON store_manager.manager_staff_id = staff.staff_id
        WHERE store.store_id = 2;

