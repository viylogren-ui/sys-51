
#Создаем облачную сеть
resource "yandex_vpc_network" "cloud" {
  name = "cloud-network"
}

#Создаем подсеть jenkins
resource "yandex_vpc_subnet" "jenkins_subnet" {
  name = "jenkins_subnet"
  v4_cidr_blocks = ["10.0.1.0/24"]
  zone = "ru-central1-a"
  network_id = yandex_vpc_network.cloud.id
}

#Создаем подсеть nexus
resource "yandex_vpc_subnet" "nexus_subnet" {
  name = "nexus_subnet"
  v4_cidr_blocks = ["10.0.2.0/24"]
  zone = "ru-central1-b"
  network_id = yandex_vpc_network.cloud.id
}