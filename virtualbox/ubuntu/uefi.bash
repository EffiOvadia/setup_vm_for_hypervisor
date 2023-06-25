### ------------------------------------------------------------------------
install grub-efi-amd64-signed shim-signed && update-grub
### ------------------------------------------------------------------------
###  fix from bash on: Ubuntu
sudo mkdir /boot/efi/EFI/BOOT 
sudo cp /boot/efi/EFI/ubuntu/grubx64.efi /boot/efi/EFI/BOOT/bootx64.efi
echo 'FS0:\EFI\ubuntu\grubx64.efi' > /boot/efi/startup.nsh
### ------------------------------------------------------------------------
###  fix from bash on: Debian
sudo mkdir /boot/efi/EFI/BOOT 
sudo cp /boot/efi/EFI/debian/grubx64.efi /boot/efi/EFI/BOOT/bootx64.efi
echo 'FS0:\EFI\debian\grubx64.efi' > /boot/efi/startup.nsh
### ------------------------------------------------------------------------
### fix from EFI shell
echo FS0:\EFI\debian\grubx64.efi > startup.nsh
### ------------------------------------------------------------------------