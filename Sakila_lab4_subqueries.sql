-- 1 : Déterminez le nombre de copies du film "Hunchback Impossible" qui existent dans le système d'inventaire.
select 
fm.title,
count(iv.film_id) as stock
from film fm
 left join inventory iv on fm.film_id = iv.film_id
where iv.film_id = (select fm.film_id from film fm where fm.title = 'Hunchback Impossible')
group by fm.title
;

-- 2 : Répertoriez tous les films dont la durée est plus longue que la durée moyenne de tous les films de la base de données Sakila.
select 
title,
length
from film fm
where length > (select avg(length) from film);

-- 3 : Use a subquery to display all actors who appear in the film "Alone Trip"
select
first_name,
last_name,
fact.film_id
from actor act
left join film_actor fact on act.actor_id = fact.actor_id
where fact.film_id = (select film_id from film where title = 'Alone Trip');

-- 4 : Identify all movies categorized as family films.
select 
title,
category_id
from film fm
left join film_category fcat on fcat.film_id = fm.film_id
where fcat.category_id= (select category_id from category where name = 'Family');

-- 5 : Retrieve the name and email of customers from Canada 
select
first_name,
last_name,
email,
ct.country_id
from customer cs
left join address ad on ad.address_id = cs.address_id
left join city ct on ct.city_id = ad.city_id
where ct.country_id = (select country_id from country where country = 'Canada');

-- 6 : Determine which films were starred by the most prolific actor in the Sakila database.
with nb_film_act as (
select
actor_id,
count(film_id) as nb_film
from film_actor
group by actor_id
) ,
max_nb_film AS (
    SELECT 
        MAX(nb_film) AS max_film_count
    FROM nb_film_act
),
best_actor AS (
    SELECT 
        actor_id
    FROM nb_film_act
    WHERE nb_film = (SELECT max_film_count FROM max_nb_film)
)
select 
ba.actor_id,
fm.title
from best_actor ba
left join film_actor fa on ba.actor_id = fa.actor_id
left join film fm on fm.film_id = fa.film_id
;

-- 7 Find the films rented by the most profitable customer in the Sakila database.
select film.title, customer.customer_id
from film
inner join inventory
	using(film_id)
inner join rental
	using(inventory_id)
inner join customer
	using(customer_id)
where customer.customer_id = (select customer.customer_id
								from payment
								inner join customer
									using(customer_id)
								group by customer.customer_id
								order by sum(payment.amount) desc
								limit 1)
                                ;



