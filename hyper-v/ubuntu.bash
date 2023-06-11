#@ Change repositories to Microsoft Azure 
sudo \cat > /etc/apt/sources.list <<-EOF
### $(lsb_release -sd) $(lsb_release -sc)
### --------------------------------------------------------------------------------------------------------
deb [arch=$(dpkg --print-architecture)] http://azure.archive.ubuntu.com/ubuntu  $(lsb_release -sc)           main restricted universe multiverse
deb [arch=$(dpkg --print-architecture)] http://azure.archive.ubuntu.com/ubuntu  $(lsb_release -sc)-updates   main restricted universe multiverse
deb [arch=$(dpkg --print-architecture)] http://azure.archive.ubuntu.com/ubuntu  $(lsb_release -sc)-backports main restricted universe multiverse
deb [arch=$(dpkg --print-architecture)] http://security.ubuntu.com/ubuntu       $(lsb_release -sc)-security  main restricted universe multiverse
### --------------------------------------------------------------------------------------------------------
EOF

#@ Install optimized azure/hyper-v ubuntu kernel
sudo apt update && apt install --assume-yes linux-azure

#@ Setup the system to automaticly update 
sudo apt install --assume-yes unattended-upgrades
sudo dpkg-reconfigure --priority=low  unattended-upgrades
