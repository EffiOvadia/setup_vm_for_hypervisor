$VMName  = "Debian"

$Link    = 'https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/'
$Page    = Invoke-WebRequest -Uri $link
$ISOname = $Page.Links | Where-Object { $_.href -like "*-netinst.iso" } | Select-Object -First 1 -ExpandProperty href
$URI     = $Link + $ISOname

Invoke-WebRequest -Uri $URI -OutFile $env:userprofile\Downloads\$VMName.iso

$VM = @{
  Name = $VMName
  Generation = 2
  MemoryStartupBytes = 4GB
  SwitchName = "Default Switch"
  NewVHDPath = "$VMName.vhdx"
  NewVHDSizeBytes = 64GB
  BootDevice = "VHD"
  }

New-VM @VM

Set-VM -Name $VMName -DynamicMemory 
Set-VM -Name $VMName -ProcessorCount 2 
Set-VM -Name $VMName -CheckpointType Disabled
Set-VM -Name $VMName -AutomaticStopAction Shutdown
Set-VM -Name $VMName -EnhancedSessionTransportType HVSocket
Enable-VMIntegrationService -VMName $VMName -Name "Guest Service Interface"
Set-VMFirmware -VMName $VMName -EnableSecureBoot Off


Add-VMDvdDrive -VMName $VMName -ControllerNumber 0 -Path $env:userprofile\Downloads\$VMName.iso
Set-VMFirmware -VMName $VMName -BootOrder $(Get-VMDvdDrive -VMName $VMName), $(Get-VMHardDiskDrive -VMName $VMName)

if ( $(Get-VM -Name $VMName).state -eq 'Off' ) { Start-VM -Name $VMName }

#Optimize-VHD -Path ".\$VMName.vhdx" -Mode Retrim 