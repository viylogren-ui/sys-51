#resource "yandex_compute_snapshot" "bastion" {
#  name           = "bastion-snapshot"
#  source_disk_id = yandex_compute_disk.bastion-disk.id
#}

# Создание снимков дисков инфраструктуры
resource "yandex_compute_snapshot_schedule" "snapshots-my-infrastructure" {
  name = "snapshots"

  schedule_policy {
#    expression = "@hourly"  
    expression = "*/15 * * * *" # Проверяю создание снимков каждые 15 минут
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

output "snapshot_schedule_info" {
  description = "ID и имя созданного расписания снимков"
  value       = {
#    id   = yandex_compute_snapshot_schedule.snapshots-my-infrastructure.id
    attached_disks = yandex_compute_snapshot_schedule.snapshots-my-infrastructure.disk_ids
    name = yandex_compute_snapshot_schedule.snapshots-my-infrastructure.name
  }
}


#data "yandex_compute_snapshot_schedule" "snapshots" {
#  snapshot_schedule_id = "snapshots-id"
#}
#
#output "snapshot_schedule" {
#  value = data.yandex_compute_snapshot_schedule.snapshots.status
#}

#data "yandex_compute_snapshot_schedule" "snapshot_schedule" {
#  snapshot_schedule_id = "snapshot_schedule"
#}
#
#output "snapshot_schedule" {
#  value = data.yandex_compute_snapshot_schedule.snapshot_schedule.status
#}

