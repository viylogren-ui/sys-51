`Собираем контейнеры`

docker build -t mysql_master -f ./Dockerfile_master .
docker build -t mysql_slave -f ./Dockerfile_slave .

`Добавляем новую сеть`

docker network create replication

`Запускаем контейнеры:`

docker run --name mysql_master --net replication -p 3309:3306 mysql_master
docker run --name mysql_slave --net replication -p 3310:3306 mysql_slave

`Контейнеры между собой соединяются сетью replication благодаря ключу --net.`
`Для контейнеров проброшены разные внешние порты, чтобы можно было`
`подключиться внешним клиентом и проверить работу полученного кластера`

`Тестирование работы репликации`
`SQL запросы на master:`

```
DROP DATABASE IF EXISTS world; 
CREATE database world;
SHOW databases;
USE world;
CREATE TABLE city (
	name VARCHAR (50),
	CountryCode VARCHAR (50) UNIQUE,
	District VARCHAR (45),
	Population INT
	);
INSERT INTO city VALUES ('Test-Replication', 'ALB', 'Test', 42);
```
`SQL запросы на slave:`

```
SHOW DATABASES; -- должна отобразиться база данных world созданная на мастере
USE world;
SHOW tables; -- должна отобразиться таблица city созданная на мастере
SELECT * 
FROM city; -- получение данных добавленных на мастере
```