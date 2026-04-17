# Создание снимков дисков инфраструктуры
resource "yandex_compute_snapshot_schedule" "snapshots-my-infrastructure" {
  name = "snapshots"

# Кажды день в полночь
  schedule_policy {
#    expression = "@daily"  
    expression = "@midnight" 
#    expression = "0 0 ? * *"
  }

  snapshot_count = 7 # всего 7 снимков


  disk_ids = [
    yandex_compute_disk.bastion-disk.id, 
    yandex_compute_disk.zabbix-server-disk.id, 
    yandex_compute_disk.elasticsearch-server-disk.id,
    yandex_compute_disk.kibana-server-disk.id,
    yandex_compute_disk.web-a-disk.id,
    yandex_compute_disk.web-b-disk.id
  ]
}



#output "snapshot_schedule_info" {
#  description = "ID и имя созданного расписания снимков"
#  value       = {
##    id   = yandex_compute_snapshot_schedule.snapshots-my-infrastructure.id
#    attached_disks = yandex_compute_snapshot_schedule.snapshots-my-infrastructure.disk_ids
#    name = yandex_compute_snapshot_schedule.snapshots-my-infrastructure.name
#  }
#}