08 Размещаем свой RPM в своем репозитории

В качестве подопытного для сборки apache 2.4.37-1 с модулем mod_http2.so.

Задача "чтобы всё было идеально" не ставиться, цель с минимальными усилиями собрать последнюю версию апача и добавить модуль для работы с http2.

Собранные rpm разместить в репозитории.

Vagrantfile поднимет репозиторий и разместит в нем предварительно собранные rpm.

Если будет желание собрать rpm необходимо зайти пользователем vagrant и запустить скрипт do_httpd_rpm.sh

Ключевые моменты для успешной компиляции apache и сборки rpm пакета:

Для компиляции apache понадобятся:

zlib-devel libselinux-devel libuuid-devel apr-devel apr-util-devel pcre-devel openldap-devel lua-devel libxml2-devel openssl-devel libnghttp2-devel

Из-за разных версий apr-devel (apr-devel-1.4.8-3.el7_4.1.x86_64) apr-util-devel (apr-util-devel-1.5.2-6.el7.x86_64)

при сборке rpm возникнет ошибка:

RPM build errors: File not found: /home/vagrant/rpmbuild/BUILDROOT/httpd-2.4.37-1.x86_64/usr/lib64/httpd/modules/mod_mpm_event.so

Поэтому придется собркать еще apr-devel версии 1.5.2, тогда все будет соберется.

Что и как в скрипте do_httpd_rpm.sh