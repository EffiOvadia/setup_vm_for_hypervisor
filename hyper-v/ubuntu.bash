#!/bin/bash

## Install TOR and HTTPS transport for apt 
sudo apt install --assume-yes apt-transport-https apt-transport-tor 

## delete old format sources.list 
sudo [ -f /etc/apt/sources.list ] && sudo rm -f /etc/apt/sources.list

## Generate new deb822 format ubuntu.sources file in sources.list.d
sudo cat > /etc/apt/sources.list.d/ubuntu.sources <<-EOF
X-Repolib-Name: $(lsb_release -sd) $(lsb_release -sc)
Enabled: yes
Types: deb deb-src
URIs: http://azure.archive.ubuntu.com/ubuntu
Suites: $(lsb_release -sc) $(lsb_release -sc)-updates $(lsb_release -sc)-backports
Components: main restricted universe multiverse
Architectures: $(dpkg --print-architecture)
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

X-Repolib-Name: $(lsb_release -sd) $(lsb_release -sc)
Enabled: yes
Types: deb deb-src
URIs: http://security.ubuntu.com/ubuntu  
Suites: $(lsb_release -sc)-security
Components: main restricted universe multiverse
Architectures: $(dpkg --print-architecture)
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

## Install optimized azure/hyper-v ubuntu kernel
sudo apt update && apt install --assume-yes linux-azure

## Setup the system to automaticly update 
sudo apt install --assume-yes unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
