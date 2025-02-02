

## install Official VMware Open Source Tools
sudo pacman -S open-vm-tools 
## Enable and Start VMware Services
sudo systemctl enable --now vmtoolsd.service
sudo systemctl enable --now vmware-vmblock-fuse.service
## Enable Shared Clipboard & Drag-and-Drop
sudo pacman -S xclip
## Test:
echo "Clipboard Test" | xclip -selection clipboard

## In VMware Workstation, go to VM > Settings > Options > Shared Folders
## list Enabled Shared Folders
vmware-hgfsclient  # Lists shared folders
## To mount Shared Folders manually
#sudo mount -t fuse.vmware-hgfsmnt .host:/your_shared_folder /mnt/shared
## To automate mounting at startup, add this to /etc/fstab:
#.host:/your_shared_folder /mnt/shared fuse.vmware-hgfsmnt allow_other,defaults 0 0

## enable 3D acceleration in VMware settings (VM > Settings > Display).
## Use Mesa drivers for better performance
sudo pacman -S mesa mesa-utils xf86-video-vmware
## Test
glxinfo | grep "OpenGL renderer string"

## Improve Manjaro power management
sudo pacman -S cpufrequtils
echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

##  Time Sync Between Host & Manjaro VM
sudo systemctl enable --now systemd-timesyncd

## Fix Slow Boot (If VMware BIOS Delay)
sudo systemctl disable lvm2-monitor
