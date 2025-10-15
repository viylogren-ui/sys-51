terraform {
  required_version = ">=1.8.4"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.129.0"
    }
   
#    docker = {
#      source = "kreuzwerker/docker"
#      version = "3.6.2"
#    }
  }
}

provider "yandex" {
  # token                    = "do not use!!!"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = file("~/.authorized_key.json")
}

#provider "docker" {
#  host = "unix:///var/run/docker.sock"
#}
