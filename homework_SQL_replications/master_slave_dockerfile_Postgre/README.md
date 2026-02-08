# Запуск контейнеров

`Собираем контейнеры`

```
docker build -t pg_master -f ./Dockerfile_master .
docker build -t pg_slave -f ./Dockerfile_slave .
```
`Добавляем новую сеть`
```
docker network create replication
```
`Запускаем контейнеры:`

```
docker run --name postgres-master --net replication -p 5433:5432 -v ./data:/var/lib/postgresql/data -d pg_master

docker run --name postgres-slave --net replication -p 5434:5432 -v ./data:/var/lib/postgresql/data -d pg_slave
```

`Контейнеры между собой соединяются сетью replication благодаря ключу --net.`
`Ключ -v монтирует внешний том с данным postgres`
