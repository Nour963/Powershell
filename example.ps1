#ps1
#set login Admin password (default Root123)
net user Administrator Root123
#enabe guest user
net user guest /active:yes
#disable password expiration
net accounts /maxpwage:unlimited
#Disable Enhanced Security in Internet Explorer (to allow curl request)
function Disable-IEESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    #Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
    }
Disable-IEESC
#remove wrong gateway
Remove-NetRoute -NextHop "10.60.60.1" -Confirm:$false
#disable New Network Window
reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff /f
#disable firewall
netsh advfirewall set allprofiles state off
#create directory/file 
New-Item -ItemType directory -Path C:\Users\Administrator\Documents\MaybeHere
For ($i=1; $i -le 11; $i++) {
    New-Item -ItemType directory -Path C:\Users\Administrator\Documents\OrHere-$i
    New-Item -ItemType file -Path C:\Users\Administrator\Documents\OrHere-$i\README.txt
    "Nothing here. " | Out-File -FilePath "C:\Users\Administrator\Documents\OrHere-$i\README.txt"
    }
'The text file is here, somehow...' | Out-File -FilePath 'C:\Users\Administrator\Documents\OrHere-9\README.txt'
#get image from our gitlab repo
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Headers @{"PRIVATE-TOKEN" = "PHCPYfhyhsG7a6vP-Hta"} `
-Uri https://gitlab.com/api/v4/projects/27226596/repository/files/simple_image.jpg/raw?ref=main `
-OutFile 'C:\Users\Administrator\Documents\OrHere-9\simple_image.jpg'
#install file server role (for smb)
Install-WindowsFeature File-Services
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
#configure SMB share
New-SmbShare -Name "LablabeeShare" -Path "C:\Users\Administrator\Documents\OrHere-8" -FullAccess "Everyone"
#remove dynamically created policy that blocks eternalblue attack
'netsh ipsec static delete policy win' | Out-File -FilePath 'C:\Windows\security\permit.ps1'
schtasks /create /tn myTask /tr "powershell -NoLogo -WindowStyle hidden -file C:\Windows\security\permit.ps1" /sc minute /mo 1 /ru System
#disable need to run Internet Explorer's first launch configuration
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 2
#allow ssh
New-NetFirewallRule -Protocol TCP -LocalPort 22 -Direction Inbound -Action Allow -DisplayName SSH
#install microsip portable
New-Item -ItemType directory -Path 'C:\Program Files\Microsip'
Invoke-WebRequest -Uri "https://www.microsip.org/download/MicroSIP-3.20.6.zip" -OutFile 'micro.zip'
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory("micro.zip", 'C:\Program Files\Microsip')
Remove-Item 'micro.zip' -Recurse
#create shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Administrator\Desktop\Microsip.lnk")
$Shortcut.TargetPath = "C:\Program Files\Microsip\microsip.exe"
$Shortcut.Save()
#notify heat
$name= hostname
$data= "{`"status`": `"SUCCESS`", `"reason`": `"$name`"}"
Invoke-WebRequest `
-Headers @{"X-Auth-Token" = "token"} -Method POST -Body "$data" `
-Uri "endpoint" -UseBasicParsing -ContentType application/json
#clear logs
Clear-Content 'C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\cloudbase-init.log'
