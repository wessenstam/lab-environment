Write-Host "Installing Microsoft SQL Server 2017 Developer Edition..."
# Download the SSMS
#$url="https://aka.ms/ssmsfullsetup"
#$destination="$Env:temp\smsfullsetup.exe"
#Invoke-Webrequest -Uri $url -OutFile $destination

# Download and install the SQL Server Developer 2017 version
#$url="https://d2qljt6m66vn62.cloudfront.net/SQLServer2017-x64-ENU-Dev.iso"
#$destination="$Env:temp\SQLServer2017-x64-ENU-Dev.iso"
#Invoke-Webrequest -Uri $url -OutFile $destination

# Mount and install the SQL Server
$SQL_Drive=(mount-diskimage "C:\Scripts\SQLServer2017-x64-ENU-Dev.iso" | Get-Volume).DriveLetter
Start-Process -FilePath $SQL_Drive":\setup.exe" -ArgumentList "/ConfigurationFile=C:\Scripts\sql_config.ini" -Wait

Write-Host "Installing Microsoft SQL Server Management Studio 19.0.2..."
# Install the SSPM
Start-Process -FilePath "C:\Scripts\smsfullsetup.exe" -ArgumentList "/Install","/Passive","/norestart" -Wait

# Cleanup
Write-Host "Cleaning up..."
Dismount-DiskImage -ImagePath "C:\Scripts\SQLServer2017-x64-ENU-Dev.iso"
Remove-Item -Path "C:\Scripts\SQLServer2017-x64-ENU-Dev.iso"
Remove-Item -Path "C:\Scripts\smsfullsetup.exe"
$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value "0" -Type String 

# Restart the server due to SSMS installation
Restart-Computer