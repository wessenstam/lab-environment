Write-Host "Adding computer to the domain..."
$hostname=(Get-Content Env:COMPUTERNAME).ToLower()
switch ($hostname){
    'app' {
            $sql=$true
        }
    'endpoint' {
            $sql=$false
        }
}


# Setup Runonce and Autologin to lauch the installation of SQL after the restart
if ($sql){
    Write-Host "Getting ready for SQL Install"
    $RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value "1" -Type String 
    Set-ItemProperty $RegistryPath 'DefaultUsername' -Value "delinealabs\administrator" -type String 
    Set-ItemProperty $RegistryPath 'DefaultPassword' -Value "Delinea/4u" -type String
    Set-Location -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
    Set-ItemProperty -Path . -Name addDomainUsers -Value 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe "c:\Scripts\sql_install.ps1"'
}


# Join the domain
$joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
    UserName = 'Administrator'
    Password = (ConvertTo-SecureString -String 'Delinea/4u' -AsPlainText -Force)[0]
})
Add-Computer -DomainName "delinealabs.com" -Credential $joinCred -Restart -Force