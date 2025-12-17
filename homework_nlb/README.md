# Домашнее задание к занятию "`Отказоустойчивость в облаке`" - `Ренёв Виталий`

### Задание 1

`Создано 2 виртуальные машины в YC с использованием terraform и аргумента count, таргет-группа и сетевой балансировщик. Написан ansible-playbook, который устанавливает роль geerling.nginx на управляемые хосты, адреса которых прописываются в процессе инсталляции terraform apply в создаваемом файле hosts.ini`


[Ссылка на файл terraform-playbook main.tf](main.tf)

`Статус NLB и доступность таргет-группы в YC`
![1.1_nlb_status.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_nlb/img/1.1_nlb_status.png)

`Демонстрация обращения к разным серверам по одному IP-адресу NLB`

`В разных браузерах`
![1.2_nlb_in_different_browsers.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_nlb/img/1.2_nlb_in_different_browsers.png)

`С помощью команды curl <ip-address NLB>`
![1.3_curl_ip_nlb.png](https://github.com/viylogren-ui/sys-51/blob/main/homework_nlb/img/1.3_curl_ip_nlb.png)


