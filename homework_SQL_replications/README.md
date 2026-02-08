# Домашнее задание к занятию "`Репликация и масштабирование. Часть 1`" - `Ренёв Виталий`

### Задание 1

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.

### Решение 1

`master-slave - механизм копирования данных из одной БД-master в другую БД-slave, при котором данные в БД-slave пишутся и стираются в зависимости от изменения данных в БД-master. При этом пользователь имеет возможность записи и изменения данных только в БД-master, а к БД-slave имеет доступ только на чтение.`
`master-master - механизм двунаправленного копирования данных БД-master-1 - БД-master-2, при этом у пользователя появляется возможность записи и чтения в обе БД. Оба сервера БД становятся и мастером и слейвом одновременно. При изменении данных в одной из БД автоматически меняются соответствующие записи в другой БД.` 

`Механизм репликации позволяет распределить нагрузку на сервера БД, повысить отказоустойчивость системы, ее доступность и надежность. При этом не является механизмом резервирования в чистом виде, т.к. при изменении данных на сервере-master - на slave данные изменятся автоматически, в том числе и при удалении. Основной задачей репликации с точки зрения отказоустойчивости является защита от аппаратного сбоя системы.`

---

### Задание 2

Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.

### Решение 2

### Вариант 1. В командной строке.

`Запуск master-rvs и slave-rvs в созданной сети replication с конфигурационными файлами master.cnf, slave.cnf, которые копируются внутрь контейнеров в /etc`

![1.0.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/1.0.png)


`Проверка запущенных контейнеров, с проброшенными портами и правильной записи конфигов в контейнерах в /etc`

![1.1.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/1.1.png)


`Создание пользователя repl для реплики на master-rvs, выдаем права для репликации, применяем изменения. На slave-rvs изменяем источник данных для журнала.`

![1.2.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/1.2.png)


`Запускаем реплику на slave-rvs, проверяем источник данных и что нет ошибок.`

![1.3.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/1.3.png)


`Подключаемся к master-rvs и slave-rvs в DBeaver по соответствующим портам 3307 и 3308.`

![1.4.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/1.4.png)


`Создаем базу и таблицу на master, проверяем, что автоматически сущности создаются на slave-rvs-сервере, и удаляются соответственно.`

![1.5.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/1.5.png)


### Вариант 2. С помощью dockerfile в VSCode.

`Собираем образ mysql_master из Dockerfile_master`

![2.0.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/2.0.png)


`Собираем образ mysql_slave из Dockerfile_slave`

![2.1.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/2.1.png)


`Создаем сеть replication`

![2.2.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/2.2.png)


`Запускаем контейнер mysql_master в сети replication, который слушает порт 3309`

![2.3.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/2.3.png)


`Запускаем контейнер mysql_slave в сети replication, который слушает порт 3310`

![2.4.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/2.4.png)



`Подключаемся в DBeaver, проверяем работоспособность`

![2.5.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/2.5.png)

![2.6.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/2.6.png)


### Задание 3* 

Выполните конфигурацию master-master репликации. Произведите проверку.

### Решение 3*

`Собираем образ master-1 из Dockerfile_master-1`

![3.0.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/3.0.png)


`Собираем образ master-2 из Dockerfile_master-2`

![3.1.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/3.1.png)


`Создаем сеть replication_mm, запускаем контейнеры master-1 и master-2 в сети replication_mm, которые слушают порты 3311, 3312 соответственно`

![3.2.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/3.2.png)


`Подключаемся в DBeaver, проверяем, что при изменении данных на одном из master-серверов, данные меняются на другом`
![3.3.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_SQL_replications/img/3.3.png)