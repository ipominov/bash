#!/bin/bash

swapoff -a

systemctl disable ufw && systemctl stop ufw

echo br_netfilter >> /etc/modules-load.d/br_netfilter.conf
modprobe br_netfilter
sysctl -w net.bridge.bridge-nf-call-ip6tables=1 
sysctl -w net.bridge.bridge-nf-call-iptables=1

apt update -y && apt install docker docker.io apt-transport-https ca-certificates curl -y

cat << EOF > /etc/docker/daemon.json
{ 
   "exec-opts": ["native.cgroupdriver=systemd"] 
}
EOF

systemctl restart docker

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg 
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/ku>
apt update -y && apt install kubelet kubeadm kubectl -y
