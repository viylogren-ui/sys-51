#  Дипломная работа по профессии «Системный администратор» Ренёв Виталий

## Решение:

### Инфраструктура

Для развертывания инфраструктуры с помощью terraform созданы файлы формата .tf, выполняющие следующие задачи:

### [main.tf](https://github.com/viylogren-ui/sys-51/blob/main/diplom/terraform/main.tf)

Создаются следующие ресурсы:
1. С использованием образа ubuntu-2204-lts создаются виртуальные машины: 
    * bastion, через которую по протоколу ssh будет осуществляться настройка с помощью ansible удаленных хостов;
    * две ВМ web-a и web-b в разных зонах ru-central1-а и ru-central1-b соответственно, без доступа во внешнюю сеть;
    * elasticsearch-server для сбора логов, который в соответствии с заданием также без доступа во внешнюю сеть;
    * две ВМ: zabbix-server и kibana-server для мониторинга событий и визуализации сбора логов стека ELK.
2. Для каждого ресурса создается диск "yandex_compute_disk", с которого в соответствии с заданием будут сниматься snapshots.
3. Все ВМ в соответствии с заданием включены в соответствующие группы безопасности и "слушают" входящий трафик только на необходимых портах.

### [network.tf](https://github.com/viylogren-ui/sys-51/blob/main/diplom/terraform/network.tf)

Создаются следующие ресурсы:
1. облачная VPC-сеть, в которой будут две подсети zona B и zona B для соответствующих зон доступности
2. шлюз NAT-gateway для доступа "во внешний мир" тех ВМ, которые такой доступ по заданию не имеют (web-a, web-b, elasticsearch-server)
3. также в этом файле описаны правила для групп безопасности для ВМ.

### [alb.tf](https://github.com/viylogren-ui/sys-51/blob/main/diplom/terraform/alb.tf)

Отдельно для удобства вынес код, описывающий развертывание Application Load Balancer, который будет балансировать нагрузку на наши web-сервера. healthcheck настроен на корень (/) и порт 80, протокол HTTP.

### [snapshots.tf](https://github.com/viylogren-ui/sys-51/blob/main/diplom/terraform/snapshots.tf)

В данном блоке в соответствии с заданием создается расписание, по которому ежедневно в полночь создаются снимки созданных ресурсов (дисков ВМ). Всего хранится 7 таких снимков (за семь суток), что обеспечит еженедельное их обновление.

### [output.tf](https://github.com/viylogren-ui/sys-51/blob/main/diplom/terraform/output.tf)

С помощью данного кода создается файл-inventory для ansible, где:
1. в качестве переменной указываю имя пользователя с правами sudo на создаваемых ресурсах, путь к публичному ssh-ключу, а также команду для доступа к ВМ через bastion по ssh. Также в инвентори-файле;
2. указываю для удобства внешние и внутренние IP-адреса создаваемых ресурсов;
3. указываю для ansible создаваемые в YC fqdn-имена ресурсов.

### [variables.tf](https://github.com/viylogren-ui/sys-51/blob/main/diplom/terraform/variables.tf)

Здесь я прописал идентификаторы cloud и folder id, а также строку vpc-network (просто от наработок осталось:) для network.tf.


С помощью команды terraform apply из директории terraform запускаю код для развертывания инфраструктуры:

`Результат выполнения команды terraform apply`
![1.1_terraform_apply.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.1_terraform_apply.png)


`Развернутая инфраструктура в YC`
![1.2_terraform_apply.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.2_terraform_apply.png)


`Созданные ВМ в YC`
![1.3_terraform_apply.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.3_terraform_apply.png)


`Созданный Application Load Balancer`

![1.4_alb.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.4_alb.png)


`Application Load Balancer HTTP проверка`

![1.4.1_alb.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.4.1_alb.png)


`Расписание снимков состояний ВМ`
![1.5_snapshots.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.5_snapshots.png)


`Настройка сетей, подсетей`
![1.6_networks.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.6_networks.png)


`Инвентори-файл для ansible`
![1.7_hosts.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.7_hosts.png)

#

