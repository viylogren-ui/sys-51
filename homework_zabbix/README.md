# Домашнее задание к занятию "`Система мониторинга Zabbix`" - `Ренёв Виталий`

   
---

### Задание 1

`Приведите ответ в свободной форме........`

1. `Установка postgresql: sudo apt install postgresql`

2. `Установка репозитория zabbix:`

   `wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_6.0+debian11_all.deb`

   `dpkg -i zabbix-release_latest_6.0+debian11_all.deb`

   `apt update.`

3. `Установка zabbix-сервера и web-интерфейса`

   `apt install zabbix-server-pgsql zabbix-frontend-php php7.4-pgsql zabbix-apache-conf zabbix-sql-scripts`

4. `Проверяю статус сервиса zabbix-server.service`

   `systemctl status zabbix-server.service`

5. `Создаю пользователя БД с паролем vitren:`
   
   `su - postgres -c 'psql --command "CREATE USER zabbix WITH PASSWORD '\'vitren\'';"'`

6. `Создаю базу данных zabbix для пользователя zabbix`

   `su - postgres -c 'psql --command "CREATE DATABASE zabbix OWNER zabbix;"`

7. `На zabbix-сервере импортирую первичные скрипты (схему и данные)`

   `zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix`

8. `Прописываю в zabbix-server пароль пользователя DBPassword`

   `sed -i 's/# DBPassword=/DBPassword=vitren/g' /etc/zabbix/zabbix_server.conf`

9. `Перезапуск сервисов zabbix-server, apache2 и добавление служб в автозапуск`

   `sudo systemctl restart zabbix-server apache2`
   `sudo systemctl enable zabbix-server apache2`

``
![Авторизация в админке zabbix.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_zabbix/img/1.1_Авторизация_в_админке_zabbix.png)` 

``
![Успешный вход](https://github.com/viylogren-ui/sys-51/blob/main/homework_zabbix/img/1.2_Успешный_вход.png)`

---

### Задание 2

   `Установка zabbix-client на хосты zabbix-server и zabbix-client`

1. `zabbix-server`

```
установка агента:
# apt install zabbix-agent - установка агента

запуск процесса агента при загрузке:
# systemctl restart zabbix-agent
# systemctl enable zabbix-agent
```
2. `zabbix-client:` 

   `устанавливаю репозиторий аналогично заданию 1`
```
# wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_latest_6.0+debian11_all.deb
# dpkg -i zabbix-release_latest_6.0+debian11_all.deb
# apt update
```
   `устанавливаю агента аналогично zabbix-serer`
```
# apt install zabbix-agent
# systemctl restart zabbix-agent
# systemctl enable zabbix-agent
```


``

![Название скриншота](ссылка на скриншот)`
