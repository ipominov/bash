<h2>Небольшие bash-скрипты</h2>

<b>k8s-install-ubuntu.sh</b>:
Устанавливает Kubernetes на Ubuntu из пакетов

<b>wordpress-site-copy.sh</b>:
Для виртуального хостинга Timeweb. Частая просьба клиентов, сделать копию сайта в соседнем каталоге на том же аккаунте. Скрипт переносит сайт на Wordpress в другой каталог, импортирует дамп базы в новую отдельную базу, которую нужно создать заранее.

<b>softether-vpn-install.sh</b>:
Устанавливает серверную часть SoftEtherVPN на машину с CentOS7/8 или Ubuntu. Ставит нужные пакеты, качает исходники с гитхаба, компилирует, создает юнит systemd и запускает сервер.<br />
<b>(!!!)</b> Не настраивает фаервол и прочие вещи, только ставит SoftEther VPN <b>(!!!)</b>
