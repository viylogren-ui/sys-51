# В результате развертывания инфраструктуры terraform apply создается файл-nventory для ansible.

resource "local_file" "inventory" {
  content  = <<-XYZ
  [all:vars]
  ansible_user=vitas
  ansible_ssh_private_key_file=~/.ssh/id_ed25519
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q vitas@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"'

  application-load-balancer=${yandex_alb_load_balancer.alb-load-balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address}
  bastion=${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}
  
  web-a=${yandex_compute_instance.web-a.network_interface.0.ip_address}
  web-b=${yandex_compute_instance.web-b.network_interface.0.ip_address}

  elasticsearch-server=${yandex_compute_instance.elasticsearch-server.network_interface.0.ip_address}

  zabbix-server=${yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address}
  kibana-server=${yandex_compute_instance.kibana-server.network_interface.0.nat_ip_address}


  [bastion]
  bastion-server ansible_host=bastion.ru-central1.internal

  [elasticsearch]
  elasticsearch-server ansible_host=elasticsearch-server.ru-central1.internal

  [kibana]
  kibana-server ansible_host=kibana-server.ru-central1.internal

  [hosts]
  web-a ansible_host=web-a.ru-central1.internal
  web-b ansible_host=web-b.ru-central1.internal
  
  [monitoring]
  zabbix-server ansible_host=zabbix-server.ru-central1.internal
  XYZ
  filename = "../ansible/hosts.ini"
}