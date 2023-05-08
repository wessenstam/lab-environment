# Set the IP address of the machine
Write-Host "Setting the IP address"
netsh interface ipv4 set address name="Ethernet0" static 172.31.32.20 255.255.255.0 172.31.32.253

# Setup Runonce and Autologin to lauch the installation of SQL after the restart
Write-Host "Getting ready for SQL Install"
Set-AutoLogon -DefaultUsername "delinealabs\administrator" -DefaultPassword "Delinea/4u"
Set-Location -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
Set-ItemProperty -Path . -Name addDomainUsers -Value 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe "c:\Scripts\Users_Grps.ps1"'

# Join the domain
$joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
    UserName = delinealabs/Administrator
    Password = (ConvertTo-SecureString -String 'Delinea/4u' -AsPlainText -Force)[0]
})
Add-Computer -DomainName "delinealabs.com" -Options UnsecuredJoin,PasswordPass -Credential $joinCred -Restart -Force