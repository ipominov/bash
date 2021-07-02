#!/bin/bash
dnf install -y git readline-devel openssl-devel make gcc
git clone https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
cd SoftEtherVPN_Stable
./configure
make
mv bin/vpnserver /opt
mv systemd/softether-vpnserver.service /etc/systemd/system
systemctl daemon-reload
systemctl enable softether-vpnserver.service && systemctl start softether-vpnserver.service
rm -rf ~/SoftEtherVPN_Stable
