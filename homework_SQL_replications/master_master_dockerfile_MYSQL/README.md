`Собираем контейнеры`
```
docker build -t master-1 -f ./Dockerfile_master-1 .
docker build -t master-2 -f ./Dockerfile_master-2 .
```

`Добавляем новую сеть`
```
docker network create replication_mm
```

`Запускаем контейнеры:`
```
docker run --name master-1 --net replication_mm -p 3311:3306 -d master-1
docker run --name master-2 --net replication_mm -p 3312:3306 -d master-2
```