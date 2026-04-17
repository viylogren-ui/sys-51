#создаем облачную сеть develop-cloud
resource "yandex_vpc_network" "develop" {
  name = "develop-${var.flow}"
}

#создаем подсеть zone A
resource "yandex_vpc_subnet" "develop_a" {
  name           = "develop-${var.flow}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

#создаем подсеть zone B
resource "yandex_vpc_subnet" "develop_b" {
  name           = "develop-${var.flow}-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

#создаем NAT для выхода в интернет
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "develop-${var.flow}-gateway"
  shared_egress_gateway {}
}

#создаем сетевой маршрут для выхода в интернет через NAT
resource "yandex_vpc_route_table" "rt" {
  name       = "route-table-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

#создаем группы безопасности(firewall)

# БАСТИОН входящий трафик на бастион со всех адресов, но только на TCP(SSH) порт 22
# БАСТИОН исходящий трафик с бастиона на любые адреса, на любые порты
resource "yandex_vpc_security_group" "bastion" {
  name       = "bastion-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

# внутри LAN весь входящий трафик для любых ВМ из сети 10.0.0.0/8 разрешен
# внутри LAN весь исходящий трафик для любых ВМ внутри сети резрешен
resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id
  ingress {
    description    = "Allow 10.0.0.0/8"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.0.0/8"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

# входящий трафик на WEB сервера разрешен только на 443 и 80 TCP-порты из любых сетей
## Пока разрешим любой входящий трафик на WEB-сервера для проверки установки zabbix!!
resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id


  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
#    port           = 443
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
#  ingress {
#    description    = "Allow HTTP"
#    protocol       = "TCP"
#    port           = 80
#    v4_cidr_blocks = ["0.0.0.0/0"]
#  }


}
