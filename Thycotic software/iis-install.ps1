# This script installs IIS and the features required to
# run West Wind Web Connection.
#
# * Make sure you run this script from a Powershel Admin Prompt!
# * Make sure Powershell Execution Policy is bypassed to run these scripts:
# * YOU MAY HAVE TO RUN THIS COMMAND PRIOR TO RUNNING THIS SCRIPT!
Set-ExecutionPolicy Bypass -Scope Process

# Disable Server Manager
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask -Verbose

# Install IIS and its needed components
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect
Enable-WindowsOptionalFeature -Online -FeatureName IIS-StaticContent
Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument


Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionDynamic

Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestFiltering
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication

Enable-WindowsOptionalFeature -online -FeatureName NetFx4Extended-ASPNET45
Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter

Enable-WindowsOptionalFeature -Online -FeatureName IIS-HealthAndDiagnostics
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpLogging

Enable-WindowsOptionalFeature -Online -FeatureName IIS-Security

Enable-WindowsOptionalFeature -Online -FeatureName IIS-Performance
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementConsole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementScriptingTools

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45

Enable-WindowsOptionalFeature -Online -FeatureName WCF-Services45
Enable-WindowsOptionalFeature -Online -FeatureName WAS-WindowsActivationService
Enable-WindowsOptionalFeature -Online -FeatureName WAS-ProcessModel
Enable-WindowsOptionalFeature -Online -FeatureName WAS-ConfigurationAPI
Enable-WindowsOptionalFeature -Online -FeatureName WCF-HTTP-Activation45
Enable-WindowsOptionalFeature -Online -FeatureName WCF-TCP-Activation45
Enable-WindowsOptionalFeature -Online -FeatureName WCF-TCP-PortSharing45

# Get the HTTPS Binding and SelfSigned Certificate done for IIS
$fqdn = "$((Get-WmiObject win32_computersystem).DNSHostName).$((Get-WmiObject win32_computersystem).Domain)" 
$cert=(Get-ChildItem cert:\LocalMachine\My | where-object { $_.Subject -match "CN=$fqdn" } | Select-Object -First 1) 
if ($cert  -eq $null) { 
$cert = New-SelfSignedCertificate -DnsName $fqdn -CertStoreLocation "Cert:\LocalMachine\My" 
} 
$binding = (Get-WebBinding -Name "Default Web Site" | where-object {$_.protocol -eq "https"})
if($binding -ne $null) {
    Remove-WebBinding -Name "Default Web Site" -Port 443 -Protocol "https" -HostHeader $fqdn
} 
New-WebBinding -Name "Default Web Site" -Port 443 -Protocol https -HostHeader $fqdn 
(Get-WebBinding -Name "Default Web Site" -Port 443 -Protocol "https" -HostHeader $fqdn).AddSslCertificate($cert.Thumbprint, "my") 


# Download and Install .NET 4.8 framework
cd C:\Windows\Temp
wget https://go.microsoft.com/fwlink/?linkid=2088631 -UseBasicParsing -outfile ndp48-x86-x64-allos-enu.exe


# Install .NET 4.8 Framework
./ndp48-x86-x64-allos-enu.exe /q 
