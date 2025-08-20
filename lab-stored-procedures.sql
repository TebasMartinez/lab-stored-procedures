USE sakila;

# EXERCISE 1
# In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
# Convert the query into a simple stored procedure. Use the following query:
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  
DELIMITER //

CREATE PROCEDURE action_customers()
	begin
		SELECT first_name, last_name, email
		FROM customer
		JOIN rental USING(customer_id)
		JOIN inventory USING(inventory_id)
		JOIN film USING(film_id)
		JOIN film_category USING(film_id)
		JOIN category USING(category_id)
		WHERE category.name = "Action"
		GROUP BY first_name, last_name, email;
	end;
//

DELIMITER ;

call action_customers();

# EXERCISE 2
# Now keep working on the previous stored procedure to make it more dynamic. 
# Update the stored procedure in a such manner that it can take a string argument for the category name 
# and return the results for all customers that rented movie of that category/genre. 
# For eg., it could be action, animation, children, classics, etc.

DELIMITER //

CREATE PROCEDURE category_customers(in param1 char(25))
	begin
		SELECT first_name, last_name, email
		FROM customer
		JOIN rental USING(customer_id)
		JOIN inventory USING(inventory_id)
		JOIN film USING(film_id)
		JOIN film_category USING(film_id)
		JOIN category USING(category_id)
		WHERE category.name = param1
		GROUP BY first_name, last_name, email;
	end;
//

DELIMITER ;

SELECT name FROM category;

call category_customers("Animation");
call category_customers("Comedy");
call category_customers("Action");

# EXERCISE 3
# Write a query to check the number of movies released in each movie category. 
SELECT name, COUNT(film_id)
FROM category
INNER JOIN film_category USING(category_id)
GROUP BY name;

# Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
DELIMITER //

CREATE PROCEDURE filter_categories(in x int)
	begin
		SELECT name, COUNT(film_id) AS total_movies
		FROM category
		INNER JOIN film_category USING(category_id)
		GROUP BY name
        HAVING total_movies > x;
	end;
//

DELIMITER ;

# Pass that number as an argument in the stored procedure.
call filter_categories(60)