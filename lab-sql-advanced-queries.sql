#  1:List each pair of actors that have worked together.
SELECT 
    fa1.actor_id AS actor1_id,
    fa2.actor_id AS actor2_id,
    COUNT(*) AS films_worked_together
FROM
    film_actor fa1
        JOIN
    film_actor fa2 ON fa1.film_id = fa2.film_id
        AND fa1.actor_id < fa2.actor_id
GROUP BY fa1.actor_id , fa2.actor_id
HAVING films_worked_together > 0
ORDER BY films_worked_together DESC;


#  2:For each film, list actor that has acted in more films.


SELECT
    fa.film_id,
    a.actor_id,
    a.first_name,
    a.last_name
FROM
    film_actor fa
JOIN
    actor a ON fa.actor_id = a.actor_id
JOIN (
    SELECT
        film_id,
        actor_id,
        COUNT(*) AS films_count
    FROM
        film_actor
    GROUP BY
        film_id, actor_id
    ) AS actor_film_count ON fa.film_id = actor_film_count.film_id
                      AND fa.actor_id = actor_film_count.actor_id
WHERE
    actor_film_count.films_count = (
        SELECT
            MAX(films_count)
        FROM
            (
                SELECT
                    film_id,
                    actor_id,
                    COUNT(*) AS films_count
                FROM
                    film_actor
                GROUP BY
                    film_id, actor_id
            ) AS max_films
        WHERE
            max_films.film_id = fa.film_id
    );
