14 Резервное копирование 20181211 [Настраиваем Backup]

Домашнее задание

Настраиваем Backup
Настроить стенд Vagrant с двумя виртуальными машинами server и client.

Настроить политику бэкапа директории /etc с клиента:
1) Полный бэкап - раз в день
2) Инкрементальный - каждые 10 минут
3) Дифференциальный - каждые 30 минут

Запустить систему на два часа. Для сдачи ДЗ приложить list jobs, list files jobid=<id>
и сами конфиги bacula-*

* Настроить доп. Опции - сжатие, шифрование, дедупликация 



Устанавливал bacula 9.2.2 + mysql на centos 7

Не все сразу заработало и, как-то так случайно получилось, что система работала день или больше.
В какой-то момент я добавил ```echo "hello bacula" > /etc/hello_bacula_$(date +'%Y-%m-%d_%H-%M-%S').txt``` в cron раз в 10 мин чтобы хоть что-то видеть в инкременте/диффе.

В list.txt - list jobs и, выборочно, list files jobid=<id>

+ Сами конфиги.
Доп опции не трогал