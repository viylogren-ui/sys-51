# Домашнее задание к занятию "`Индексы`" - `Ренёв Виталий`


### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

### Решение 1

```
SELECT ROUND (SUM(INDEX_LENGTH) / SUM(DATA_LENGTH) * 100, 2) FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'sakila'
```


![1.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_index/img/1.png)



### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.


### Решение 2

`Для оптимизации запроса целесообразно выполнить следующие мероприятия:`

1. `Заменить DISTINCT И SUM(p.amount) over (partition by c.customer_id, f.title) на GROUP BY`
2. `Использовать JOIN`
3. `Отказаться от функции DATE()`
4. `Для ускорени можно добавить индекс: INDEX(payment_data) в таблице payment`

`Код можно преобразовать в следующий вид`

```
EXPLAIN ANALYZE
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
```
`Результат исходного запроса`
![2.1.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_index/img/2.1.png)


`Результат запроса после оптмизации кода`
![2.2.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_index/img/2.2.png)


![2.2.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_index/img/2.2.png)

### Задание 3*

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

### Решение 3*

GiST, SP-GiST, GIN, BRIN, R-Tree