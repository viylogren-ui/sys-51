1. Создать сервисный аккаунт в облаке. Выдать права editor
2. Выпустить авторизованный ключ для этого аккаунта и скачать его по пути ~/.authorized_key.json . 
3. Вписать в переменные cloud_id и folder_id в variables.tf
4. Изменить ssh-ключ в файле cloud-init.yml (ssh-keygen -t ed25519). cp .terraformrc ~/.terraformrc
5. terraform init && terraform apply
6. Проверить в разделе Network Load Balancer статус Active и доступность целевой группы
7. rm ~/.ssh/known_hosts. Прописать в ansible.cfg host_key_checking=False ansible-playbook -i ./hosts.ini test.yml
8. Проверить доступность ресурсов для ansible ansible -m ping network-interfaces_nat -u vitas -i hosts.ini
9. Запустить playbook ansible-playbook test.yml -u vitas
10. Проверить работу nginx на удаленных ВМ 
11. Войти по ssh vitas@ip-address на удаленные ресурсы, создать бэкап файла index.nginx-debian.html    sudo cp index.nginx-debian.html index.nginx-debian.bak, отредактировать index.nginx-debian.html на свой, перезапустить nginx sudo systemctl reload nginx, проверить результат через браузер
12. Проверить работу Network Load Balancer curl ip-address балансировщика
13. Удалить созданные ресурсы terraform destroy
 

