# ----------------------------------------------------------------------
## Set / Delete pagefile
Set-CimInstance -Query "SELECT * FROM Win32_ComputerSystem" -Property @{AutomaticManagedPagefile="False"}
#Set-CimInstance -Query "SELECT * FROM Win32_PageFileSetting" -Property @{InitialSize=128; MaximumSize=1024}
(Get-WmiObject -Class Win32_PageFileSetting).Delete() 
# ----------------------------------------------------------------------
#Restart-Computer -Force
# ----------------------------------------------------------------------
Enable-LocalUser -name "Administrator" 
Set-LocalUser    -Name "Administrator" -Password (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)
if ($env:UserName -ne "Administrator" ) { Logoff }
# ----------------------------------------------------------------------
if  ( (Get-CimInstance Win32_Operatingsystem | Select-Object -expand Caption) -like "*Windows 10*") 
  { Compact ; Compact /CompactOS:Query ; Compact /CompactOS:always }
# ----------------------------------------------------------------------
## Cleanup files
DISM.exe /online /Cleanup-Image /AnalyzeComponentStore
DISM.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
DISM.exe /online /Cleanup-Image /SPSuperseded
# ----------------------------------------------------------------------
#Get-ChildItem $env:SystemDrive -Filter *$Get* -hidden | Remove-Item -Recurse -Force | out-null
# ----------------------------------------------------------------------
## Clearing CleanMgr.exe automation settings
Push-Location -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches'
Get-ItemProperty '.\*' -Name StateFlags0001 -ErrorAction SilentlyContinue | Remove-ItemProperty -Name StateFlags0001 -ErrorAction SilentlyContinue
  $Keys = 
      @(
        ".\Downloaded Program Files",
        ".\Internet Cache Files",
        ".\Memory Dump Files",
        ".\Old ChkDsk Files",
        ".\Previous Installations",
        ".\Recycle Bin",
        ".\Service Pack Cleanup",
        ".\Setup Log Files",
        ".\System error memory dump files",
        ".\System error minidump files",
        ".\Temporary Files",
        ".\Temporary Setup Files",
        ".\Thumbnail Cache",
        ".\Update Cleanup",
        ".\Upgrade Discarded Files",
        ".\Windows Error Reporting Archive Files",
        ".\Windows Error Reporting Queue Files",
        ".\Windows Error Reporting System Archive Files",
        ".\Windows Error Reporting System Queue Files",
        ".\Windows Upgrade Log Files" 
      )
  foreach ($key in $Keys ) { if ( Test-Path $Key ) { New-ItemProperty $Key -Name StateFlags0001 -Value 2 -PropertyType DWord } }
Pop-Location
Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:1' -WindowStyle Hidden -Wait
Get-Process -Name cleanmgr,dismhost -ErrorAction SilentlyContinue | Wait-Process
# ----------------------------------------------------------------------
## Start Optimizing
if  ( (Get-CimInstance Win32_Operatingsystem | Select-Object -expand Caption) -like "*Windows 10*" ) 
      { 
        fsutil behavior set DisableDeleteNotify NTFS 1 
        fsutil behavior set DisableDeleteNotify ReFS 1
        Get-PhysicalDisk | Set-PhysicalDisk -MediaType HDD
        Optimize-Volume -DriveLetter ((get-location).Drive.Name) -NormalPriority -Defrag 
      } elseif  
    ( (Get-CimInstance Win32_Operatingsystem | Select-Object -expand Caption) -like "*Windows 7*" ) 
      { 
        Start-Process -FilePath Defrag.exe -ArgumentList "/H /U /X /V $env:SYSTEMDRIVE" -NoNewWindow -Wait 
      }
# ----------------------------------------------------------------------
## Update SDelete
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
$URI = "https://download.sysinternals.com/files/SDelete.zip"
Invoke-WebRequest "$URI" -outfile "$env:temp\SDelete.zip" -passthru -UseBasicParsing | Select-Object -Expand headers
Expand-Archive -Force -path $env:temp\SDelete.zip -DestinationPath "$env:temp" ; Remove-Item -path $env:temp\SDelete.zip 
Move-Item -Path "$env:temp\sdelete64.exe" -Destination "$env:WINDIR\system32\sdelete64.exe" -Force
## Run SDelete
Start-Process -FilePath SDelete64.exe -ArgumentList "$env:SystemDrive -z -nobanner" -NoNewWindow -Wait
# ----------------------------------------------------------------------
#Start-Process -FilePath $env:WINDIR\system32\sysprep\Sysprep -ArgumentList "/generalize /oobe /shutdown /mode:vm" 
# ----------------------------------------------------------------------
Stop-Computer -Force
