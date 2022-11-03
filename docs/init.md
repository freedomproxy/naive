# Настройка окружения

Выполняется на обоих серверах. В это входит усиление безопасности и установка Docker.

Вы можете пропустить шаги по безопасности, что не рекомендуется. **Главное - рабочий Docker**.

## Безопасность

Обновить пакеты:

```bash
$ apt update && apt upgrade && apt dist-upgrade && apt autoremove
$ apt install sudo # В некоторых хостах нет sudo.
```

Сгенерировать сложный пароль через команду:

```bash
$ cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 28 ; echo
```

Создать пользователя:

```bash
$ adduser admin # Придумайте сложный пароль и запишите его.
$ usermod -aG sudo admin

# Если у вас нет своего ключа (на вашем пк), его необходимо создать. В линуксе это делается такой командой:
$ ssh-keygen -t rsa

$ ssh-copy-id admin@$IP # Запустить с вашего пк. $IP заменить на айпи адрес сервера.
```

Усиливаем SSH:

```bash
$ nano /etc/ssh/sshd_config

# Ищем в этом файле опции с таким названием и меняем значения на:
Port 2323 # или любая ваша цифра
PermitRootLogin no
PasswordAuthentication no
AddressFamily inet

$ systemctl restart sshd
```

Ставим фаерволл:

```bash
$ apt install fail2ban ufw
$ ufw default allow outgoing
$ ufw default deny incoming
$ ufw allow 2323
$ ufw allow 443
$ ufw allow 80

# ВАЖНО! ТОЛЬКО на выходном сервере так же надо открыть:
$ ufw allow 444

$ ufw allow to 172.17.0.0/16
$ ufw enable
```

Обновляем сетевые настройки:

```bash
$ sysctl -w net.ipv4.tcp_congestion_control=bbr
$ sysctl -w net.ipv4.tcp_slow_start_after_idle=0
$ sysctl -w net.ipv4.tcp_notsent_lowat=16384
```

И перезагружаемся через `reboot`.

Теперь логин будет через:

```bash
$ ssh -p 2323 admin@$IP # $IP заменить на айпи адрес сервера.
```

Создадим ключ для доступа к выходному прокси:

```bash
$ ssh-keygen -t rsa
```

Для безопасности всё готово.

## Установка Docker.

```bash
$ sudo apt install gnupg2 software-properties-common ca-certificates curl lsb-release
$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
$ echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt update
$ sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
$ newgrp docker

# Теперь проверяем что все работает:
$ docker version
$ docker compose version
```

Всё готово. Переходите к следующему шагу.
