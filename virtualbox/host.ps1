
function DDWRT 
{
    Clear-Host ; Write-Host '' ; 
    if ($($PSVersionTable.PSVersion).major -gt 5 ) { Import-Module -Name NetAdapter -SkipEditionCheck }

    $OS         = @( [pscustomobject]@{Name='DD-WRT'; Type='Linux_64'; ISO=$ISOFolder+'Z:\Software\WRT\dd-wrt_x64_full_vga.image'} )
    $NIC        = @( (Get-NetAdapter -Physical | Sort-Object -property name).InterfaceDescription )
    $BaseFolder = "Z:\Virtual Machines\VirtualBox\VirtualBox VMs"
    $Medium     = $BaseFolder + "\" + $OS.name + "\" + $OS.name + ".vdi"

    Push-Location "$env:ProgramFiles\Oracle\VirtualBox\"
    .\VBoxManage createvm --name $OS.name --register --basefolder $BaseFolder --ostype $OS.type
    .\VBoxManage convertfromraw  $OS.iso $Medium --format VDI
    .\VBoxManage storagectl      $OS.name --name SATA --add sata --portcount 1 --controller IntelAHCI --bootable on --hostiocache on
    .\VBoxManage storageattach   $OS.name --storagectl SATA --port 0 --device 0 --type hdd --medium $Medium 
    .\VBoxManage modifyvm        $OS.name --chipset piix3 --memory 4096 --cpus 1 --vram 16 --keyboard usb --mouse usb 
    .\VBoxManage modifyvm        $OS.name --nic1 bridged --nictype1 Am79C973 --bridgeadapter1 $NIC[2] --cableconnected1 off
    .\VBoxManage modifyvm        $OS.name --nic2 bridged --nictype2 Am79C973 --bridgeadapter2 $NIC[3] --cableconnected2 off --nicpromisc2 allow-all 
    .\VBoxManage modifyvm        $OS.name --firmware bios --boot1 disk --boot2 none --boot3 none --boot4 none --rtcuseutc on
    .\VBoxManage modifyvm        $OS.name --audio none --usb on --usbehci on --usbxhci on
    .\vboxmanage setextradata    $OS.name installdate (get-date)
    .\vboxmanage showvminfo      $OS.name | clip
    .\vboxmanage getextradata  $OS.name enumerate
    Pop-Location 
}

