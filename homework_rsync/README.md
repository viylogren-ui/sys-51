# Домашнее задание к занятию "`Резервное копирование`" - `Ренёв Виталий`

---

### Задание 1

```
rsync -a --progress --delete --exclude '.*/' ~/ /tmp/backup

```

`Данная команда позволяет создать зеркальную копию домашней директории пользователя в директорию /tmp/backup, при этом из синхронизации исключены все скрытые директории`

![Команда](https://github.com/viylogren-ui/sys-51/blob/main/homework_rsync/img/1.1_rsync_delete_exclude.jpg)
![Результат выполнения команды](https://github.com/viylogren-ui/sys-51/blob/main/homework_rsync/img/1.2_rsync_delete_exclude_results.jpg)
---

### Задание 2

`Скрипт backup.sh, который создает зеркальную резервную копию домашнего каталога пользователя vitas в папке /tmp/backup, настроен в cron на ежедневное выполнение в 22.00`


![Результат работы утилиты](https://github.com/viylogren-ui/sys-51/blob/main/homework_rsync/img/2.1_rsync_cron_daily.jpg)

[Ссылка на файл crontab](crontab_daily)