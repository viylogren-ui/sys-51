-- 1. INNER JOINV - объединение строк из двух таблиц
-- Пример: вывести названия фильмов и имена актеров, которые снимались в этих фильмах

-- решение НЕТОЛОГИИ
SELECT f.title, CONCAT(a.last_name, ' ', a.first_name) AS
actor_name
FROM film f
INNER JOIN film_actor fa ON fa.film_id = f.film_id
INNER JOIN actor a ON a.actor_id = fa.actor_id;

SELECT film.title, actor.first_name
FROM film
INNER JOIN film_actor ON film_actor.film_id = film.film_id
INNER JOIN actor ON actor.actor_id = film_actor.actor_id;

/*2. LEFT JOIN - возвращение всех данных из левой таблицы
если по ним есть совпадения в правой, то они обогащаются соответствующими данными
иначе туда записываются значения NULL*/

-- Пример: Вывести информацию по ВСЕМ пользователям и городам, в которых они живут
SELECT cu.first_name, cu.last_name, ci.city
FROM customer cu
LEFT JOIN address a ON cu.address_id = a.address_id
LEFT JOIN city ci ON a.city_id = ci.city_id;

-- решение НЕТОЛОГИИ
SELECT CONCAT(c.last_name, ' ', c.first_name), c2.city
FROM customer c
LEFT JOIN address a ON a.address_id = c.address_id
LEFT JOIN city c2 ON c2.city_id = a.city_id;

-- LEFT JOIN...WHERE За счет условия, берем только левую часть без части правой
-- Пример2: Получить ВСЕ фильмы, которые не брали в аренду
SELECT f.title, r.rental_id 
FROM film f
LEFT JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IS NULL;


/* 3. RIGHT JOIN - обратная версия LEFT JOIN. 
Запрос возвращает все данные из правой таблицы. Если по данным есть совпадения
в левой таблице, они обогащаются этими даннымы.*/

-- Пример: Вывести список всех городов и добавить информацию по пользователям, живущим в этих городах.

SELECT ci.city, c.first_name, c.last_name
FROM customer c
RIGHT JOIN address a ON a.address_id = c.address_id
RIGHT JOIN city ci ON ci.city_id = a.city_id;

-- решение НЕТОЛОГИИ
SELECT CONCAT(c.last_name, ' ', c.first_name), c2.city
FROM customer c
RIGHT JOIN address a ON a.address_id = c.address_id
RIGHT JOIN city c2 ON c2.city_id = a.city_id;

-- решение этой же задачи через LEFT JOIN
SELECT c.city, CONCAT(cu.first_name, ' ', cu.last_name) AS customers_names
FROM city c
LEFT JOIN address a ON a.city_id = c.city_id
LEFT JOIN customer cu ON cu.address_id = a.address_id;

/*4. FULL JOIN - вывод сопоставления по всем строкам в обеих таблицах,
 то есть получение ВСЕХ данных из левой и правой таблиц. Где сопоставлений нет
 добавляется значение NULL
 В MYSQL ТАКОЙ ЗАПРОС ДЕЛАЕТСЯ ЗА СЧЕТ LEFT JOIN, RIGHT JOIN, ОБЪЕДИНЕННЫХ UNION
 **/

-- Пример: Получить данные по ВСЕМ арендам и по ВСЕМ платежам

SELECT r.*, p.*
FROM rental r
LEFT JOIN payment p ON p.rental_id = r.rental_id
UNION
SELECT r.*, p.*
FROM rental r
RIGHT JOIN payment p ON p.rental_id = r.rental_id;

-- решение НЕТОЛОГИИ
SELECT r.rental_id, r.rental_date, p.customer_id, p.payment_date, p.amount
FROM rental r
LEFT JOIN payment p ON p.rental_id = r.rental_id
UNION
SELECT r.rental_id, r.rental_date, p.customer_id, p.payment_date, p.amount
FROM rental r
RIGHT JOIN payment p ON p.rental_id = r.rental_id;

