
# Использую образ ubuntu-2004-lts, который я выбрал с помощью CLI команды 
# "yc compute image list --folder-id standard-images | grep ubuntu

data "yandex_compute_image" "ubuntu-2004-lts" {
  family = "ubuntu-2004-lts"
}

# Создаваю 2 ВМ на основне выбранного образа

resource "yandex_compute_instance" "my_wm" {
  count = 2
  name        = "wm-${count.index}" #Имя ВМ в облачной консоли по индексу count
  hostname    = "wm-${count.index}" #FDQN имя хоста по индексу count.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ (должна совпадать с зоной subnet)
  
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.id
      size = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = true
  }

  metadata = {
    user-data          = file("./cloud-init.yaml")
  }
}

# Создаю сеть и подсеть

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

#Создаю целевую группу с описанием сетевых реурсов, входящих в эту группу

resource "yandex_lb_target_group" "target_group" {
  name = "my-wm-target-group"
  dynamic "target" {
    for_each = yandex_compute_instance.my_wm
    content {
      subnet_id = yandex_vpc_subnet.subnet-1.id
      address = target.value.network_interface[0].ip_address
    }
   }
  }

# Создаю сетевой балансировщик, который "слушает" порт 80

resource "yandex_lb_network_load_balancer" "network_load_balancer" {
  name = "my-wm-network-load-balancer"

  listener {
    name = "http"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
# Описание параметров целевой группы для сетевого балансирощика, 
#с проверкой http healthcheck на порту 80 наличия корневого каталога

  attached_target_group {
    target_group_id = yandex_lb_target_group.target_group.id
    healthcheck {
      name = "http-check"
      http_options {
        port = 80
        path = "/"
      }
    }
  }  
}

# Блок вывода информации о балансировщике по команде terraform output

data "yandex_lb_network_load_balancer" "my_wm" {
  network_load_balancer_id = yandex_lb_network_load_balancer.network_load_balancer.id
  }

output "network_load_balancer_cteated" {
  value = data.yandex_lb_network_load_balancer.my_wm.created_at
}

output "network_load_balancer_listener" {
  value = data.yandex_lb_network_load_balancer.my_wm.listener
}


#Получение информации об IP-адресах созданных ресурсов

output "external_ip_address_my_wm" {
  value = "${yandex_compute_instance.my_wm.*.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_my_wm" {
  value = "${yandex_compute_instance.my_wm.*.network_interface.0.ip_address}"
}

# Создаю файл-инвентори с информацией об IP-адресах созданных ресурсов для ansible-playbook

resource "local_file" "inventory" {
  content  = <<-XYZ
   [network-interfaces_nat]
   ${yandex_compute_instance.my_wm.0.network_interface.0.nat_ip_address}
   ${yandex_compute_instance.my_wm.1.network_interface.0.nat_ip_address}
  XYZ
  filename = "./hosts.ini"
}