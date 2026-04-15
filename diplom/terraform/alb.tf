# Создание Application Load Balancer - сетевого балансировщика

# Создаю Target Group - набор IP-адресов, на которых развернут nginx
resource "yandex_alb_target_group" "target_group" {
  name = "target-group"

  target {
    subnet_id          = yandex_vpc_subnet.develop_a.id
    ip_address         = yandex_compute_instance.web-a.network_interface.0.ip_address
  }

  target {
    subnet_id          = yandex_vpc_subnet.develop_b.id
    ip_address         = yandex_compute_instance.web-b.network_interface.0.ip_address
  }
}

# Создаю Backand Group - тип HTTP для L7-балансировщика
resource "yandex_alb_backend_group" "backend_group" {
  name  =  "backend-group"

  http_backend {
    name                = "http-backend"
    port                = 80
    target_group_ids    = ["${yandex_alb_target_group.target_group.id}"]
    healthcheck {
      timeout = "10s"
      interval = "2s"
      healthcheck_port = 80
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# Создаю HTTP-роутер
resource "yandex_alb_http_router" "alb-http-router" {
  name = "alb-http-router"
}

# Создаю ALB-виртуальный хост
resource "yandex_alb_virtual_host" "alb_virtual_host" {
  name = "alb-virtual-host"
  http_router_id = yandex_alb_http_router.alb-http-router.id
  route {
    name = "alb-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend_group.id
        timeout = "3s"
      }
    }
  }
}

# Создаю ALB
resource "yandex_alb_load_balancer" "alb-load-balancer" {
  name = "alb-load-balancer"
  network_id = yandex_vpc_network.develop.id
  security_group_ids = [yandex_vpc_security_group.alb-load-balancer-sg.id]

  allocation_policy {
    location {
      zone_id = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.develop_a.id
    }
    location {
      zone_id = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.develop_b.id
    }
  }

  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.alb-http-router.id
      }
    }
  }
}