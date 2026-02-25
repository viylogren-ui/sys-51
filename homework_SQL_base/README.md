# Домашнее задание к занятию "`Базы данных`" - `Ренёв Виталий`


### Легенда

Заказчик передал вам [файл в формате Excel](https://github.com/netology-code/sdb-homeworks/blob/main/resources/hw-12-1.xlsx), в котором сформирован отчёт. 

На основе этого отчёта нужно выполнить следующие задания.

### Задание 1

Опишите не менее семи таблиц, из которых состоит база данных. Определите:

- какие данные хранятся в этих таблицах,
- какой тип данных у столбцов в этих таблицах, если данные хранятся в PostgreSQL.

Начертите схему полученной модели данных. Можете использовать онлайн-редактор: https://app.diagrams.net/

Этапы реализации:
1.	Внимательно изучите предоставленный вам файл с данными и подумайте, как можно сгруппировать данные по смыслу.
2.	Разбейте исходный файл на несколько таблиц и определите список столбцов в каждой из них. 
3.	Для каждого столбца подберите подходящий тип данных из PostgreSQL. 
4.	Для каждой таблицы определите первичный ключ (PRIMARY KEY).
5.	Определите типы связей между таблицами. 
6.	Начертите схему модели данных.
На схеме должны быть чётко отображены:
   - все таблицы с их названиями,
   - все столбцы  с указанием типов данных,
   - первичные ключи (они должны быть явно выделены),
   - линии, показывающие связи между таблицами.

**Результатом выполнения задания** должен стать скриншот получившейся схемы базы данных.

### Решение 1

![1_shema.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_base/1_shema.png)

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению. Вы можете их выполнить, если хотите глубже и шире разобраться в материале.


### Задание 2*

1. Разверните СУБД Postgres на своей хостовой машине, на виртуальной машине или в контейнере docker.
2. Опишите схему, полученную в предыдущем задании, с помощью скрипта SQL.
3. Создайте в вашей полученной СУБД новую базу данных и выполните полученный ранее скрипт для создания вашей модели данных.

В качестве решения приложите SQL скрипт и скриншот диаграммы.

Для написания и редактирования sql удобно использовать  специальный инструмент dbeaver.

### Решение 2*

[homework.sql](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_base/homework.sql)

```
DROP DATABASE IF EXISTS shema_excel_db; 
CREATE DATABASE shema_excel_db;
USE shema_excel_db;

DROP TABLE IF EXISTS post;
CREATE TABLE post (
  id serial PRIMARY KEY,
  post_name varchar(100) NOT NULL,
  salery int DEFAULT NULL
);

DROP TABLE IF EXISTS unit_type;
CREATE TABLE unit_type (
  id int PRIMARY KEY,
  unit_type_name varchar(100) NOT NULL,
  post_id serial,
  FOREIGN KEY (post_id) REFERENCES post (id)
);

DROP TABLE IF EXISTS business_unit;
CREATE TABLE business_unit (
	id int PRIMARY KEY,
	unit_name varchar(100) NOT NULL,
	unit_type_id int NOT NULL,
	FOREIGN KEY (unit_type_id) REFERENCES unit_type (id)
);

DROP TABLE IF EXISTS emploee;
CREATE TABLE emploee (
	id int PRIMARY KEY,
	first_name varchar(100) NOT NULL,
	last_name varchar(100) NOT NULL,
	patronymic varchar(100) NOT NULL,
	date_of_hiring date
);

DROP TABLE IF EXISTS project;
CREATE TABLE project (
	id int PRIMARY KEY,
	name_of_project varchar(100) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS emploee_project;
CREATE TABLE emploee_project (
id_emploee int NOT NULL,
id_project int NOT NULL,
FOREIGN KEY (id_emploee) REFERENCES emploee (id),
FOREIGN KEY (id_project) REFERENCES project (id),
PRIMARY KEY (id_emploee, id_project)
);

DROP TABLE IF EXISTS filials;
CREATE TABLE filials (
	id int PRIMARY KEY,
	adress text,
	business_unit_id int NOT NULL,
	emploee_id int NOT NULL,
	FOREIGN KEY (business_unit_id) REFERENCES business_unit (id),
	FOREIGN KEY (emploee_id) REFERENCES emploee (id)
);
```

![2_ir_model.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_base/2_ir_model.png)
