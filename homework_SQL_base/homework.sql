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





