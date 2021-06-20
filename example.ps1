#ps1
#set login Admin password (default Root123)
net user Administrator Root123
#enabe guest user
net user guest /active:yes
#Disable Enhanced Security in Internet Explorer (to allow curl request)
function Disable-IEESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
    }
Disable-IEESC
#remove wrong gateway, and bypass confirmation step
Remove-NetRoute -NextHop "10.60.60.1" -Confirm:$false
#disable New Network Window
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff /f
#disable firewall
netsh advfirewall set allprofiles state off
#create directory/file 
New-Item -ItemType directory -Path C:\Users\Administrator\Documents\MaybeHere
For ($i=1; $i -le 10; $i++) {
    New-Item -ItemType directory -Path C:\Users\Administrator\Documents\OrHere-$i
    New-Item -ItemType file -Path C:\Users\Administrator\Documents\OrHere-$i\README.txt
    "well it's not here " | Out-File -FilePath "C:\Users\Administrator\Documents\OrHere-$i\README.txt"
    }
'I am here!' | Out-File -FilePath 'C:\Users\Administrator\Documents\OrHere-8\README.txt'
#install file server role (for smb)
Install-WindowsFeature File-Services
#configure SMB share
New-SmbShare -Name "LablabeeShare" -Path "C:\Users\Administrator\Documents\Share" -FullAccess "Everyone"
#disable need to run Internet Explorer's first launch configuration
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 2
#allow ssh, needs openssh installed
New-NetFirewallRule -Protocol TCP -LocalPort 22 -Direction Inbound -Action Allow -DisplayName SSH
#notify heat
$name= hostname
$data= "{`"status`": `"SUCCESS`", `"reason`": `"$name`"}"
Invoke-WebRequest `
-Headers @{"X-Auth-Token" = "token"} -Method POST -Body "$data" `
-Uri "endpoint" -UseBasicParsing -ContentType application/json
#clear logs
Clear-Content 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\cloudbase-init.log'
