#!/bin/bash

# set -e

# Файл инициализации мастера
# Создаем пользователя для репликации
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replicatorpass';
ALTER SYSTEM SET wal_level = 'replica';
ALTER SYSTEM SET max_wal_senders = 10;
ALTER SYSTEM SET wal_keep_size = 1024;
ALTER SYSTEM SET hot_standby = on;
EOSQL
# Применяем изменения
pg_ctl restart

# Создаёт пользователя replicator с правами на репликацию (REPLICATION).
# Устанавливает пароль replicatorpass (в зашифрованном виде, благодаря ENCRYPTED).
# wal_level = 'replica' — включает запись достаточного количества информации в WAL,
# чтобы standby-сервер мог читать и применять изменения.
# max_wal_senders — определяет, сколько одновременно может быть подключений для репликации.
# wal_keep_size = 1024 — сохраняет WAL-файлы размером минимум 1024 МБ, чтобы standby-сервер мог успеть их забрать.
# hot_standby = on — позволяет standby-серверу принимать запросы на чтение (пока он реплицирует данные с мастера)




