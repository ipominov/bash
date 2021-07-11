#!/bin/bash

# Скрипт устанавливает SoftEther VPN Server на CentOS 7 и Ubuntu -
# устанавливает пакеты, компилирует сервер из исходников, создает и запускает службы.

# Берем название дистрибутива:
os_distribution="$(cat /etc/os-release | grep "ID" | head -1 | awk -F '"' '{print $2}')"

# Устанавливаем пакеты в зависимости от дистирибутива
if [[ "$os_distribution" == "centos" ]]; then
  yum install -y epel-release && yum update -y
  yum install -y git readline-devel openssl-devel make gcc
elif [[ "$os_distribution" != "centos" ]]; then
  apt install -y git make gcc
fi

# Качаем исходники с гитхаба во временную папку:
cd /tmp
git clone https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
cd SoftEtherVPN_Stable

# Компилируем
./configure
make

# перемещаем готовые бинарники и юниты:
mv bin/vpnserver /opt
mv systemd/softether-vpnserver.service /etc/systemd/system

# Перечитываем юниты, активируем и запускаем службу:
systemctl daemon-reload
systemctl enable softether-vpnserver.service && systemctl start softether-vpnserver.service

# Удаляем временную папку:
rm -rf /opt/SoftEtherVPN_Stable