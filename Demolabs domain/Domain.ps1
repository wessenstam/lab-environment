# Set the IP address of the machine
Write-Host "Setting the IP address"
netsh interface ipv4 set address name="Ethernet0" static 172.31.32.10 255.255.255.0 172.31.32.253


# Installing the AD
Write-Host "Installing Active Directory"
Add-WindowsFeature AD-Domain-Services -IncludeManagementTools
$password=ConvertTo-SecureString "Delinea/4u" -AsPlainText -Force
Install-ADDSForest -DomainName delinealabs.com -DomainMode 7 -ForestMode 7 -InstallDNS -SafeModeAdministratorPassword $password -Force -NoRebootOnCompletion
Install-WindowsFeature AD-Certificate
Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA

# Add DNS Forwarder to DNS Server
Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru

# Setup Runonce and Autologin to lauch the Add Groups and Users
Write-Host "Getting ready for next phase"
Set-AutoLogon -DefaultUsername "delinealabs\administrator" -DefaultPassword "Delinea/4u"
Set-Location -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
Set-ItemProperty -Path . -Name addDomainUsers -Value 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe "c:\Scripts\Users_Grps.ps1"'

Restart-Computer