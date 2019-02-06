24 Web сервера 20190201 [Web сервера]

Домашнее задание:

Написать конфигурацию nginx, которая даёт доступ клиенту только с определенной cookie.

Если у клиента её нет, нужно выполнить редирект на location, в котором кука будет добавлена, после чего клиент будет обратно отправлен (редирект) на запрашиваемый ресурс.

Предварительно можно прописать в hosts fqdn для тесового сайта, я указывал у себя
lab24.otus.lan

Результат: nginx.conf

server {
...
    location / {
        if ($cookie_testclient = "") {
            return 301 /set-cookie;
        }
    }

    location /set-cookie {
        add_header Set-Cookie "testclient=$remote_addr";
        return 301 /;
    }
...
}

Тестирование открыть в браузере по ip/fqdn

curl:

curl http://lab24.otus.lan returns 301
curl -L lab24.otus.lan return (47) Maximum (50) redirects followed;
curl lab24.otus.lan/set-cookie returns 301
curl --cookie "testclient=1" lab24.otus.lan retunrs normal page