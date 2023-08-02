# JOIN SENTENCE use sakila;

# 1)
CREATE
OR
REPLACE
    VIEW list_of_customer AS
SELECT
    cu.customer_id,
    CONCAT(
        cu.first_name,
        ' ',
        cu.last_name
    ) AS full_name,
    a.`address`,
    a.postal_code AS zip_code,
    a.phone,
    city.city,
    country.country,
    if(cu.active, 'active', '') AS `status`,
    cu.store_id
FROM customer cu
    JOIN `address` a USING(address_id)
    JOIN city USING(city_id)
    JOIN country USING(country_id);

SELECT * FROM list_of_customer;

# 2)
CREATE
OR
REPLACE VIEW film_details AS
SELECT
    f.film_id,
    f.title,
    f.description,
    ca.name AS category,
    f.rental_rate AS price,
    f.length,
    f.rating,
    group_concat(
        concat(
            ac.first_name,
            ' ',
            ac.last_name
        )
        ORDER BY
            ac.first_name SEPARATOR ', '
    ) as actors
FROM film f
    JOIN film_category USING(film_id)
    JOIN category ca USING(category_id)
    JOIN film_actor USING(film_id)
    JOIN actor ac USING(actor_id)
GROUP BY f.film_id, ca.name;

SELECT * FROM film_details;

# 3)
CREATE
OR
REPLACE
    VIEW sales_by_film_category AS
SELECT
    ca.name AS category,
    sum(pa.amount) AS total_sales
from payment pa
    JOIN rental USING(rental_id)
    JOIN inventory USING(inventory_id)
    JOIN film USING(film_id)
    JOIN film_category USING(film_id)
    JOIN category ca USING(category_id)
GROUP BY ca.`name`
ORDER BY total_sales;

SELECT * FROM sales_by_film_category;

# 4. Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
CREATE
OR REPLACEx VIEW actor_information AS
SELECT
    ac.actor_id as actor_id,
    ac.first_name as first_name,
    ac.last_name as last_name,
    COUNT(film_id) as films
FROM actor ac
    JOIN film_actor USING(actor_id)
GROUP BY
    ac.actor_id,
    ac.first_name,
    ac.last_name;

SELECT * FROM actor_information;

/*The query returns the following information for each actor / actress: a
 ) ID of the actor / actress b
 ) First name of the actor / actress c
 ) Last name of the actor / actress d
 ) A list of all the movies in which they have acted,
 organized in the following format: Category1: MOVIE1,
 Category2: MOVIE2,
 MOVIE3,
 Category3: MOVIE4,
 MOVIE5,
 MOVIE6 The categories
 and movies are sorted alphabetically.Here 's an example output:
 +----+------------+-----------+------------------------------------+
 | ID | first_name | last_name | film_info |
 +----+------------+-----------+------------------------------------+
 | 01 | Pepe | Martinez | Action: JUMANJI, Horror: ABRACADABRA, SLENDERMAN, THE RING, Sci-Fi: Interstellar, Star Wars: Clone Wars |
 +----+------------+-----------+------------------------------------+
 6. Materialized views, their purpose, usage, alternatives, and supporting DBMS:
 Materialized views are stored tables that contain data from other tables, obtained through queries, to provide convenient and practical access. They are created to allow easy and efficient access to a reduced set of data that is frequently needed. Materialized views are particularly useful when working with a subset of data repeatedly and require its storage to speed up queries and facilitate data retrieval.
 Materialized views are commonly used in databases with large amounts of data or when dealing with a frequently used subset of data in queries and other operations.
 Alternatives to materialized views include regular views and temporary tables. Regular views do not store the data physically but provide a virtual representation of data from underlying tables. Temporary tables are used for temporary storage and can be useful for specific use cases.
 Materialized views are supported in various database management systems (DBMS), including but not limited to PostgreSQL, Oracle, and SQL Server. Different DBMS may have varying levels of support and performance optimizations for materialized views.*/