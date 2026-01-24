
-- ОПЕРАЦИИ С ДАННЫМИ
-- SELECT FROM

/*при отсутствии выборки с помощью оператора FROM команда SELECT работает 
по аналогии с echo-запросом в линукс */

SELECT '1+10';
SELECT (SELECT 10); -- вложенный запрос
SELECT * FROM (SELECT 1) AS a;

USE sakila; -- начинаем работать с БД sakila

SELECT * FROM actor; -- выбор всех записей из таблицы actor
SELECT first_name, last_name FROM actor; -- выбор колонок из таблицы
SELECT first_name AS 'имя', last_name AS 'фамилия' FROM actor; -- вывести результат как 'имя' 'фамилия'


-- ORDER BY - сортировка по имени и фамилии в обратном порядке DESC
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY first_name DESC , last_name DESC;


-- LIMIT - отобразить 10 первых записей
SELECT first_name, last_name
FROM actor
ORDER BY first_name
LIMIT 10;

-- LIMIT offset - пропустить 58 записей, отобразить за ними 10 записей
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY actor_id
LIMIT 10 offset 58; 

-- альтернатива комбинации LIMIT offset - результат тот же, что и в предыдущем запросе
SELECT actor_id, first_name, last_name
FROM actor
ORDER BY actor_id
LIMIT 58, 10; -- сначала показываем сколько строк пропустить, затем - сколько отобразить 

-- DISTINCT - получение уникальных значений
SELECT DISTINCT first_name -- уникальное значение имен (вывод 128 строк)
FROM actor;

SELECT DISTINCT first_name, last_name -- уникальное значение сочетания имени-фамилии (вывод 199 срок)
FROM actor;

-- WHERE - фильтрация полученных значений по условию
SELECT *
FROM actor
WHERE actor_id = 1; -- выбор только актера с id =1

SELECT *
FROM actor
WHERE actor_id <= 10; -- вывод строк, где actor_id <=10;

SELECT *
FROM payment
WHERE amount < 1; -- выбор платежей, где сумма платежа меньше 1

SELECT *
FROM payment
WHERE amount = 0 OR payment_date<'2005-08-01 18:00:00'
ORDER BY payment_date DESC ; -- вывод платежей с суммой ноль или датой платежа ранее чем 2005-08-01 18:00:00

SELECT *
FROM payment
WHERE amount>1 AND amount<3; -- вывод всех платежей, где сумма больше 1 и меньше 3

SELECT *
FROM payment
WHERE amount<1 OR amount>3; -- вывод всех платежей, где сумма меньше 1 или больше 3


-- BETWEEN - выбор значений в заданном диапазоне (фильтрация чисел и дат в заданных пределах)
SELECT *
FROM payment
WHERE amount BETWEEN 1 AND 3;
-- то же самое, тольк если >= и <= 
SELECT *
FROM payment
WHERE amount>=1 AND amount<=3;

-- CAST преобразование типов данных
SELECT payment_id, amount, payment_date
FROM payment;

SELECT -- изменение формата payment_date как DATA и вывод информации по столбу
	payment_id, 
	amount, 
	CAST(payment_date AS DATE) AS 'Дата'
FROM payment; 



-- ОПЕРАЦИИ С ЧИСЛАМИ

SELECT ROUND(100.576); -- 101 - округление
SELECT ROUND(100.576, 2); -- 100.58 - округление до заданного числа десятичных знаков
SELECT TRUNCATE(100.576, 2); -- 100.57 - усекает число до указанного числа десятичных знаков
SELECT FLOOR(100.576); -- 100 - округление до меньшего
SELECT CEIL(100.576); -- 101 - округление до большего
SELECT ABS(-100.576); -- 100.576 - абсолютное значение числа

-- АРИФМЕТИЧЕСКИЕ ОПЕРАЦИИ
SELECT POWER(2, 3); -- 8 - возведение в степень
SELECT SQRT(64); -- 8 - возвращение квадратного корня
SELECT 64 DIV 6; -- 10 - целочисленное деление
SELECT 64%6; -- 4 - остаток от деления
SELECT GREATEST(17, 5, 18, 21, 16); -- 21 возвращает наибольшее значение
SELECT LEAST(17, 5, 18, 21, 16); -- 5 - возвращает наименьшее значение
SELECT RAND(); -- 0.005757967015502944 - случайное число от 0 до 1
SELECT * FROM actor ORDER BY RAND(); -- вывод значений таблицы случайным образом


-- РАБОТА СО СТРОКАМИ
-- CONCAT, CONCAT_WS перечисление значений строк через разделители (соединение нескольких строк в одну)
SELECT CONCAT(first_name, '---', last_name, ';;;', email) FROM customer;
SELECT CONCAT_WS('--', last_name, first_name, email) FROM customer;
SELECT CONCAT('Пользователь: ', first_name, ' ', last_name) AS users FROM actor;
SELECT CONCAT_WS(' ', 'Пользователь: ', first_name, last_name) AS users FROM actor;

/* LENGTH подсчет количества байт 
   CHAR_LENGTH подсчет количества символов в строке */
SELECT
	first_name,
	LENGTH(first_name), -- длина строки в байтах
	CHAR_LENGTH(first_name) -- длина строки в символах
