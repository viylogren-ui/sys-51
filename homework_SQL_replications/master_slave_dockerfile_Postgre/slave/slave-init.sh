#!/bin/bash

# set -e

# Файл конфигурации слейва:

PGPASSWORD=replicatorpass pg_basebackup -h postgres-master -U replicator -p 5433 -D /var/lib/postgresql/data -Fp -Xs -P -R -S slave1 -C

# -h postgres-master — указывает адрес сервера-источника (primary).
# -U replicator Пользователь — подключается от имени пользователя replicator (созданного ранее).
# -p 5433 — порт, на котором работает мастер.
# -D /var/lib/postgresql/data — куда сохранить копию данных (обычно это каталог data standby-сервера).
# -Fp — копирует файлы «как есть» (вместо архива .tar).
# -Xs — параллельно с бэкапом потоково передаёт WAL-логи (stream).
# -P — показывает прогресс копирования в реальном времени.
# -R — создаёт standby.signal и настраивает postgresql.auto.conf для реплики.
# -S slave1 — создаёт слот репликации с именем slave1 (для отслеживания прогресса).
# -C — создаёт слот репликации перед началом копирования (если слота не существует)