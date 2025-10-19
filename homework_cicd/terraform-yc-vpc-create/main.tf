data "yandex_compute_image" "ubuntu_2204_lts" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "jenkins" {
  name        = "jenkins" #Имя ВМ в облачной консоли
  hostname    = "jenkins" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-a" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }
  
  network_interface {
#    index = 1
    subnet_id          = yandex_vpc_subnet.jenkins_subnet.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
  }
}


resource "yandex_compute_instance" "nexus" {
  name        = "nexus" #Имя ВМ в облачной консоли
  hostname    = "nexus" #формирует FDQN имя хоста, без hostname будет сгенрировано случаное имя.
  platform_id = "standard-v3"
  zone        = "ru-central1-b" #зона ВМ должна совпадать с зоной subnet!!!

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }
  
  network_interface {
#    index = 1
    subnet_id          = yandex_vpc_subnet.nexus_subnet.id #зона ВМ должна совпадать с зоной subnet!!!
    nat                = true
  }
}


resource "local_file" "inventory" {
  content  = <<-XYZ
  [jenkins]
  ${yandex_compute_instance.jenkins.network_interface.0.nat_ip_address}
#  ${yandex_compute_instance.jenkins.network_interface.0.ip_address}

  [nexus]
  ${yandex_compute_instance.nexus.network_interface.0.nat_ip_address}
#  ${yandex_compute_instance.nexus.network_interface.0.ip_address}
  XYZ
  filename = "./hosts.ini"
}