FROM actor;

SELECT 
	'Привет', 
	LENGTH('Привет') AS 'Количество байт',
	CHAR_LENGTH('Привет') AS 'Количество букв';

-- POSITION - возвращение позиции выбранных символов в строке
SELECT 
	first_name, 
	POSITION('D' IN first_name)
FROM actor;

-- SUBSTR - извлечение подстроки из строки
SELECT 
	first_name, 
	SUBSTR(first_name, 2, 3) -- вывести три символа, начиная со второго
FROM actor;

-- LEFT, RIGHT -  извлечение символов из строки, начиная слева/справа
SELECT last_name,
	LEFT(last_name, 3),
	RIGHT (last_name, 3)
FROM actor;

-- LOWER/UPPER - преобразование строк в нижний/верхний регистр
SELECT 
	first_name, 
	LOWER(first_name), 
	UPPER(first_name) 
FROM actor;

SELECT UPPER('Привет:-)');

-- INSERT - вставка подстроки в строку в указанной позиции и для определенного количества символов
SELECT
	last_name,
	INSERT(last_name, 1, 1, 'Пользователь: ')
FROM actor;

-- REPLACE - замена имеющихся подстрок на новую подстроку
SELECT first_name, REPLACE(first_name, 'A', 'XXXX')
FROM actor;

-- TRIM - удаление начальных и конечных пробелов из строки
SELECT '          IVANOV@MAIL.RU     ',
	TRIM('          IVANOV@MAIL.RU     ');

-- LIKE, NOT LIKE - возвращение true, если строка соответствует заданному шаблону
SELECT first_name 
FROM customer
WHERE first_name LIKE 'M%'; -- вывод строк, в которых имя начинается на "М"

SELECT first_name 
FROM customer
WHERE first_name LIKE '_EN%'; -- вывод строк, где вторая и третья буквы "EN"

SELECT first_name 
FROM customer
WHERE first_name LIKE '%EN%'; -- вывод строк, где в есть сочетание "EN"

SELECT first_name 
FROM customer
WHERE first_name LIKE '______'; -- вывод строк, где значения состоят из шести символов


-- РАБОТА С ДАТАМИ И ВРЕМЕНЕМ
SELECT NOW(); -- возврат текущей даты и времени
SELECT CURDATE(); -- возврат только текущей даты
SELECT CURRENT_TIMESTAMP(); -- возврат текущей даты и времени

SELECT NOW(), DATE_ADD(NOW(), INTERVAL 3 DAY); -- прибавление трех дней к текущей дате
SELECT NOW(), DATE_SUB(NOW(), INTERVAL 2 MONTH); -- удаление трех месяцев из текущей даты

SELECT NOW(), YEAR(NOW()) AS 'Y', MONTH(NOW()) 'M', WEEK(NOW()) 'W', DAY(NOW()) 'D',
		HOUR(NOW()), MINUTE(NOW()), SECOND(NOW()); -- раскладка даты и времени

SELECT NOW(), EXTRACT(HOUR FROM NOW()), HOUR(NOW()); -- извлечь час другим способом с помощью EXTRACT

SELECT DATE_FORMAT(payment_date, '%d-%a-%m-%Y') FROM payment; -- вывод даты в определенном формате
SELECT TIME_FORMAT(payment_date, '%H:%i:%s') FROM payment; -- вывод времени
SELECT NOW(), DATE_FORMAT(payment_date, '%d-%m-%Y %H:%i:%s') FROM payment; -- вывод даты в другом формате




-- HOMEWORK
-- Задание 1
SELECT DISTINCT district
FROM address
WHERE district LIKE 'K%a' AND district NOT LIKE '% %';

-- Задание 2
SELECT payment_date, amount
FROM payment
WHERE
	payment_date BETWEEN '2005-06-15' AND '2005-06-18'
	AND
	amount > 10.00
ORDER BY payment_date;

-- Задание 3
SELECT * 
FROM rental
ORDER BY rental_id DESC
LIMIT 5;

-- Задание 4
SELECT
	LOWER (REPLACE (first_name, 'LL', 'PP')),
	LOWER (last_name)	
FROM customer
WHERE first_name LIKE('Kelly') OR first_name LIKE('Willie')
ORDER BY first_name;

	
-- Задание 5*
SELECT email,
	SUBSTRING_INDEX(email, '@', 1) AS name_addr,
	SUBSTRING_INDEX(email, '@', -1) AS domain_name
FROM customer;


-- Задание 6*
SELECT email,
	-- SUBSTRING_INDEX(email, '@', 1) AS name_addr,
	-- SUBSTRING_INDEX(email, '@', -1) AS domain_name,
	CONCAT(UPPER(SUBSTRING(SUBSTRING_INDEX(email, '@', 1), 1, 1)), LOWER(SUBSTRING(SUBSTRING_INDEX(email, '@', 1), 2))) AS name_addr,
	CONCAT(UPPER(SUBSTRING(SUBSTRING_INDEX(email, '@', -1), 1, 1)), LOWER(SUBSTRING(SUBSTRING_INDEX(email, '@', -1), 2)))  AS domain_name
	FROM customer;