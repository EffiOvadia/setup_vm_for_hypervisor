Stop-VM -Name 'Debian 12' -Force
Save-VM -Name 'Debian 12'
Get-VM -Name Ubuntu* | Save-VM
Checkpoint-VM -Name 'Debian 12' -SnapshotName Update1
Get-VMSnapshot -VMName 'Debian 12'
Get-VMIntegrationService -VMName 'Debian 12'
Enable-VMIntegrationService -VMName 'Debian 12' -Name 'Guest Service Interface'

Hyper-V Heartbeat Service
Windows Service Name: vmicheartbeat
Linux Daemon Name: hv_utils

Hyper-V Guest Shutdown Service
Windows Service Name: vmicshutdown
Linux Daemon Name: hv_utils

Hyper-V Time Synchronization Service
Windows Service Name: vmictimesync
Linux Daemon Name: hv_utils

Hyper-V Data Exchange Service (KVP)
Windows Service Name: vmickvpexchange
Linux Daemon Name: hv_kvp_daemon

Hyper-V Volume Shadow Copy Requestor
Windows Service Name: vmicvss
Linux Daemon Name: hv_vss_daemon

Hyper-V Guest Service Interface
Windows Service Name: vmicguestinterface
Linux Daemon Name: hv_fcopy_daemon
Copy-VMFile "Test VM" -SourcePath "D:\Test.txt" -DestinationPath "C:\Test.txt" -CreateFullPath -FileSource Host

Hyper-V PowerShell Direct Service
Windows Service Name: vmicvmsession
Linux Daemon Name: n/a

#! Check integration service within a Windows guest
Get-Service -Name vmic* | FT -AutoSize
Get-Service -Name vmic* | Restart-Service 

Set-Service -Name vmicguestinterface -StartupType Automatic ; Restart-Service -Name vmicguestinterface
Set-Service -Name vmicheartbeat -StartupType Automatic ; Restart-Service -Name vmicheartbeat
Set-Service -Name vmickvpexchange -StartupType Automatic ; Restart-Service -Name vmickvpexchange  
Set-Service -Name vmicrdv -StartupType Automatic ; Restart-Service -Name vmicrdv 
Set-Service -Name vmicshutdown -StartupType Automatic ; Restart-Service -Name vmicshutdown 
Set-Service -Name vmictimesync -StartupType Automatic ; Restart-Service -Name vmictimesync 
Set-Service -Name vmicvmsession -StartupType Automatic ; Restart-Service -Name vmicvmsession
Set-Service -Name vmicvss -StartupType Automatic ; Restart-Service -Name vmicvss 



Set-VMVideo -VMName 'Debian 12' -HorizontalResolution 1920 -VerticalResolution 1080


$vm = 'Debian 12'

Remove-VMGpuPartitionAdapter -VMName $vm
Add-VMGpuPartitionAdapter -VMName $vm
Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionVRAM 1
Set-VMGpuPartitionAdapter -VMName $vm -MaxPartitionVRAM 500000000
Set-VMGpuPartitionAdapter -VMName $vm -OptimalPartitionVRAM 499999999
Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionEncode 1
Set-VMGpuPartitionAdapter -VMName $vm -MaxPartitionEncode 9223372036854775807
Set-VMGpuPartitionAdapter -VMName $vm -OptimalPartitionEncode 9223372036854775807
Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionDecode 1
Set-VMGpuPartitionAdapter -VMName $vm -MaxPartitionDecode 500000000
Set-VMGpuPartitionAdapter -VMName $vm -OptimalPartitionDecode 499999999
Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionCompute 1
Set-VMGpuPartitionAdapter -VMName $vm -MaxPartitionCompute 500000000
Set-VMGpuPartitionAdapter -VMName $vm -OptimalPartitionCompute 499999999
Set-VM -GuestControlledCacheTypes $true -VMName $vm
Set-VM -LowMemoryMappedIoSpace 1Gb -VMName $vm
Set-VM -HighMemoryMappedIoSpace 32GB -VMName $vm