function CreateVirtuaAndroid
{
    Write-Host ''
    if ($($PSVersionTable.PSVersion).major -gt 5 ) { Import-Module -Name NetAdapter -SkipEditionCheck }

    $OS         = @( [pscustomobject]@{Name='Android 8.1'; Type='Linux26_64'; ISO='Z:\Software\Android\android-x86_64-8.1-r2.iso'} )
    $NIC        = @( (Get-NetAdapter -Physical | Sort-Object -property name).InterfaceDescription )
    $BaseFolder = "Z:\Virtual Machines\VirtualBox\VirtualBox VMs"
    $Medium     = $BaseFolder  + "\" + $OS.name + "\" + $OS.name + ".vdi"

    Push-Location "$env:ProgramFiles\Oracle\VirtualBox\"
    .\VBoxManage createvm      --name $OS.name --register --basefolder $BaseFolder --ostype $OS.type
    .\VBoxManage createmedium  --format VDI --variant Standard --size 20480 --filename $Medium
    .\VBoxManage storagectl    $OS.name --name USB  --add usb  --portcount 8 --bootable on --hostiocache on --controller USB 
    .\VBoxManage storagectl    $OS.name --name NVMe --add pcie --portcount 2 --bootable on --hostiocache on --controller NVMe 
    .\VBoxManage storagectl    $OS.name --name SATA --add sata --portcount 2 --bootable on --hostiocache on --controller IntelAHCI
    .\VBoxManage storageattach $OS.name --storagectl NVMe --port 0 --device 0 --type hdd --medium $Medium --nonrotational on --discard on
    .\VBoxManage storageattach $OS.name --storagectl USB  --port 0 --device 0 --type dvddrive --medium $OS.iso
    .\VBoxManage modifyvm      $OS.name --boot1 dvd --boot2 disk --boot3 none --boot4 none --rtcuseutc on --firmware efi64
    .\VBoxManage modifyvm      $OS.name --chipset ICH9 --memory 8192 --cpus 4 --pagefusion on --guestmemoryballoon 4096
    .\VBoxManage modifyvm      $OS.name --pae on --hwvirtex on --acpi on --ioapic on --hpet on --nestedpaging on --paravirtprovider KVM
    .\VBoxManage modifyvm      $OS.name --monitorcount 1 --vrde off --accelerate3d on --accelerate2dvideo off --vram 128 --graphicscontroller vboxsvga
    .\VBoxManage modifyvm      $OS.name --nic1 bridged --nictype1 virtio --nicpromisc1 deny --bridgeadapter1 $NIC[0] --cableconnected2 on
    .\VBoxManage modifyvm      $OS.name --audiocontroller hda --audioout on --usb on --usbehci on --usbxhci on --keyboard usb --mouse ps2
    .\VBoxManage modifyvm      $OS.name --largepages on --vtxvpid on --vtxux on # Extra settings for Intel host CPU
    .\VBoxManage modifyvm      $OS.name --bioslogofadein on --bioslogofadeout on --bioslogodisplaytime 2000 
    .\VBoxManage setextradata  $OS.name VBoxInternal2/EfiGraphicsResolution 1600x900
    .\VBoxManage setextradata  $OS.name VBoxInternal2/UgaHorizontalResolution 1600
    .\VBoxManage setextradata  $OS.name VBoxInternal2/UgaVerticalResolution    900
    .\VBoxManage setextradata  $OS.name CustomVideoMode1 1600x900x32
    .\VBoxManage setextradata  $OS.name GUI/MaxGuestResolution any
    .\vboxmanage setextradata  $OS.name installdate $(Get-Date)
    .\vboxmanage showvminfo    $OS.name | clip
    .\vboxmanage getextradata  $OS.name enumerate
    Pop-Location
    Write-Host ''
    Write-Host "During the setup, Using the disk partitoning tool:"
    Write-Host " 1. Choose GPT partition table scheme"
    Write-Host " 2. Create new 1st partition with the folowing specs:"
    Write-Host "    - Set the start to :    2048" 
    Write-Host "    - Set the end to   :    +500M" 
    Write-Host "    - Set the type to  :    EF00"
    Write-Host "    - Set the name to  :    EFI System"
    Write-Host " 3. Create new 2nd partition using default size and type:"
    Write-Host "    - Set the name to  :    ROOT"
    Write-Host " 4. Choose to install on the ROOT partition and format the partition as EXT4 and"
    Write-Host ''
}
function CreateVirtualLinux
{
    Clear-Host ; Write-Host '' ; 
    if ($($PSVersionTable.PSVersion).major -gt 5 ) { Import-Module -Name NetAdapter -SkipEditionCheck }

    $OSList     = @(
                [pscustomobject]@{Name='Debian Stable';   Type='Debian_64';    ISO='Z:\Software\Debian\firmware-10.0.0-amd64-netinst.iso'}
                [pscustomobject]@{Name='Debian Unstable'; Type='Debian_64';    ISO='Z:\Software\Debian\mini.iso'}
                [pscustomobject]@{Name='Ubuntu Desktop';  Type='Ubuntu_64';    ISO='Z:\Software\Ubuntu\ubuntu-19.04-desktop-amd64.iso'}
                [pscustomobject]@{Name='Ubuntu Server';   Type='Ubuntu_64';    ISO='Z:\Software\Ubuntu\ubuntu-19.04-live-server-amd64.iso'}
                [pscustomobject]@{Name='LinuxMint';       Type='Ubuntu_64';    ISO='Z:\Software\Mint\linuxmint-19.2-cinnamon-64bit.iso'}
                [pscustomobject]@{Name='ArcLinux';        Type='ArchLinux_64'; ISO='Z:\Software\Arch Linux\archlinux-2019.08.01-x86_64.iso'}
                [pscustomobject]@{Name='Manjaro';         Type='ArchLinux_64'; ISO='Z:\Software\Manjaro\manjaro-architect-18.0.4-stable-x86_64.iso'}
                [pscustomobject]@{Name='CentOS';          Type='RedHat_64';    ISO='Z:\Software\CentOS\CentOS.iso'}
                )
    $MENU       = @{}
                for ($i=1;$i -le $OSList.count; $i++) { Write-Host "$i. $($OSList.name[$i-1])" $menu.Add($i,($OSList[$i-1])) }
                Write-Host '' ; [int]$selection = Read-Host 'Choose OS Adapter' ; Write-Host '' ; $OS = $menu.Item($selection)
    $NIC        = @( (Get-NetAdapter -Physical | Sort-Object -property name).InterfaceDescription )
    $BaseFolder = "Z:\Virtual Machines\VirtualBox\VirtualBox VMs"
    $Medium     = $BaseFolder  + "\" + $OS.name + "\" + $OS.name + ".vdi"
    $LUN_Drives = 0

    Push-Location "$env:ProgramFiles\Oracle\VirtualBox\"
    .\VBoxManage createvm      --name $OS.name --register --basefolder $BaseFolder --ostype $OS.type
    .\VBoxManage createmedium  --format VDI --variant Standard --size 20480 --filename $Medium
    .\VBoxManage storagectl    $OS.name --name USB  --add usb  --portcount 8 --bootable on --hostiocache on --controller USB 
    .\VBoxManage storagectl    $OS.name --name NVMe --add pcie --portcount 2 --bootable on --hostiocache on --controller NVMe 
    .\VBoxManage storagectl    $OS.name --name SATA --add sata --portcount 2 --bootable on --hostiocache on --controller IntelAHCI
    .\VBoxManage storageattach $OS.name --storagectl NVMe --port 0 --device 0 --type hdd --medium $Medium --nonrotational on --discard on
    .\VBoxManage storageattach $OS.name --storagectl USB  --port 0 --device 0 --type dvddrive --medium $OS.iso
    if  ($LUN_Drives -gt 0) 
    {
        .\VBoxManage storagectl  $OS.name --hostiocache on --name SAS  --add sas  --portcount 8 --controller LSILogicSAS
        foreach ($_ in 1..$LUN_Drives)
        {
            $x++ ; $Medium = $BaseFolder + "\" + $OS.name + "\" + $OS.name + " ArrayNode " + $x + ".vdi"
            .\VBoxManage createmedium --format VDI --variant Standard --size 4096 --filename $Medium
            .\VBoxManage storageattach $OS.name --storagectl SAS --port $x --type hdd --medium $Medium --nonrotational on --discard on 
        } 
    }
    .\VBoxManage modifyvm      $OS.name --clipboard bidirectional --draganddrop bidirectional
    .\VBoxManage modifyvm      $OS.name --boot1 dvd --boot2 disk --boot3 none --boot4 none --rtcuseutc on --firmware efi64
    .\VBoxManage modifyvm      $OS.name --chipset ICH9 --memory 8192 --cpus 2 --cpuhotplug on --pagefusion on --guestmemoryballoon 4096
    .\VBoxManage modifyvm      $OS.name --pae on --hwvirtex on --acpi on --ioapic on --hpet on --nestedpaging on --paravirtprovider KVM
    .\VBoxManage modifyvm      $OS.name --monitorcount 1 --vrde off --accelerate3d on --accelerate2dvideo off --vram 128 --graphicscontroller vboxsvga
    .\VBoxManage modifyvm      $OS.name --nic1 bridged --nictype1 virtio --nicpromisc1 deny --bridgeadapter1 $NIC[2] --cableconnected2 on
    .\VBoxManage modifyvm      $OS.name --nic2 bridged --nictype2 virtio --nicpromisc2 deny --bridgeadapter2 $NIC[3] --cableconnected2 off
    .\VBoxManage modifyvm      $OS.name --audiocontroller hda --audioout on --usb on --usbehci on --usbxhci on --keyboard usb --mouse usb
    .\VBoxManage modifyvm      $OS.name --largepages on --vtxvpid on --vtxux on # Extra settings for Intel host CPU
    .\VBoxManage modifyvm      $OS.name --bioslogofadein on --bioslogofadeout on --bioslogodisplaytime 2000 
    .\VBoxManage setextradata  $OS.name VBoxInternal2/EfiBootArgs 
    .\VBoxManage setextradata  $OS.name VBoxInternal2/EfiGraphicsResolution 1600x900
    .\VBoxManage setextradata  $OS.name VBoxInternal2/UgaHorizontalResolution 1600
    .\VBoxManage setextradata  $OS.name VBoxInternal2/UgaVerticalResolution    900
    .\VBoxManage setextradata  $OS.name CustomVideoMode1 1600x900x32
    .\VBoxManage setextradata  $OS.name GUI/MaxGuestResolution any
    .\vboxmanage setextradata  $OS.name installdate $(Get-Date)
    .\vboxmanage showvminfo    $OS.name | clip
    .\vboxmanage getextradata  $OS.name enumerate
    Pop-Location

    Write-Host ''
}

