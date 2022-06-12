#!/bin/bash

# **********************************************************
#         >>>>>>>>>>>>>>> FUNCTIONS <<<<<<<<<<<<<<<
# **********************************************************

get_distr () {

    if [ -r /etc/os-release ]; then
      source /etc/os-release && distr="$ID"
      else 
        echo -en "\033[1;31m\n Версия дистрибутива не определена, завершаюсь \033[0m\n"
      exit 1
    fi

    

    if [[ $distr = "fedora" || $distr = "centos" || $distr = "ubuntu" || $distr = "debian" ]]; then
      distr_version="$VERSION_ID"
      else 
        echo -en "\033[1;31m\n Дистрибутив не подходит, завершаюсь \033[0m\n"
      exit 1
    fi

    echo -en "\033[1;32m\n Определен дистрибутив >>> $distr $distr_version \033[0m\n" && sleep 3

  return
}

install_deb () {
    apt update
    apt install -y git make gcc libssl-dev libreadline6-dev zlib1g-dev
  return
}

install_rpm () {
    dnf update -y
    dnf install -y git nano readline-devel openssl-devel zlib-devel make gcc
  return
}

install_softether () {
    cd /tmp
    git clone --depth=1 https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
    cd SoftEtherVPN_Stable

    ./configure
    make

    mv bin/vpnserver /opt
    mv systemd/softether-vpnserver.service /etc/systemd/system/softethervpn.service

    systemctl daemon-reload
    systemctl enable softethervpn.service && systemctl start softethervpn.service
  return
}

# **********************************************************
#         >>>>>>>>>>>>>>> EXECUTION <<<<<<<<<<<<<<
# **********************************************************

get_distr

if [[ $distr = "debian" || $distr = "ubuntu" ]]; then
  install_deb 2> /dev/null
fi

if [[ $distr = "centos" && $distr_version = "6" || $distr = "centos" && $distr_version = "7" ]]; then
  echo -en "\033[1;31m\n Нужна CentOS версии 8 или новее, завершаюсь \033[0m\n"
  exit 1
fi  

if [[ $distr = "centos" || $distr = "fedora" ]]; then
  install_rpm 2> /dev/null
fi

install_softether
