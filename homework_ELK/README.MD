# Домашнее задание к занятию "`ELK`" - `Ренёв Виталий`

### Задание 1. Elasticsearch 

Установите и запустите Elasticsearch, после чего поменяйте параметр cluster_name на случайный. 

*Приведите скриншот команды 'curl -X GET 'localhost:9200/_cluster/health?pretty', сделанной на сервере с установленным Elasticsearch. Где будет виден нестандартный cluster_name*.

### Решение 1

`Elasticsearch`
![1_elsticsearch.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_ELK/img/1_elsticsearch.png)

---

### Задание 2. Kibana

Установите и запустите Kibana.

*Приведите скриншот интерфейса Kibana на странице http://<ip вашего сервера>:5601/app/dev_tools#/console, где будет выполнен запрос GET /_cluster/health?pretty*.

### Решение 2

`Kibana`
![2_kibana.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_ELK/img/2_kibana.png)

---

### Задание 3. Logstash

Установите и запустите Logstash и Nginx. С помощью Logstash отправьте access-лог Nginx в Elasticsearch. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx.*

### Решение 3.

`logstash_nginx`
![4_logstash_nginx.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_ELK/img/4_logstash_nginx.png)


`localhost:9200/_cat/indices`
![4_0_logstash_nginx.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_ELK/img/4_0_logstash_nginx.png)


`kibana_logs`
![4_1_logstash_nginx.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_ELK/img/4_1_logstash_nginx.png)

### Задание 4. Filebeat. 

Установите и запустите Filebeat. Переключите поставку логов Nginx с Logstash на Filebeat. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx, которые были отправлены через Filebeat.*

### Решение 4.

`nginx-filebeat-logstash`
![5_0_filebeat_nginx.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_ELK/img/5_0_filebeat_nginx.png)

`elasticsearch - localhost:9200/_cat/indices`
![5_1_filebeat_nginx.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_ELK/img/5_1_filebeat_nginx.png)

`kibana_logs`
![5_2_filebeat_nginx.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_ELK/img/5_2_filebeat_nginx.png)

