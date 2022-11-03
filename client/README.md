# Настройка клиента

## Windows

В любом месте создаём папку для прокси.

Скачиваем себе [DNSCrypt](https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/2.1.2/dnscrypt-proxy-win64-2.1.2.zip)

Из архива переносим в папку файл `dnscrypt-proxy.exe` и все `.bat` файлы.

Из этого репозитория переносим в папку [этот](dnscrypt-proxy.toml) файл и в самом конце настраиваем `stamp` как указано.

Скачиваем [NaiveProxy](https://github.com/klzgrad/naiveproxy/releases/download/v106.0.5249.91-1/naiveproxy-v106.0.5249.91-1-win-x64.zip)

Из архива переносим в папку файлы `naive.exe` и `config.json`

Открываем `config.json` и значение `proxy` меняем на то как указано, **к примеру** `https://admin:1234@mydomain.com`

Запускаем `dnscrypt-proxy.exe` и проверяем чтобы не было ошибок. После чего запускаем `service-install.bat`

В винде в настройках сети меняем DNS IPV4 на то чтобы вручную всё шло к единственному незашифрованному серверу на 127.0.0.1

На DNS можно забить. Теперь всё будет автоматически.

Запускаем `naive.exe`. Если нет ошибок - поздравляю, вы всё сделали.

**Пока я не сделаю bat для создания службы, naive.exe надо будет запускать каждый раз при включении ПК.**

**В приложениях/Proxifier остаётся поменять прокси сервер на socks5://localhost:1080**

## Linux

TODO

Хотя там всё то же самое, только другие расширения файлов.

## MacOs

Яблоблядь не человек.

## Android

Скачиваем SagerNet - [PlayMarket](https://play.google.com/store/apps/details?id=io.nekohasekai.sagernet&hl=ru&gl=US) [APK](https://github.com/SagerNet/SagerNet/releases/tag/0.8.1-rc02)

и NaiveProxy Plugin - [PlayMarket](https://play.google.com/store/apps/details?id=io.nekohasekai.sagernet.plugin.naive&hl=en_US&gl=US) [APK](https://github.com/SagerNet/SagerNet/releases/tag/naive-plugin-106.0.5249.91-1)

Открываем Sager и выбираем Добавить профиль > `Ручные настройки` > `Naive`

Вводим в соответствующие поля ваш домен, имя пользователя и пароль.

Затем открываем настройки самого Sager, листаем, находим там `Удалённый DNS` и меняем его на `https://ВАШДОМЕН/dns`.

Всё сохраняем, тестируем, готово.

## iOS

GOTO MacOs
