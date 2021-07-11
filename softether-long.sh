#!/bin/bash

os_distribution="$(cat /etc/os-release | grep "ID" | head -1 | awk -F '"' '{print $2}')"

if [[ "$os_distribution" == "centos" ]]; then
  yum install -y epel-release && yum update -y
  yum install -y git readline-devel openssl-devel make gcc
elif [[ "$os_distribution" != "centos" ]]; then
  apt install -y git make gcc
fi

cd /tmp
git clone https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
cd SoftEtherVPN_Stable
./configure
make
mv bin/vpnserver /opt
mv systemd/softether-vpnserver.service /etc/systemd/system
systemctl daemon-reload
systemctl enable softether-vpnserver.service && systemctl start softether-vpnserver.service
rm -rf /opt/SoftEtherVPN_Stable