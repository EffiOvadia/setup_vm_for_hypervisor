#Requires -RunAsAdministrator
#Requires -Modules Hyper-V

$Name = "Debian"
$Description = "Debian Stable 

- - - - - - - - - - - - - - - - - -

Username: user
Password: P@ssw0rd

- - - - - - - - - - - - - - - - - -
"

New-VHD -Path ".\$Name.vhdx" -Dynamic -SizeBytes 64GB

New-VM `
  -Generation 2 `
  -Name "$Name" `
  -MemoryStartupBytes 4096MB `
  -SwitchName "Default Switch" `
  -VHDPath ".\$Name.vhdx"

Set-VM -Name "$Name" -Notes "$Description"
Set-VM -Name "$Name" -EnhancedSessionTransportType HVSocket
Set-VMFirmware -VMName "$Name" -EnableSecureBoot Off
Set-VMProcessor -VMName "$Name" -Count 2
Enable-VMIntegrationService -VMName "$Name" -Name "Guest Service Interface"
Set-VMDvdDrive -VMName DC -ControllerNumber 1 -Path ".\$Name.iso"


if ( $(Get-VM –Name ubuntu).state -eq "Off" ) { Start-VM –Name "$Name" }


#Optimize-VHD -Path ".\$Name.vhdx" -Mode Retrim 
