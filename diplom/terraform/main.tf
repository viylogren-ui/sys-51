
#Считываю данные об образе ОС
data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}


# Создаю диск для bastion
resource "yandex_compute_disk" "bastion-disk" {
  name     = "bastion-disk"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "10"
  image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
}

# Создаю ВМ bastion
resource "yandex_compute_instance" "bastion" {
  name        = "bastion" #Имя ВМ в облачной консоли
  hostname    = "bastion" #формирует FQDN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3" # идентификатор процессора Intel Ice Lake
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    auto_delete = true
    disk_id = yandex_compute_disk.bastion-disk.id
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  
  scheduling_policy { preemptible = true } # прерываемая ВМ

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true # наличие внешнего IP для БАСТИОНа
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }
}


# Создаю диск для web-a
resource "yandex_compute_disk" "web-a-disk" {
  name     = "web-a-disk"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "10"
  image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
}

# Создаю ВМ web-a
resource "yandex_compute_instance" "web-a" {
  name        = "web-a" #Имя ВМ в облачной консоли
  hostname    = "web-a" #формирует FQDN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!


  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    auto_delete = true
    disk_id = yandex_compute_disk.web-a-disk.id
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id
    nat                = false # внешний IP для web-a отсутствует
    security_group_ids = [yandex_vpc_security_group.web_sg.id] # слушаем 443, 80, 22 для ssh
  }
}


# Создаю диск для web-b
resource "yandex_compute_disk" "web-b-disk" {
  name     = "web-b-disk"
  type     = "network-hdd"
  zone     = "ru-central1-b"
  size     = "10"
  image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
}

# Создаю ВМ web-b
resource "yandex_compute_instance" "web-b" {
  name        = "web-b" #Имя ВМ в облачной консоли
  hostname    = "web-b" #формирует FQDN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!}

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    auto_delete = true
    disk_id = yandex_compute_disk.web-b-disk.id
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_b.id
    nat                = false # внешний IP для web-b отсутствует
    security_group_ids = [yandex_vpc_security_group.web_sg.id] # слушаем 443, 80, 22 для ssh

  }
}

# Создаю диск для elasticsearch-server
resource "yandex_compute_disk" "elasticsearch-server-disk" {
  name     = "elasticsearch-server-disk"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "10"
  image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
}


# Создаю ВМ elasticsearch-server
resource "yandex_compute_instance" "elasticsearch-server" {
  name        = "elasticsearch-server" #Имя ВМ в облачной консоли
  hostname    = "elasticsearch-server" #формирует FQDN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3" # идентификатор процессора Intel Ice Lake
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    auto_delete = true
    disk_id = yandex_compute_disk.elasticsearch-server-disk.id
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true } # прерываемая ВМ

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = false # внешний IP для elasticsearch-server отсутствует
    security_group_ids = [yandex_vpc_security_group.elasticsearch-sg.id] # слушает 22, 9200 порты
  }
}


# Создаю диск для zabbix-server
resource "yandex_compute_disk" "zabbix-server-disk" {
  name     = "zabbix-server-disk"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "10"
  image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
}

# Создаю ВМ zabbix-server
resource "yandex_compute_instance" "zabbix-server" {
  name        = "zabbix-server" #Имя ВМ в облачной консоли
  hostname    = "zabbix-server" #формирует FQDN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3" # идентификатор процессора Intel Ice Lake
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    auto_delete = true
    disk_id = yandex_compute_disk.zabbix-server-disk.id
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true } # прерываемая ВМ


  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true # наличие внешнего IP для zabbix-server
    security_group_ids = [yandex_vpc_security_group.zabbix-server-sg.id] # слушает 22, 80, 443, 10050 порты
  }
}


# Создаю диск для kibana-server
resource "yandex_compute_disk" "kibana-server-disk" {
  name     = "kibana-server-disk"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "10"
  image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
}

# Создаю ВМ kibana-server
resource "yandex_compute_instance" "kibana-server" {
  name        = "kibana-server" #Имя ВМ в облачной консоли
  hostname    = "kibana-server" #формирует FQDN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3" # идентификатор процессора Intel Ice Lake
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    auto_delete = true
    disk_id = yandex_compute_disk.kibana-server-disk.id
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true } # прерываемая ВМ

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop_a.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true # наличие внешнего IP для kibzna-server
    security_group_ids = [yandex_vpc_security_group.kibana-server-sg.id] # слушает 22, 80, 443, 5601 порты
  }
}
