# Домашнее задание к занятию "`SQL. Часть 1`" - `Ренёв Виталий`

### Задание 1

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.

### Решение 1

```
SELECT DISTINCT district
FROM address
WHERE district LIKE 'K%a' AND district NOT LIKE '% %';

```
![1.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_1/img/1.png)

---

### Задание 2

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно** и стоимость которых превышает 10.00.

### Решение 2

```
SELECT payment_date, amount
FROM payment
WHERE
	payment_date BETWEEN '2005-06-15' AND '2005-06-18'
	AND
	amount > 10.00
ORDER BY payment_date;

```

![2.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_1/img/2.png)

---

### Задание 3

Получите последние пять аренд фильмов.

### Решение 3

```
SELECT * 
FROM rental
ORDER BY rental_id DESC
LIMIT 5;

```
![3.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_1/img/3.png)


### Задание 4

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'.

### Решение 4

```
SELECT
	LOWER (REPLACE (first_name, 'LL', 'PP')),
	LOWER (last_name)	
FROM customer
WHERE first_name LIKE('Kelly') OR first_name LIKE('Willie')
ORDER BY first_name;
```
![4.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_1/img/4.png)


### Задание 5*

Выведите Email каждого покупателя, разделив значение Email на две отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй — значение, указанное после @.

### Решение 5*

```
SELECT email,
	SUBSTRING_INDEX(email, '@', 1) AS name_addr,
	SUBSTRING_INDEX(email, '@', -1) AS domain_name
FROM customer;
```
![5.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_1/img/5.png)


### Задание 6*

Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные — строчными.

### Решение 6*

```
SELECT email,
	-- SUBSTRING_INDEX(email, '@', 1) AS name_addr,
	-- SUBSTRING_INDEX(email, '@', -1) AS domain_name,
	CONCAT(UPPER(SUBSTRING(SUBSTRING_INDEX(email, '@', 1), 1, 1)), LOWER(SUBSTRING(SUBSTRING_INDEX(email, '@', 1), 2))) AS name_addr,
	CONCAT(UPPER(SUBSTRING(SUBSTRING_INDEX(email, '@', -1), 1, 1)), LOWER(SUBSTRING(SUBSTRING_INDEX(email, '@', -1), 2)))  AS domain_name
FROM customer;
```
![6.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_part_1/img/6.png)
