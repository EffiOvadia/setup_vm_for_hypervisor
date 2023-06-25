apt update && apt upgrade

### ------------------------------------------------------------------------------------------

### Install the Non Free additions
apt install -y build-essential module-assistant linux-headers-$(uname -r)
m-a prepare
sh /media/*/*/VBoxLinuxAdditions.run

### Install the Free addtions
apt install virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r)

### ------------------------------------------------------------------------------------------

### Uninstall addtions using installed script
/opt/VBoxGuestAdditions-*/uninstall.sh

### Uninstall addition using script from additions media
sh /media/*/VBoxLinuxAdditions.run uninstall

### Uninstall Free additions
apt remove virtualbox*