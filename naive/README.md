# Входной сервер

## Настройки

Необходимо указать некоторые адреса и пароли для корректной работы.

Важно придумать сложный пароль, сделать это можно через эту команду:

```bash
$ cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 28 ; echo
```

После чего данные нужно занести в файл `.env` в таком формате:

```env
# Публичный домен для маскировки
NAIVE_HOST=

# Логин от NaiveProxy
NAIVE_USER=

# Пароль от NaiveProxy
NAIVE_PASS=

# IP адрес выходного прокси
PROXY_IP=

# Логин от выходного прокси (с предыдущего шага)
PROXY_USER=

# Пароль от выходного прокси (с предыдущего шага)
PROXY_PASS=
```

## Запуск

Создаем сертификаты для внутреннего DNS:

```bash
$ openssl req -x509 -nodes -newkey rsa:4096 -days 3650 -sha256 -keyout dns-key.pem -out dns.pem -subj "/CN=localhost"
```

Откройте `dnscrypt-proxy.toml` и отредактируйте в самом низу `stamp` как указано.

Запускаем Docker:

```bash
$ docker volume create caddy_data
$ docker compose up -d

# Проверить статус можно через
$ docker ps
```

## Настройка AdGuard

Теперь нужно корректно настроить наш выходной DNS.

Заходим на `https://adm.ВАШДОМЕН`. Вас встретит окно настроек:

**Важно** порт админ панели указываем как **3000** вместо 80.

Создаем пользователя со сложным паролем, записываем это.

Завершаем установку. Вас заредиректит на адрес, который не откроется. **Поэтому вручную** вводим еще раз `https://adm.ВАШДОМЕН` и входим в аккаунт.

Открываем `Настройки > Шифрование`.

Ставим галочку, имя сервера оставляем пустым.

Путь к сертификату указываем как `/root/proxy.crt`.

Путь к приватному ключу как `/root/proxy.key`.

Сохраянем. Всё должно быть без ошибок.

## Системный DNS

```bash
$ sudo apt remove resolvconf
$ sudo cp /etc/resolv.conf /etc/resolv.conf.backup
$ sudo chattr -i /etc/resolv.conf
$ sudo rm -f /etc/resolv.conf

$ sudo nano /etc/resolv.conf
# Вставить туда:
nameserver 127.0.0.1
options edns0

# Проверить можно:
$ dig yandex.ru
# В самом конце должно быть SERVER: 127.0.0.1#53(127.0.0.1)

# И на всякий случай перезапустим Docker:
$ docker compose up -d --force-recreate
```

Всё готово.