/*CROSS JOIN - Декартово произведение - связь, при которой каждая запись из первой таблицы
 комбинируется с каждой записью из второй. */

SELECT COUNT(*)
FROM film; -- 1000

SELECT COUNT(*)
FROM actor; -- 200

-- Пример: сколько связей возможно между таблицами film, actor
SELECT COUNT(*)
FROM film
CROSS JOIN actor; -- 200 000

-- Пример и решение НЕТОЛОГИИ: необходимо получить всевозможные пары городов и убрать
-- зеркальные варианты А-Б, Б-А.

SELECT c.city, c2.city
FROM city c
CROSS JOIN city c2 -- 360 000
WHERE c.city > c2.city; -- 179 699

-- тот же результат
SELECT c.city, c2.city
FROM city c, city c2 -- 360 000
WHERE c.city > c2.city; -- 179 699


--     -------------------------------------------------------------------------------

-- UNION/EXCEPT
/*При работе с JOIN соединение данных из таблиц происходит "слева" или "справа".
  При работе с UNION/EXCEPT соединение информации просходит "сверху" и "снизу"
  ПРИМЕЧАНИЕ: Обязательное условие - количество столбцов и их типы данных в таблицах
  сверху и снизу должны быть одинаковыми*/

-- Создадим две таблицы:
DROP TABLE IF EXISTS table_1;
CREATE TABLE table_1 (
	color_1 VARCHAR(10) NOT NULL
);
DROP TABLE IF EXISTS table_2;
CREATE TABLE table_2 (
	color_2 VARCHAR(10) NOT NULL
);

INSERT INTO table_1
VALUES ('white'), ('black'), ('red'), ('green');

INSERT INTO table_2
VALUES ('black'), ('yallow'), ('blue'), ('red'), ('purple');

-- UNION - получение списка уникальных значений из первой и второй таблиц
SELECT color_1 
FROM `table_1` 
UNION 
SELECT color_2
FROM `table_2`;

-- UNION ALL - получение ВСЕХ значений из двух таблиц
SELECT color_1
FROM table_1
UNION ALL
SELECT color_2
FROM table_2;


/* -- EXCEPT - из значений, полученных в верхней части запроса
 вычитаются значения, которые совпали в ничжней части запроса.
 В MySQL такой запрос не поддерживается и реализуется с помощью
 оператора NOT IN */

SELECT color_1
FROM table_1
WHERE 
color_1 NOT IN (
SELECT color_2
FROM table_2
);


/*АГРЕГАТНЫЕ ФУНКЦИИ - SUM, COUNT, AVG, MIN, MAX*/

-- Пример1: отобразить сколько фильмов в базе начинается на букву "А"

-- Вариант 1:
SELECT * -- COUNT(1)
FROM film WHERE title LIKE 'A%';

-- Вариант 2 НЕТОЛОГИЯ:
SELECT COUNT(1)
FROM film
WHERE LOWER(LEFT(title, 1)) = 'a';


-- Пример2: В одном запросе отобразить по каждому пользователю информацию по количеству
-- платежей, общей сумме платежей, среднему платежу, максимальному и минимальному платежу

SELECT customer_id,
	COUNT(amount),
	SUM(amount),
	AVG(amount),
	MAX(amount),
	MIN(amount)
FROM payment
GROUP BY customer_id;

-- мое решение через INNER JOIN, чтобы показать имена фамилии, а не только customer_id
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customers_names,
	COUNT(amount), 
	SUM(amount),
	AVG(amount),
	MAX(amount),
	MIN(amount)
FROM payment p
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN customer c ON r.customer_id = c.customer_id
GROUP BY customers_names;


/*GROUP BY - группировка данных*/

-- Пример: В одном запросе получить информацию по количеству платежей и общей сумме платежей
-- по каждому пользователю на каждый месяц

-- решение НЕТОЛОГИИ
 SELECT customer_id, 
 	MONTH(payment_date),
 	COUNT(amount),
	SUM(amount)
 FROM payment
 GROUP BY customer_id, MONTH(payment_date);
 
