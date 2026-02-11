`Запустим Docker контейнер Postgres`
docker run --name postgres_for_particion -p 5433:5432 -e POSTGRES_PASSWORD=vitas2025 -d postgres:17
`Подключаемся DBeaver`


`Для запуска postgreSQL используем docker compose. Создадим файл        docker-compose.yml и добавим в него узел master: postgres_b`

`Добавим в docker-compose.yml шарды: postgres_b1, postgres_b2, postgres_b3`

`Создаем отношения в postgres_b1/shards.sql, postgres_b2/shards.sql, postgres_b3/shards.sql`

`Добавляем данные в созданну таблицу isert_data.sql`

`Запускаем контейнеры`

```
docker compose up -d
```