function CreateVirtualWindows
{
    Clear-Host ; Write-Host '' ; 
    if ($($PSVersionTable.PSVersion).major -gt 5 ) { Import-Module -Name NetAdapter -SkipEditionCheck }

    $OSList     = @(
                [pscustomobject]@{Name='Windows 7';    Type='Windows7_64';    ISO=$ISOFolder+'Z:\Software\Microsoft\Windows 7\SW_DVD5_Win_Pro_7w_SP1_64BIT_English_-2_MLF_X17-59279.ISO'}
                [pscustomobject]@{Name='Windows 8.1';  Type='Windows81_64';   ISO=$ISOFolder+'Z:\Software\Microsoft\Windows 8.1\debian-live-10.0.0-amd64-mate.iso'}
                [pscustomobject]@{Name='Windows 10';   Type='Windows10_64';   ISO=$ISOFolder+'Z:\Software\Microsoft\Windows 10\Win10_1903_V1_English_x64.iso'}
                [pscustomobject]@{Name='Windows 2016'; Type='Windows2016_64'; ISO=$ISOFolder+'Z:\Software\Microsoft\Windows 2016\en_windows_server_2016_x64_dvd_9718492.iso'}
                )
    $MENU       = @{}
                for ($i=1;$i -le $OSList.count; $i++) { Write-Host "$i. $($OSList.name[$i-1])" $menu.Add($i,($OSList[$i-1])) }
                Write-Host '' ; [int]$selection = Read-Host 'Choose OS Adapter' ; Write-Host '' ; $OS = $menu.Item($selection)
    $NIC        = @( (Get-NetAdapter -Physical | Sort-Object -property name).InterfaceDescription )
    $BaseFolder = "Z:\Virtual Machines\VirtualBox\VirtualBox VMs"
    $Medium     = $BaseFolder + "\" + $OS.name + "\" + $OS.name + ".vdi"
    $LUN_Drives  = 0

    Push-Location "$env:ProgramFiles\Oracle\VirtualBox\"
    .\VBoxManage createvm      --name $OS.name --register --basefolder $BaseFolder --ostype $OS.type
    .\VBoxManage createmedium  --format VDI --variant Standard --size 32768 --filename $Medium
    .\VBoxManage storagectl    $OS.name --name USB  --add usb  --portcount 8 --bootable on --hostiocache on --controller USB 
    .\VBoxManage storagectl    $OS.name --name NVMe --add pcie --portcount 2 --bootable on --hostiocache on --controller NVMe 
    .\VBoxManage storagectl    $OS.name --name SATA --add sata --portcount 2 --bootable on --hostiocache on --controller IntelAHCI
    .\VBoxManage storageattach $OS.name --storagectl SATA --port 0 --device 0 --type hdd --medium $Medium --nonrotational on --discard on
    .\VBoxManage storageattach $OS.name --storagectl USB  --port 0 --device 0 --type dvddrive --medium $OS.iso
    if  ($LUN_Drives -gt 0) 
    {
        .\VBoxManage storagectl  $OS.name --hostiocache on --name SAS  --add sas  --portcount 8 --controller LSILogicSAS
        foreach ($_ in 1..$LUN_Drives)
        {
            $x++ ; $Medium = $BaseFolder + "\" + $OS.name + "\" + $OS.name + " ArrayNode " + $x + ".vdi"
            .\VBoxManage createmedium --format VDI --variant Standard --size 4096 --filename $Medium
            .\VBoxManage storageattach $OS.name --storagectl SAS --port $x --type hdd --medium $Medium --nonrotational on --discard on 
        } 
    }
    .\VBoxManage modifyvm      $OS.name --clipboard bidirectional --draganddrop bidirectional
    .\VBoxManage modifyvm      $OS.name --boot1 dvd --boot2 disk --boot3 none --boot4 none --rtcuseutc on --firmware efi64
    .\VBoxManage modifyvm      $OS.name --chipset ICH9 --memory 8192 --cpus 2 --cpuhotplug on --pagefusion on --guestmemoryballoon 4096
    .\VBoxManage modifyvm      $OS.name --pae on --hwvirtex on --acpi on --ioapic on --hpet on --nestedpaging on --paravirtprovider hyperv
    .\VBoxManage modifyvm      $OS.name --monitorcount 1 --vrde off --accelerate3d on --accelerate2dvideo on --vram 256 --graphicscontroller vboxsvga
    .\VBoxManage modifyvm      $OS.name --nic1 bridged --nictype1 virtio --nicpromisc1 deny --bridgeadapter1 $NIC[2] --cableconnected2 on
    .\VBoxManage modifyvm      $OS.name --nic2 bridged --nictype2 virtio --nicpromisc2 deny --bridgeadapter2 $NIC[3] --cableconnected2 off
    .\VBoxManage modifyvm      $OS.name --audiocontroller hda --audioout on --usb on --usbehci on --usbxhci on --keyboard usb --mouse usb
    .\VBoxManage modifyvm      $OS.name --largepages on --vtxvpid on --vtxux on # Extra settings for Intel host CPU
    #.\VBoxManage modifyvm      $OS.name --mds-clear-on-vm-entry on --l1d-flush-on-vm-entry on --spec-ctrl on --ibpb-on-vm-exit on --ibpb-on-vm-entry on
    .\VBoxManage modifyvm      $OS.name --bioslogofadein on --bioslogofadeout on --bioslogodisplaytime 2000 
    .\VBoxManage setextradata  $OS.name VBoxInternal2/EfiGraphicsResolution 1600x900
    .\VBoxManage setextradata  $OS.name VBoxInternal2/UgaHorizontalResolution 1600
    .\VBoxManage setextradata  $OS.name VBoxInternal2/UgaVerticalResolution    900
    .\VBoxManage setextradata  $OS.name CustomVideoMode1 1600x900x32
    .\VBoxManage setextradata  $OS.name GUI/MaxGuestResolution any
    .\vboxmanage setextradata  $OS.name installdate $(Get-Date)
    .\vboxmanage showvminfo    $OS.name | clip
    .\vboxmanage getextradata  $OS.name enumerate
    Pop-Location

    Write-Host ''
}

