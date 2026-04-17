#output "external_ip_address_bastion" {
#  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
#}
#
#output "internal_ip_address_bastion" {
#  value = yandex_compute_instance.bastion.network_interface.0.ip_address
#}
#
#output "FQDN_bastion" {
#  value = yandex_compute_instance.bastion.fqdn
#}
#
#output "external_ip_address_zabbix-server" {
#  value = yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address
#}
#
#output "internal_ip_address_zabbix-server" {
#  value = yandex_compute_instance.zabbix-server.network_interface.0.ip_address
#}
#
#output "FQDN_zabbix-server" {
#  value = yandex_compute_instance.zabbix-server.fqdn
#}
#
#output "external_ip_address_kibana-server" {
#  value = yandex_compute_instance.kibana-server.network_interface.0.nat_ip_address
#}
#
#output "internal_ip_address_kibana-server" {
#  value = yandex_compute_instance.kibana-server.network_interface.0.ip_address
#}
#
#output "FQDN_kibana-server" {
#  value = yandex_compute_instance.kibana-server.fqdn
#}
#
#output "internal_ip_address_elasticsearch-server" {
#  value = yandex_compute_instance.elasticsearch-server.network_interface.0.ip_address
#}
#
#output "FQDN_elasticsearch-server" {
#  value = yandex_compute_instance.elasticsearch-server.fqdn
#}
#
#output "internal_ip_address_web_a" {
#  value = yandex_compute_instance.web_a.network_interface.0.ip_address
#}
#
#output "FQDN_web_a" {
#  value = yandex_compute_instance.web_a.fqdn
#}
#
#output "internal_ip_address_web_b" {
#  value = yandex_compute_instance.web_b.network_interface.0.ip_address
#}
#
#output "FQDN_web_b" {
#  value = yandex_compute_instance.web_b.fqdn
#}

#output "external_ip_address_alb-load-balancer" {
#  value = yandex_alb_load_balancer.alb-load-balancer.0.endpoint.0.address.0.external_ipv4_address
#}


output "alb_external_ip" {
  description = "external_ip_ALB"
  value       = yandex_alb_load_balancer.alb-load-balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}


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