-- мое решение с ипользованием INNER JOIN
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customers_names,
 	MONTH(payment_date),
	COUNT(amount), 
	SUM(amount)
FROM payment p
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN customer c ON r.customer_id = c.customer_id
GROUP BY customers_names, MONTH(payment_date);
 
/*HAVING - фильтрация уже сгруппированных данных (т.е. аналогично WHERE, только после GROUP BY)
  Помним о логическом порядке инструкции SELECT*/

-- Пример: найти пользователей, которые совершили более 40 аренд

SELECT CONCAT(c.first_name, ' ', c.last_name) AS customers_names, COUNT(r.rental_id)
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(r.rental_id)>40;


/*Подзапросы - это SELECT, результаты которого используются в другом SELECT.*/

-- Пример: получить процентное отношение платежей по каждому месяцу к общей сумме платежей

SELECT MONTH(payment_date),
COUNT(payment_id) / (SELECT COUNT(1) FROM payment) * 100
FROM payment
GROUP BY MONTH(payment_date);

-- Пример2: Получить фильмы из категорий, начинающихся на букву С

-- мое решение
SELECT f.title, c.name
FROM film f 
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name LIKE 'C%'
ORDER BY f.title;

-- решение НЕТОЛОГИИ
SELECT f.title, c.name
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.category_id IN (
	SELECT category_id
	FROM category
	WHERE name LIKE 'C%')
ORDER BY f.title;


/*УСЛОВИЯ. Выражение CASE - в SQL - условное выражение - аналогичен if/else */

-- Пример: вывести клиентов по следующим критериям:
-- если пользователь купил более чен на 200 у.е., то он хороший клиент
-- если менее чем на 100 у.е. - то не очень хороший
-- в остальных случаеях - средний

SELECT customer_id, SUM(amount),
	CASE 
		WHEN SUM(amount) > 200 THEN 'Good customer'
		WHEN SUM(amount) < 100 THEN 'Bed customer'
		ELSE 'Average customer'
	END AS 'Good or Bad'	
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC;



/*ДОМАШНЕЕ ЗАДАНИЕ*/

-- Задание 1:

SELECT s.store_id, CONCAT(st.first_name, ' ',st.last_name) AS staff_name,
CONCAT(ci.city, ' ', a.address) AS address, COUNT(c.store_id) AS customers
FROM store s
INNER JOIN customer c ON c.store_id = s.store_id
INNER JOIN staff st ON st.staff_id = s.manager_staff_id
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci ON ci.city_id = a.city_id
GROUP BY c.store_id
HAVING COUNT(c.store_id) > 300





-- Задание 2:

-- SELECT COUNT(*), SUM(`length`), SUM(`length`)/COUNT(*), AVG(`length`)
SELECT 
       (SELECT COUNT(*) FROM film) AS all_films,
       FLOOR(AVG(`length`)) AS average_lenght, 
       COUNT(`length`) AS lenght_films_over_average_lenght -- COUNT(*), AVG(`length`)
FROM film
WHERE `length` > 
	(SELECT AVG(`length`)
	 FROM film);




-- Задание 3:
SELECT MONTH(p.payment_date), SUM(p.amount), COUNT(r.rental_id)
FROM payment p
INNER JOIN rental r ON r.rental_id = p.rental_id
GROUP BY MONTH(p.payment_date)
ORDER BY SUM(p.amount) DESC LIMIT 1; 


-- Задание 4*:

SELECT concat(st.first_name, ' ', st.last_name) AS seller,
COUNT(p.payment_id) AS quantity_of_sales,
	CASE 
		WHEN count(p.payment_id) > 8000 THEN 'Yes'
		ELSE 'No'
	END AS 'bonus'
FROM payment p 
INNER JOIN  staff st ON st.staff_id = p.staff_id 
GROUP BY p.staff_id;




-- Задание 5*:
SELECT f.title, r.rental_id
FROM film f
LEFT JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IS NULL; 





 
 
 
 





















