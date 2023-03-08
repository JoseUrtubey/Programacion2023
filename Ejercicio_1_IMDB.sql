CREATE DATABASE IMDB;
USE IMDB;
CREATE TABLE Film(
film_id INT PRIMARY KEY AUTO_INCREMENT, 
title VARCHAR(100), 
description VARCHAR(200), 
release_year DATE
);

CREATE TABLE Actor(
actor_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(100),
last_name VARCHAR(100)
);

CREATE TABLE Film_actor(
actor_id INT,
film_id INT,
CONSTRAINT FOREIGN KEY (actor_id) REFERENCES Actor(actor_id),
CONSTRAINT FOREIGN KEY (film_id) REFERENCES Film(film_id)
);

ALTER TABLE Film ADD last_update_film VARCHAR(200);
ALTER TABLE Actor ADD last_update_actor VARCHAR(200);

ALTER TABLE Film_actor ADD Foreign Key (film_id) REFERENCES Film(film_id);
ALTER TABLE Film_actor ADD Foreign Key (actor_id) REFERENCES Actor(actor_id);

INSERT INTO Film(title, description, release_year) VALUES("Titanic","Buena peli","2000-10-03");
INSERT INTO Actor(first_name,last_name) VALUES("Leo","Di Caprio");
INSERT INTO Film_actor(actor_id,film_id) VALUES(1,1);