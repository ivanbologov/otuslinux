# Домашнее задание "Пишем скрипт".
Подготовить свои скрипты для решения следующих кейсов
1. watchdog с перезагрузкой процесса/сервиса
1. watchdog с отсылкой емэйла
1. анализ логов веб сервера/security лога - (на взлом/скорость ответа/выявление быстрых - медленных запросов, анализ IP адресов и кол-ва запросов от них)
1. крон скрипт с защитой от мультизапуска
1. любой скрипт на ваше усмотрение


* _step12.sh_ подходит под __п. 1,2,4__;
* _step4.sh_ другая реализация __п.4__;
* _step3.sh_ - __п.3__ считает кол-во авторизаций пользователя с определенный ключом + ipv4 пользователя и назначенный пользователю ipv4;
* _step5.sh_ и _test.sh_ - __п.5__, _step5.sh_ я использовал в debian, из коробки в centos работать не будет. _test.sh_ симулирует процесс который выполняет работу за которой следит watchdog;

После provision в crontab пользователя vagrant будет установлен файл vagrant.cron.

Vagrant.cron запустит скрипт "test.sh" через скрипт watchdog "step12.sh" и будет каждую минуту проверять, что test.sh запущен, если последний вылетит, step12.sh его перезапустит.

Чтобы было интереснее test.sh будет вылетать, причем довольно часто, если ему передать параметр break.

Step12.sh будет отправлять email если ему передать параметр nofify, но чтобы это работало надо для пакета ssmtp указать ящик с которого будет отправка и кто будет получатель.

__Для этого__

1. в "configs/ssmtp.conf" нужно заполнить
```
root=receiver@example.com
mailhub=sender_smtp.example.com
RewriteDomain=sender_example.com
AuthUser=sender smtp login
AuthPass=sender smtp password
```

2. Заменить строку __sender@example.com:smtp.example.com:587__ на свои данные в формате __your_login@your.domain:mailhub.your.domain[:port]__
```
sed -i "s/sender@example.com:smtp.example.com:587/$mymapping/g" configs/revaliases
```

### Разные vagrant*cron реализуют разные сценарии watchdog

* vagrant.cron - __default__ - запуск test.sh, проверка его работы и перезапуск, test.sh не будет самостоятельно себя завершать.
* vagrant.break.cron - запуск test.sh, проверка его работы и перезапуск, test.sh будет самостоятельно себя завершать.
* vagrant.mail.cron - запуск test.sh, проверка его работы и перезапуск, при перезапуске отправка email, test.sh не будет самостоятельно себя завершать.
* vagrant.mail.break.cron - запуск test.sh, проверка его работы и перезапуск, при перезапуске отправка email, test.sh будет самостоятельно себя завершать.

### Поменять crontab
```
crontab -r
kill $(cat /home/vagrant/hometask05/testlock)
sudo crontab -u vagrant $new_vagrant_cron
```
