-- ОТРАБОТКА КОНСПЕКТА

-- 1. EXPLAIN — демонстрирует этапы выполнения запроса и может быть использован для оптимизации.
-- EXPLAIN FORMAT = TRADITIONAL, JSON, TREE

EXPLAIN FORMAT = TREE
SELECT *
FROM customer c
JOIN address a ON a.address_id = c.address_id
JOIN city c2 ON c2.city_id = a.city_id
WHERE c2.city_id = 17;

/*
 * Резултат:
 * Можно посмотреть стоимость запроса cost=0.7 и количество проанализированных строк rows=1
 * Здесь ....
 -> Nested loop inner join  (cost=0.7 rows=1)
    -> Index lookup on a using idx_fk_city_id (city_id=17)  (cost=0.35 rows=1)
    -> Index lookup on c using idx_fk_address_id (address_id=a.address_id)  (cost=0.35 rows=1)
 */



/*-- EXPLAIN ANALYZE - более подробная информация выполнения запроса 
     EXPLAIN ANALYZE — производит EXPLAIN вывод вместе с синхронизацией и дополнительной,
основанной на итераторах, информацией о том, как ожидания оптимизатора совпадают с фактическим выполнением.
*/

EXPLAIN ANALYZE
SELECT *
FROM customer c
JOIN address a ON a.address_id = c.address_id
JOIN city c2 ON c2.city_id = a.city_id
WHERE c2.city_id = 17;

/*
 * Результат:
 * дополнительно получаем актуальное время выполнения запроса
 -> Nested loop inner join  (cost=0.7 rows=1) (actual time=0.025..0.028 rows=1 loops=1)
    -> Index lookup on a using idx_fk_city_id (city_id=17)  (cost=0.35 rows=1) (actual time=0.0124..0.0134 rows=1 loops=1)
    -> Index lookup on c using idx_fk_address_id (address_id=a.address_id)  (cost=0.35 rows=1) (actual time=0.0109..0.0126 rows=1 loops=1)
*/

-- ПРИМЕР 2:
EXPLAIN ANALYZE 
SELECT *
FROM customer
WHERE first_name = 'MARY'

/*
 * Cтоимость запроса cost=61.1 и количество проанализированных строк rows=599, сканирование типа "Table scan", т.к. есть индексы
 * > Filter: (customer.first_name = 'MARY')  (cost=61.1 rows=59.9) (actual time=0.0888..1.12 rows=1 loops=1)
    -> Table scan on customer  (cost=61.1 rows=599) (actual time=0.0859..0.941 rows=599 loops=1)
 * */

EXPLAIN ANALYZE 
SELECT *
FROM customer
WHERE last_name = 'SMITH';
/*
 * > Index lookup on customer using idx_last_name (last_name='SMITH')  (cost=0.35 rows=1) (actual time=0.0254..0.0277 rows=1 loops=1)
 * */

EXPLAIN ANALYZE 
SELECT *
FROM customer
WHERE last_name LIKE '%SMITH';

/*
 * > Filter: (customer.last_name like '%SMITH')  (cost=61.2 rows=66.5) (actual time=0.0607..0.936 rows=1 loops=1)
    -> Table scan on customer  (cost=61.2 rows=599) (actual time=0.0586..0.685 rows=599 loops=1)*/


/* 3. Индексы — инструмент, который позволяет оптимизировать выборку из базы данных,
значительно сокращая время на получение данных.*/

-- Создадим таблицу
DROP TABLE IF EXISTS  `film_temp`;
CREATE TABLE film_temp (
	film_id INT,
	title VARCHAR(50),
	description TEXT,
	language_id INT,
	release_year INT
);

-- Внесем в нее данные из таблицы film:
INSERT INTO film_temp
SELECT film_id, title, description, language_id, release_year
FROM film;

-- Проверим, что в таблице отсутствуют ограничения и индексы
SELECT *
FROM information_schema.STATISTICS
WHERE TABLE_NAME='film_temp'

-- Посмотрим на план запроса, где нужно получить фильм с id=100
EXPLAIN ANALYZE 
SELECT *
FROM film_temp
WHERE film_id = 100;
/*
  -> Filter: (film_temp.film_id = 100)  (cost=103 rows=100) (actual time=0.153..1.35 rows=1 loops=1)
    -> Table scan on film_temp  (cost=103 rows=1000) (actual time=0.0238..1.11 rows=1000 loops=1)
Для получения фильма с id=100 В СВЯЗИ С ОТСУТСТВИЕМ ИНДЕКСОВ и ОГРАНИЧЕНИЙ
потребовалось просканировать всю таблицу "Table scan on film_temp" проанализировать 
1000 строк (rows=1000), стоимость запроса составила cost=103 
**/

-- Добавим на столбец film_id ограничение PRIMARY KEY, которое в свою очередь включает индекс
ALTER TABLE film_temp ADD PRIMARY KEY (film_id);

