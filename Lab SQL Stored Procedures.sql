USE sakila;

-- First exercise

DELIMITER //

CREATE PROCEDURE GetCustomersByCategory(IN category_name VARCHAR(50))
BEGIN
    SELECT DISTINCT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = category_name;
END //

DELIMITER ;

CALL GetCustomersByCategory('Comedy');

-- Second exercise
DROP PROCEDURE IF EXISTS GetCustomersByCategory_2;

DELIMITER //

CREATE PROCEDURE GetCustomersByCategory_2(IN category_name VARCHAR(50))
BEGIN
    IF EXISTS (SELECT 1 FROM category WHERE name = category_name) THEN
        SELECT DISTINCT first_name, last_name, email
        FROM customer
        JOIN rental ON customer.customer_id = rental.customer_id
        JOIN inventory ON rental.inventory_id = inventory.inventory_id
        JOIN film ON film.film_id = inventory.film_id
        JOIN film_category ON film_category.film_id = film.film_id
        JOIN category ON category.category_id = film_category.category_id
        WHERE category.name = category_name;
    ELSE
        SELECT 'Category not found' AS message;
    END IF;
END //

DELIMITER ;

CALL GetCustomersByCategory_2('drama');

-- Third exercise
DROP PROCEDURE IF EXISTS CheckNumberOfMoviesByCategory;

DELIMITER //

CREATE PROCEDURE CheckNumberOfMoviesByCategory(IN category_name VARCHAR(50))
BEGIN
    IF EXISTS (SELECT 1 FROM category WHERE name = category_name) THEN
        SELECT category.name AS category, COUNT(film.film_id) AS movie_count
        FROM film 
        JOIN film_category ON film_category.film_id = film.film_id
        JOIN category ON category.category_id = film_category.category_id
        WHERE category.name = category_name
        GROUP BY category.name;
    ELSE
        SELECT 'Category not found' AS message;
    END IF;
END //

DELIMITER ;

CALL CheckNumberOfMoviesByCategory('comedy');


DELIMITER //

CREATE PROCEDURE CountMoviesGreaterEntry(IN number INT)
BEGIN
        SELECT category.name AS category, COUNT(film.film_id) AS movie_count
        FROM film 
        JOIN film_category ON film_category.film_id = film.film_id
        JOIN category ON category.category_id = film_category.category_id
        GROUP BY category.name
        HAVING COUNT(film.film_id) >= number;
END //

DELIMITER ;

CALL CountMoviesGreaterEntry(70);