Для дальнейшей настройки инфраструктуры с помощью ansible создаю файл конфигурации [ansible.cfg](https://github.com/viylogren-ui/sys-51/blob/main/diplom/ansible/ansible.cfg), где прописываю путь к файлу инвентори (чтобы постоянно к нему не обращаться) и отключаю необходимость проверки ключей.

Проверяю доступность хостов для ansible *ansible all -m ping -f 1*:

![1.8_ansible_ping.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.8_ansible_ping.png)


В файлах [nginx_web-a.yml](https://github.com/viylogren-ui/sys-51/blob/main/diplom/ansible/nginx_web-a.yml), [nginx_web-a.yml](https://github.com/viylogren-ui/sys-51/blob/main/diplom/ansible/nginx_web-b.yml) прописан код для установки веб-сервера nginx на web-a, web-b и копирования стартовой html-страницы на соответствующие сервера. 
Запускаю *ansible-playbook nginx_web-a.yml*, *ansible-playbook nginx_web-b.yml*:

![1.9_nginx_web.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.9_nginx_web.png)


Проверяю работу балансировщика нагрузки через браузер:

![1.10_alb.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.10_alb.png)


Работа балансировщика через командную строку *curl -v 111.88.254.35:80*:

![1.11_alb.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.11_alb.png)

#

В файле [zabbix-server.yml](https://github.com/viylogren-ui/sys-51/blob/main/diplom/ansible/zabbix-server.yml) в соответствии с инструкцией с официального сайта поэтапно прописан порядок установки zabbix-server, zabbix-agent и необходимых зависимостей на управляемый хост zabbix-server, который будет мониторить состояние web-севреров.
В файле [zabbix-agent.yml](https://github.com/viylogren-ui/sys-51/blob/main/diplom/ansible/zabbix-agent.yml) аналогично в соответствии с официальной инструкцией устанавливаю zabbix-agent на web-сервера и прописываю в файле конфигурации zabbix_agentd.conf путь к zabbix-server.

Запускаю установку zabbix-server, zabbix-agent:

`zabbix-server`
![1.12_zabbix_server.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.12_zabbix_server.png)

`zabbix-agent`
![1.13_zabbix_agent.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.13_zabbix_agent.png)


Проверяю работоспособность zabbix-server, регистрируюсь с учетной записью, которую указал при конфигурации zabbix-server, прописываю хосты, прикрепляю Linux by zabbix templates, настраиваю дашборды.

Дашборд общего состояния контролируемых хостов и zabbix-server. (Для чистоты эксперимента на время отключил web-a и убедился в появлении соответствующей проблемы)

![1.14_global_view.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.14_global_view.png)

Дашборд состояния сервера

![1.15_server_health.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.15_server_health.png)

Дашборд по принципу USE (Utilization, Saturation, Errors) для CPU, RAM, диски, сеть, http запросов к веб-серверам

![1.16_web_health.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.16_web_health.png)

#

Для сбора логов развернул ELK стек. Для установки компонентов добавил репозиторий из зеркала Yandex mirror, установил необходимые компоненты, связал друг с другом с помощью файлов конфигурации и проконтролировал поступление логов в дашборде kibana

[filebeat.yml](https://github.com/viylogren-ui/sys-51/blob/main/diplom/ansible/filebeat.yml) с помощью модуля nginx отправляет на порт 9200 elasticsearch access.log, error.log.

[elasticsearch.yml](https://github.com/viylogren-ui/sys-51/blob/main/diplom/ansible/elasticsearch.yml) собирает поступающие логи от nginx

[kibana.yml](https://github.com/viylogren-ui/sys-51/blob/main/diplom/ansible/kibana.yml) предоставляет возможность визуализировать поступающие от nginx с помощью filebeat логи в elasticsearch

Запускаю поочередно kibana.yml, elasticsearch.yml, filebeat.yml.

`Установка kibana`
![1.17_kibana.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.17_kibana.png)


`Установка elasticsearch`
![1.18_elasticsearch.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.18_elasticsearch.png)


`Установка filebeat`
![1.19_filebeat.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.19_filebeat.png)

Удостоверяюсь в поступлении логов в дашборде kibana

![1.20_kibana.png](https://github.com/viylogren-ui/sys-51/blob/main/diplom/img/1.20_kibana.png)