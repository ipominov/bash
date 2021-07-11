#!/bin/bash

# Скрипт устанавливает SoftEther VPN Server на CentOS и Ubuntu -
# устанавливает пакеты, компилирует сервер из исходников, создает и запускает службы.

# Берем в переменную название и версию дистрибутива:
os_distrib="$(cat /etc/os-release | grep "ID" | head -1 | awk -F '"' '{print $2}')"
distrib_version="$(cat /etc/os-release | grep "VERSION_ID" | head -1 | awk -F '"' '{print $2}')"

# Устанавливаем пакеты в зависимости от дистирибутива
if [[ "$os_distrib" == "centos" ]] && [[ "$distrib_version" == "7" ]]; then
  yum install -y epel-release && yum update -y
  yum install -y git readline-devel openssl-devel make gcc
elif [[ "$os_distrib" == "centos" ]] && [[ "$distrib_version" == "8" ]]; then
  dnf update -y
  dnf install -y git readline-devel openssl-devel make gcc
fi

if [[ "$os_distrib" == "ubuntu" ]]; then
  apt install -y git make gcc
fi

# Качаем исходники с гитхаба во временную папку:
cd /tmp
git clone https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
cd SoftEtherVPN_Stable

# Компилируем:
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
