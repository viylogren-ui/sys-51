# Домашнее задание к занятию "`SQL. Часть 2`" - `Ренёв Виталий`


### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.

### Решение 1

```
SELECT s.store_id, CONCAT(st.first_name, ' ',st.last_name) AS staff_name,
CONCAT(ci.city, ' ', a.address) AS address, COUNT(c.store_id) AS customers
FROM store s
INNER JOIN customer c ON c.store_id = s.store_id
INNER JOIN staff st ON st.staff_id = s.manager_staff_id
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city ci ON ci.city_id = a.city_id
GROUP BY c.store_id
HAVING COUNT(c.store_id) > 300;
```

![1.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_2/img/1.png)

---

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

### Решение 2

```
SELECT 
       (SELECT COUNT(*) FROM film) AS all_films,
       FLOOR(AVG(`length`)) AS average_lenght, 
       COUNT(`length`) AS lenght_films_over_average_lenght
FROM film
WHERE `length` > 
	(SELECT AVG(`length`)
	 FROM film);
```

![2.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_2/img/2.png)

---


### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

### Решение 3

```
SELECT MONTH(p.payment_date), SUM(p.amount), COUNT(r.rental_id)
FROM payment p
INNER JOIN rental r ON r.rental_id = p.rental_id
GROUP BY MONTH(p.payment_date)
ORDER BY SUM(p.amount) DESC LIMIT 1;
```

![3.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_2/img/3.png)

---

### Задание 4*

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».

### Решение 4*

```
SELECT concat(st.first_name, ' ', st.last_name) AS seller,
COUNT(p.payment_id) AS quantity_of_sales,
	CASE 
		WHEN count(p.payment_id) > 8000 THEN 'Yes'
		ELSE 'No'
	END AS 'bonus'
FROM payment p 
INNER JOIN  staff st ON st.staff_id = p.staff_id 
GROUP BY p.staff_id;
```

![4.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_2/img/4.png)

---

### Задание 5*

Найдите фильмы, которые ни разу не брали в аренду.

### Решение 5*

```
SELECT f.title, r.rental_id
FROM film f
LEFT JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IS NULL;
```

![5.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_2/img/5.png)

---
