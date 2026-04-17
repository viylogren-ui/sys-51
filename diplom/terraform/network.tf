#создаю облачную сеть develop-cloud
resource "yandex_vpc_network" "develop" {
  name = "develop-${var.flow}"
}

#создаю подсеть zone A
resource "yandex_vpc_subnet" "develop_a" {
  name           = "develop-${var.flow}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

#создаю подсеть zone B
resource "yandex_vpc_subnet" "develop_b" {
  name           = "develop-${var.flow}-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

#создаю NAT для выхода в интернет
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "develop-${var.flow}-gateway"
  shared_egress_gateway {}
}

#создаю сетевой маршрут для выхода в интернет через NAT
resource "yandex_vpc_route_table" "rt" {
  name       = "route-table-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}


# Application Load Balancer входящий трафик разрешен только на порты 80 и 
# 30080 (для проверки состояния узлов ALB в разных зонах доступности) из любых сетей

resource "yandex_vpc_security_group" "alb-load-balancer-sg" {
  name       = "alb-load-balancer-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow different zone"
    protocol       = "TCP"
    port           = 30080
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}


# bastion-server входящий трафик на бастион со всех адресов, но только на 22 TCP (SSH) порт 22

resource "yandex_vpc_security_group" "bastion" {
  name       = "bastion-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id
  ingress {
    description    = "Allow SSH"
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

# входящий трафик на WEB-сервера разрешен только на 22, 443, 80, 10050 TCP-порты из любых сетей
resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "Allow SSH" # для доступа к ВМ через бастион по SSH
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow zabbix"
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}



# входящий трафик на elasticsearch-server разрешен только на 22, 9200 TCP-порты из любых сетей
resource "yandex_vpc_security_group" "elasticsearch-sg" {
  name       = "elasticsearch-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "Allow SSH" # для доступа к ВМ через бастион по SSH
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    description    = "Allow Elasticsearch"
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# zabbix-server входящий трафик для разрешен только на TCP-порты 22, 80, 443, 10050 из любых сетей

resource "yandex_vpc_security_group" "zabbix-server-sg" {
  name       = "zabbix-server-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
      description    = "Allow SSH"
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    }

  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow ZABBIX"
    protocol       = "TCP"
    port           = 10050
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# kibana-server входящий трафик для разрешен только на TCP-порты 22, 80, 443, 5601 из любых сетей

resource "yandex_vpc_security_group" "kibana-server-sg" {
  name       = "kibana-server-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
      description    = "Allow SSH"
      protocol       = "TCP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    }

  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow KIBANA"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}