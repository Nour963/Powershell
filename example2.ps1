#ps1
Import-Module RemoteDesktop
$hostt = hostname
$fqdn = (echo "$hostt.example.com")
New-RDSessionDeployment -ConnectionBroker $fqdn -WebAccessServer $fqdn -SessionHost $fqdn
Add-RDServer -Server $fqdn -Role RDS-GATEWAY -ConnectionBroker $fqdn -GatewayExternalFqdn $fqdn
New-RDSessionCollection -CollectionName "Quick" -SessionHost $fqdn -ConnectionBroker $fqdn
New-RDRemoteApp -CollectionName "Quick" -DisplayName "Desktop" -FilePath "C:\Windows\System32\mstsc.exe"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -Force
Install-Module -Name PowerShellGet -Force
Install-Module -Name RDWebClientManagement -Force -AcceptLicense
Install-RDWebClientPackage
$localIpAddress=((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
$cert = New-SelfSignedCertificate -Subject $localIpAddress -TextExtension @("2.5.29.17={text}DNS=$localIpAddress7&IPAddress=127.0.0.1&IPAddress=$localIpAddress")
$idd = $cert | Select-Object -ExpandProperty Thumbprint
$Path = 'C:\tstcert.pfx'
Export-Certificate -Cert Cert:\LocalMachine\My\$idd -FilePath $Path
Import-RDWebClientBrokerCert $Path
Publish-RDWebClientPackage -Type Production -Latest
Set-RDCertificate -Role RDGateway -ImportPath $Path -ConnectionBroker $fqdn -Force
