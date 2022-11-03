# Внешний сервер

## Авторизация

Важно придумать сложный пароль, сделать это можно через эту команду:

```bash
$ cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 28 ; echo
```

После чего данные нужно занести в файл `.env` в таком формате:

```env
# Логин от выходного прокси
PROXY_USER=

# Пароль от выходного прокси
PROXY_PASS=
```

Эти данные понадобятся на первом (входом) сервере. Запишите их.

## Сгенерировать сертификаты

```bash
$ docker run -v "$(pwd)/certs:/certs" \
  -e SSL_EXPIRE=3650 \
  -e SSL_SIZE=4096 \
  -e CA_EXPIRE=3650 \
  -e SSL_SUBJECT=proxy \
  -e SSL_DNS=guard \
  -e SSL_IP=$HOST \
  paulczar/omgwtfssl
# где $HOST - внешний IP адрес сервера

$ sudo chown -R admin:admin ./*
$ mv certs/key.pem proxy.key
$ mv certs/ca.pem rootCA.crt
$ mv certs/cert.pem proxy.crt
```

Все ключи храните в надежном месте на выходной проксе.

`rootCA.crt` нужно перенести на входную машину так же в домашнюю директорию. Это можно скопировать.

## Запуск

Остается только запустить Docker:

```bash
$ docker volume create caddy_data
$ docker compose up -d

# Проверить статус можно через
$ docker ps
```