-- Посмотрим на план запроса, где нужно получить фильм с id=100 еще раз
EXPLAIN ANALYZE 
SELECT *
FROM film_temp
WHERE film_id = 100;
/*
 * -> Rows fetched before execution  (cost=0..0 rows=1) (actual time=79e-6..139e-6 rows=1 loops=1)
Для получения фильма с id=100 В СВЯЗИ С НАЛИЧИЕМ ОГРАНИЧЕНИЯ ПЕРВИЧНОГО КЛЮЧА
соответствующую строку получаем сразу, стоимость запроса составила cost=0 
 **/ 




-- Написать запрос, который вернет процентное отношение общего размера всех индексов к общему размеру всех таблиц
-- TABLE_NAME - наименование таблицы, DATA_LENGTH - длина данных, INDEX_LENGTH - длина индексов
SELECT SUM(INDEX_LENGTH) / SUM(DATA_LENGTH+INDEX_LENGTH) * 100 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sakila'




-- Домашнее задание

-- Задание 1
-- Написать запрос, который вернет процентное отношение общего размера всех индексов к общему размеру всех таблиц
SELECT ROUND (SUM(INDEX_LENGTH) / (SUM(DATA_LENGTH)+SUM(INDEX_LENGTH)) * 100, 2) FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sakila';







-- Задание 2

-- EXPLAIN ANALYZE
SELECT DISTINCT CONCAT(c.last_name, ' ', c.first_name), SUM(p.amount) over (partition by c.customer_id, f.title)
FROM payment p, rental r, customer c, inventory i, film f
WHERE 
	DATE(p.payment_date) = '2005-07-30' AND 
	p.payment_date = r.rental_date AND 
	r.customer_id = c.customer_id AND 
	i.inventory_id = r.inventory_id;

/*
 -> Table scan on <temporary>  (cost=2.5..2.5 rows=0) (actual time=14497..14497 rows=391 loops=1)
    -> Temporary table with deduplication  (cost=0..0 rows=0) (actual time=14497..14497 rows=391 loops=1)
        -> Window aggregate with buffering: sum(payment.amount) OVER (PARTITION BY c.customer_id,f.title )   (actual time=5978..13989 rows=642000 loops=1)
            -> Sort: c.customer_id, f.title  (actual time=5978..6197 rows=642000 loops=1)
                -> Stream results  (cost=21.3e+6 rows=16e+6) (actual time=1.18..4445 rows=642000 loops=1)
                    -> Nested loop inner join  (cost=21.3e+6 rows=16e+6) (actual time=1.15..3539 rows=642000 loops=1)
                        -> Nested loop inner join  (cost=19.7e+6 rows=16e+6) (actual time=1.15..3045 rows=642000 loops=1)
                            -> Nested loop inner join  (cost=18.1e+6 rows=16e+6) (actual time=1.14..2501 rows=642000 loops=1)
                                -> Inner hash join (no condition)  (cost=1.54e+6 rows=15.4e+6) (actual time=1.12..143 rows=634000 loops=1)
                                    -> Filter: (cast(p.payment_date as date) = '2005-07-30')  (cost=1.61 rows=15400) (actual time=0.464..17.1 rows=634 loops=1)
                                        -> Table scan on p  (cost=1.61 rows=15400) (actual time=0.439..9.16 rows=16044 loops=1)
                                    -> Hash
                                        -> Covering index scan on f using idx_title  (cost=110 rows=1000) (actual time=0.0451..0.503 rows=1000 loops=1)
                                -> Covering index lookup on r using rental_date (rental_date=p.payment_date)  (cost=0.969 rows=1.04) (actual time=0.00239..0.00337 rows=1.01 loops=634000)
                            -> Single-row index lookup on c using PRIMARY (customer_id=r.customer_id)  (cost=250e-6 rows=1) (actual time=454e-6..501e-6 rows=1 loops=642000)
                        -> Single-row covering index lookup on i using PRIMARY (inventory_id=r.inventory_id)  (cost=250e-6 rows=1) (actual time=388e-6..437e-6 rows=1 loops=642000)

*/

-- Решение 2
/*
1. Заменить DISTINCT И SUM(p.amount) over (partition by c.customer_id, f.title) на GROUP BY
2. Использовать JOIN
3. Отказаться от функции DATE()
4. Для ускорени можно добавить индекс: INDEX(payment_data) в таблице payment

*/
-- EXPLAIN ANALYZE
SELECT 
	CONCAT(c.last_name, ' ', c.first_name) AS full_name,
	SUM(p.amount) AS total_amount_per_customer_per_film
FROM payment p
JOIN rental r ON p.payment_date = r.rental_date
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE 
	p.payment_date >= '2005-07-30' AND p.payment_date < '2005-07-31'
GROUP BY 
c.customer_id, full_name;





-- Решение 3:
GiST, SP-GiST, GIN, BRIN, R-Tree