function CreateVirtualMac  
{
    Write-Host ''
    if ($($PSVersionTable.PSVersion).major -gt 5 ) { Import-Module -Name NetAdapter -SkipEditionCheck }
    
    $OS         = @( [pscustomobject]@{Name='MacOS Mojave'; Type='MacOS1013_64'; ISO=$ISOFolder+'Z:\Software\macOS\Sierra.iso'} )
    $NIC        = @( (Get-NetAdapter -Physical | Sort-Object -property name).InterfaceDescription )
    $BaseFolder = "Z:\Virtual Machines\VirtualBox\VirtualBox VMs"
    $Medium     = $BaseFolder + "\" + $OS.name + "\" + $OS.name + ".vdi"
 
    Push-Location "$env:ProgramFiles\Oracle\VirtualBox\"
    .\VBoxManage createvm --name $OS.name --register --basefolder $BaseFolder --ostype $OS.type
    .\VBoxManage createmedium          --filename $Medium --size 32768 --format VDI --variant Standard
    .\VBoxManage storagectl    $OS.name --name SATA --add sata --controller IntelAHCI --bootable on --hostiocache on --portcount 2
    .\VBoxManage storageattach $OS.name --storagectl SATA --port 0 --device 0 --type hdd --medium $Medium
    .\VBoxManage storageattach $OS.name --storagectl SATA --port 1 --device 0 --type dvddrive --medium $OS.iso
    .\VBoxManage modifyvm      $OS.name --chipset ich9 --cpus 2 --memory 4096 --accelerate3d on --vram 128 --graphicscontroller vboxvga
    .\VBoxManage modifyvm      $OS.name --nic1 bridged --nictype1 82540EM --nicpromisc1 deny --bridgeadapter1 $NIC[3] --macaddress1 ((Get-NewMacAddress Apple) -replace '-')
    .\VBoxManage modifyvm      $OS.name --firmware efi64 --boot1 dvd --boot2 disk --boot3 none --boot4 none --rtcuseutc on
    .\VBoxManage modifyvm      $OS.name --pae on --paravirtprovider minimal --hwvirtex on --acpi on --ioapic on --hpet on --nestedpaging on --apic on --longmode on
    .\VBoxManage modifyvm      $OS.name --keyboard usb --mouse usbtablet --audiocontroller hda --usb on --usbehci off --usbxhci off
    .\VBoxManage modifyvm      $OS.name --largepages on --vtxvpid on --vtxux on # Extra settings for Intel host CPU
    ### ------------------------------------------------------------------------------------------------------------------
    .\vboxmanage modifyvm      $OS.name --cpuidset 00000001 000106e5 00100800 0098e3fd bfebfbff
    .\vboxmanage setextradata  $OS.name VBoxInternal/Devices/efi/0/Config/DmiSystemProduct "iMac11,3"
    .\vboxmanage setextradata  $OS.name VBoxInternal/Devices/efi/0/Config/DmiSystemVersion "1.0"
    .\vboxmanage setextradata  $OS.name VBoxInternal/Devices/efi/0/Config/DmiBoardProduct "Iloveapple"
    .\vboxmanage setextradata  $OS.name VBoxInternal/Devices/smc/0/Config/DeviceKey "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
    .\vboxmanage setextradata  $OS.name VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC "1"
    #.\VBoxManage setextradata  $OS.name VBoxInternal/Devices/efi/0/Config/DmiSystemProduct ""
    #.\vboxmanage setextradata  $OS.name VBoxInternal/Devices/efi/0/Config/DmiSystemSerial "CSN12345678901234567"
    #.\VBoxManage setextradata  $OS.name VBoxInternal/Devices/efi/0/Config/DmiBoardProduct ""
    ### Tuen off boot debug messages 
    #.\VBoxManage setextradata  $OS.name VBoxInternal2/EfiBootArgs "  "
    ### Tuen on boot debug messages 
    #.\VBoxManage setextradata  $OS.name VBoxInternal2/EfiBootArgs ""
    .\VBoxManage setextradata  $OS.name VBoxInternal2/EfiGraphicsResolution  "1600x900"
    .\VBoxManage setextradata  $OS.name VBoxInternal2/EfiGopMode 4   # 1 =800×600, 2 =1024×768, 3 =1280×1024, 4 =1440×900, 5 =1920×1200
    .\vboxmanage setextradata  $OS.name installdate (get-date)
    .\vboxmanage showvminfo    $OS.name | clip
    .\vboxmanage getextradata  $OS.name enumerate
    Pop-Location
}

function CompactVM 
{
    if ( !$(Get-ChildItem *.vdi).name ) { Write-Host -ForegroundColor red "Cant Find VDI file"  } else 
    { & $env:ProgramFiles\Oracle\VirtualBox\VBoxManage modifymedium $(Get-ChildItem *.vdi).name --compact }
}

function CreateVM ( $Platform )
{
    if ( !$Platform ) { Write-Host -ForegroundColor Yellow "Missing Platform type" ; break } 

    switch ( $Platform )
    {
        Linux    { CreateVirtualLinux   ; break }
        Windows  { CreateVirtualWindows ; break }
        MacOS    { CreateVirtualMac     ; break }
        DDWRT    { CreateVirtualDDWRT   ; break }
        Android  { CreateVirtuaAndroid  ; break }
    }
}

CreateVM
