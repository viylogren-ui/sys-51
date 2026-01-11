# Домашнее задание к занятию  «Очереди RabbitMQ» - Ренёв Виталий


### Задание 1. Установка RabbitMQ

Используя Vagrant или VirtualBox, создайте виртуальную машину и установите RabbitMQ.
Добавьте management plug-in и зайдите в веб-интерфейс.

*Итогом выполнения домашнего задания будет приложенный скриншот веб-интерфейса RabbitMQ.*

### Решение 1.

`RabbitMQ`
![1_RabbitMQ.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_RabbitMQ/img/1_RabbitMQ.png)
---

### Задание 2. Отправка и получение сообщений

Используя приложенные скрипты, проведите тестовую отправку и получение сообщения.
Для отправки сообщений необходимо запустить скрипт producer.py.

Для работы скриптов вам необходимо установить Python версии 3 и библиотеку Pika.
Также в скриптах нужно указать IP-адрес машины, на которой запущен RabbitMQ, заменив localhost на нужный IP.

```shell script
$ pip install pika
```

Зайдите в веб-интерфейс, найдите очередь под названием hello и сделайте скриншот.
После чего запустите второй скрипт consumer.py и сделайте скриншот результата выполнения скрипта

*В качестве решения домашнего задания приложите оба скриншота, сделанных на этапе выполнения.*

Для закрепления материала можете попробовать модифицировать скрипты, чтобы поменять название очереди и отправляемое сообщение.

### Решение 2.

`RabbitMQ.png`
![2_producer_RabbitMQ.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_RabbitMQ/img/2_producer_RabbitMQ.png)

`RabbitMQ.png`
![2_consumer_RabbitMQ.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_RabbitMQ/img/2_consumer_RabbitMQ.png)

---


### Задание 3. Подготовка HA кластера

Используя Vagrant или VirtualBox, создайте вторую виртуальную машину и установите RabbitMQ.
Добавьте в файл hosts название и IP-адрес каждой машины, чтобы машины могли видеть друг друга по имени.

Пример содержимого hosts файла:
```shell script
$ cat /etc/hosts
192.168.0.10 rmq01
192.168.0.11 rmq02
```
После этого ваши машины могут пинговаться по имени.

Затем объедините две машины в кластер и создайте политику ha-all на все очереди.

*В качестве решения домашнего задания приложите скриншоты из веб-интерфейса с информацией о доступных нодах в кластере и включённой политикой.*

Также приложите вывод команды с двух нод:

```shell script
$ rabbitmqctl cluster_status
```

Для закрепления материала снова запустите скрипт producer.py и приложите скриншот выполнения команды на каждой из нод:

```shell script
$ rabbitmqadmin get queue='hello'
```

После чего попробуйте отключить одну из нод, желательно ту, к которой подключались из скрипта, затем поправьте параметры подключения в скрипте consumer.py на вторую ноду и запустите его.

*Приложите скриншот результата работы второго скрипта.*

### Решение 3.

По заданию создал вторую виртуальную машину. Установил на ней RabbitMQ, создал на обеих машинах файл /etc/hosts с названиями и IP-адресами хостов. PING по именам и IP проходит, rabbitmqctl cluster_status показывает ноды. 

`Файл /etc/hosts на обеих машинах, PING в обе стороны проходит`
![etc_hosts_ping.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_RabbitMQ/img/etc_hosts_ping.png)


`Результат вывода команды rabbitmqctl cluster_status на server2`
![cluster_status_server2.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_RabbitMQ/img/cluster_status_server2.png)

`При попытке создать кластер выдает ошибку. Прошу подсказку.`

```
sudo rabbitmqctl join_cluster rabbit@Server2
Clustering node rabbit@Server1 with rabbit@Server2

01:15:17.270 [error] Feature flags: error while running:
Feature flags:   rabbit_ff_controller:running_nodes[]
Feature flags: on node `rabbit@Server2`:
Feature flags:   exception error: {erpc,noconnection}
Feature flags:     in function  erpc:call/5 (erpc.erl, line 1376)
Feature flags:     in call from rabbit_ff_controller:rpc_call/5 (rabbit_ff_controller.erl, line 1616)
Feature flags:     in call from rabbit_ff_controller:list_nodes_clustered_with/1 (rabbit_ff_controller.erl, line 570)
Feature flags:     in call from rabbit_ff_controller:check_node_compatibility_task/3 (rabbit_ff_controller.erl, line 433)
Feature flags:     in call from rabbit_db_cluster:can_join/1 (rabbit_db_cluster.erl, line 62)
Feature flags:     in call from rabbit_db_cluster:join/2 (rabbit_db_cluster.erl, line 95)
Feature flags:     in call from erpc:execute_call/4 (erpc.erl, line 1250)

Error:
{:aborted_feature_flags_compat_check, {:error, {:erpc, :noconnection}}}
```

`Заодно напишите пожалуйста команду, с помощью которой создается политика ha-all на всех очередях. Пока тоже безрезультативно.`