#!/bin/bash

osos="$(cat /etc/os-release | grep "ID" | head -1 | awk -F '"' '{print $2}')"

if [[ "$osos" == "centos" ]]; then
  yum install -y epel-release
  yum update -y
  yum install -y git readline-devel openssl-devel make gcc
elif [[ "$osos" != "centos" ]]; then
  apt install -y git make gcc
fi
