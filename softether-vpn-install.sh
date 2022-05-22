#!/bin/bash

# Берем в переменные дистрибутив и версию

os_distrib="$(cat /etc/os-release | grep "^NAME" | head -1 | awk -F '"' '{print $2}')"
distrib_version="$(cat /etc/os-release | grep "VERSION_ID" | head -1 | awk -F '"' '{print $2}')"

echo -en "\n" && echo -en "\033[1;33m     >>> Определен дистрибутив: $os_distrib $distrib_version \033[0m\n\n" && sleep 2

# Ставим пререквизиты

echo -en "\n" && echo -en "\033[1;33m     >>> Устанавливаем пререквизиты \033[0m\n\n" && sleep 1

if [[ "$os_distrib" == "centos" ]] && [[ "$distrib_version" == "7" ]]; then

  yum install -y epel-release && yum update -y
  yum install -y git readline-devel openssl-devel make gcc
    elif [[ "$os_distrib" == "centos" ]] && [[ "$distrib_version" == "8" ]]; then

    dnf update -y
    dnf install -y git readline-devel openssl-devel make gcc

fi

if [[ "$os_distrib" == "Ubuntu" ]]; then
  apt update && apt install -y git make gcc libssl-dev libreadline6-dev zlib1g-dev
fi

# Клонируем репозитория в /tmp

echo -en "\n" && echo -en "\033[1;33m     >>> Клонируем репозиторий и компилируем исходники \033[0m\n\n" && sleep 2

cd /tmp
git clone --depth=1 https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
cd SoftEtherVPN_Stable

# Компилируем

./configure
make

# Перемещаем готовые бинарники и юниты

echo -en "\n" && echo -en "\033[1;33m     >>> Устанавливаем и запускаем сервер \033[0m\n\n" && sleep 2

mv bin/vpnserver /opt
mv systemd/softether-vpnserver.service /etc/systemd/system

# Активируем и запускаем службу

systemctl daemon-reload
systemctl enable softether-vpnserver.service && systemctl start softether-vpnserver.service

echo -en "\n\n" && echo -en "\033[1;33m ******************************* \033[0m\n"
                   echo -en "\032[1;32m ***** УСТАНОВКА ЗАКОНЧЕНА ***** \033[0m\n"
                   echo -en "\033[1;33m ******************************* \033[0m\n\n" && sleep 3
