# Detailed building guide

This guide will provide all detailed information on the building of the LAB/Demo environments. It will NOT provide any licenses, just some URLs where the needed software can be downloaded. It will provide detailed steps on how the software is installed, supported (if needed) with screenshots.

## Pre-requisites

To build the environment the following pre-requisites are needed in knowledge and software:

- Basic knowledge

    - Microsoft Windows Server and Workstation
    - Active Directory installation and configuration
    - Linux, CentOS including [vi](https://www.guru99.com/the-vi-editor.html)

- Network

    - 1 network for the Windows Domain, including two of the Linux machines
    - 1 network for the devops related machines. This network is separate from the the first network to mimic Cloud instances
    - Both network MUST have internet connectivity, but no routing between them is needed

- Operating systems

    - Windows 2016 installation media (https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2016)
    - SQL Server 2016 (Developer version is allowed https://www.microsoft.com/en-us/evalcenter/evaluate-sql-server-2016) installation media
    - CentOS 7 or 8 installation media (the guide uses version 7 - https://www.centos.org/download/)

- Hyper-Visor of choice. Lab guide has been built and tested on VMware ESXi 7.0
- Internet connectivity for all VMs
- Extra software:

    - PuTTY (https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
    - SQL Management Studio (https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
    - .NET 4.8 installation (https://go.microsoft.com/fwlink/?linkid=2088631)
    - Centrify Cloud Tenant (\<tenant>.my.centrify.net. request via ThycoticCentrify SE)
    - Centrify Server Suite Software (request via ThycoticCentrify SE)
    - Google Chrome and/or Firefox browser

- Extra configuration for All Windows 2016 Server machines

	- Add all servers to the greensafe.lab domain
	- Disable the firewall
	- Set Google Chrome as the default browser where it needs to be installed
	- Disable the Server Manager start up at boot time
	- Remove IE from the taskbar
	- Run Windows Updates on all machines


**PRO TIP** 

Create a Windows 2016 syspreped template and use to build the all needed Windows machines. Have to template pre-installed with:
- Windows Update ran
- Chrome
- PuTTY

<BR/><BR/>
# DC-Server

The lab needs a AD Domain Controller with the name **dc-server**. This part of the preparation is setting this up.
## Hardware components:

- 2 vCPUs
- 4 GB RAM
- 30 GB HDD

## Installation

- Create a Active Directory Domain named **greensafe.lab**
- After domain has been created:

    - Copy the content of *[users.csv](https://raw.githubusercontent.com/wessenstam/lab-environment/main/Centrify%20software/users.csv)* in a file called users.csv onto the machine to a location in the AD VM
    - Copy the following script content *[Greensafe-lab-OU-Groups-Users.ps1](https://raw.githubusercontent.com/wessenstam/lab-environment/main/Centrify%20software/Greensafe-lab-OU-Groups-Users.ps1)* to the same location as the users.csv and name it AD-Objects.ps1. Change, if needed, the default password (*Centr1fy*) to something else. Just remember to tell others about the new set password as that is not what is used in the lab guide.
    - Open a Powershell and CD to the location of the two files
    - Run the the Powershell command to let the script create the AD Objects.

<BR/><BR/>

# DB-server

This server will provide the SQL database instance needed for the lab/demo environment and is **member of the greensafe.lab domain**.

## Hardware

- 4 vCPU
- 8 GB RAM
- 60 GB HDD

## Extra software

- .NET 4.8 installer (https://go.microsoft.com/fwlink/?linkid=2088631)
- [SQL 2008-2016 (test 2017 Developer!?)](https://download.microsoft.com/download/5/A/7/5A7065A2-C81C-4A31-9972-8A31AC9388C1/)
- [SQL 2017 Reporting Service](https://www.microsoft.com/en-us/download/details.aspx?id=55252)
 
- SQL Management Studio (https://aka.ms/ssmsfullsetup)

## SQL server

During the installation of the SQL server a few configuration options *must* be selected:
1. Database Engine Services
2. Client Tools Connectivy
3. Install a default SQL with a *Named Instance* named **CENTRIFY**
4. Leave the *Windows authentication mode* and add the **greensafe\Domain Admins** as the SQL Server Administrator using the **Add...** button
5. Open the **SQL Server Configuration Manager**
6. Select *SQL Server Network Configuration*
7. Under the *Protocol* tab, double-click **TCP/IP** and set **Enabled** to **Yes**
8. Under the *IP Addresses* Tab, make sure port **1433** is mentioned on all IP Addresses and is the IP address is *Enabled* **Yes**
9. Click **OK** twice
10. Start the **SQL Browser Agent** service by setting it to *Automatic*
10. Restart the server


## SQL Reporting Services

Back at the SQL installation, click SQL Reporting Services. This will open a webpage to [SQL 2017 Reporting Service](https://www.microsoft.com/en-us/download/details.aspx?id=55252). Download and execute the downloaded file, select the Developer edition. after the installation a Restart is required. Extra configuration steps

1. Start the Report Server Configuration Manager
2. Accept the default SSRS instance
3. Under *Database*, click **Change Database**
4. **Create a new report server database** and click **Next**
5. Click **Next**
6. *Database Name* **Reportserver$CENTRIFY** and click **Next**
7. Click **Next**
8. Click **Next**
9. Click **Finish**

After this, the URLs have to be defined

1. Under *Web Service URL* set the Virtual Directory to *ReportServer_CENTRIFY*
2. Click **Apply** and wait till all is ready
3. Under *Web Portal URL* set the Virtual Directory to *Reports_CENTRIFY*
4. Click **Apply** and wait till all is ready

## SQL Management Studio

Download and install the SQL Management Studio on the **db-server**

<BR/><BR/>
# Apps-server

The lab will be mostly run from this server, so some parts have to be installed and prepared and **is member of the greensafe.lab domain**.

## Hardware

- 4 vCPU
- 8 GB RAM
- 30 GB HDD

## Extra software

- PuTTY (https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
- WinSCP (https://winscp.net/eng/downloads.php)
- Windows Adminstrative Tools (https://www.hammer-software.com/how-to-install-remote-server-administration-tools-rsat-on-windows-server-2016/)
- Group Policy Management (https://helpcenter.netwrix.com/NA/Third_party/GPMC.html)

## Configuration

- PuTTY shortcut on the desktop
- WinSCP shortcut on the desktop
- GPO editor shortcut on the desktop and pinned to the taskbar 
- Services shortcut on the desktop and pinned to the taskbar
- Google Chrome shortcut on the desktop and pinned to the taskbar (https://www.google.com/chrome/?standalone=1)
- Active Directory Users and Computers shortcut on the desktop and pinned to the taskbar

# Final Domain configuration

After all steps have been run, disable the Windows Update using the Group Policy Editor

1. Log into the dc-server using a Domain Admin account (Administrator or afoster)
1. Open the **Group Policy Manager** under *Windows Administrative Tools*
2. Expand *Domains > greensafe.lab*  
3. Right-click **Default Domain Policy** and select **Edit...**
4. Navigate to *Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Update*
5. Double-click on **Configure Automatic Updates** select **Disabled** and click **OK**
6. Close all open Windows and log out

---
# devops-windows

This Windows 2016 machine is not part of the domain and in another Network IP Range. It will be used in the lab as Connector and to remote control into its network.

## Hardware

- 2 vCPUs
- 4 GB RAM
- 30 GB HDD

## Extra software

- PuTTY on desktop
- Chrome on desktop

## Extra configuration

- Run in a Elevated CMD prompt the following commands

```bash
   net user afoster-a Centr1fy /add /FULLNAME:"Alex Foster" /comment:"Alternate Admin Account"
   net user helpdesk-a Centr1fy /add /FULLNAME:"Helpdesk Admin" /comment:"Admin Account"
   net localgroup Administrators afoster-a /add
   net localgroup Administrators helpdesk-a /add

```
<BR/><BR/>

# Linux machines

The three Linux machines are based on the CentOS 7 distribution. Download the minimum iso (approx. 1GB) from http://isoredirect.centos.org/centos/7/isos/x86_64/.


**PRO TIP**

Build one Linux machine and then clone it for the other two, make the needed changes to speed up the creation of the three Linux boxes. **Stop at the creation of the users as they are dependent on the Linux Machine**.

## Hardware

Two out of the three Linux machines have the same hardware requirement. The last one (devops-unix) is smaller in size.
### apps-unix and db-unix

- 2 vCPUs
- 4GB RAM
- 30 GB HDD

### devops-unix

- 1 vCPU
- 1 GB RAM
- 30 GB HDD

## Installation steps

Install CentOS as a minimum installation using the downloaded ISO file. For the **root** password use **password1**
## Post O/S installation

### General steps for all three Linux machines

After the installation of the CentOS 7 O/S the following needs to be installed and configured for all three Linux machines:

- Set *ONBOOT=yes* in **/etc/sysconfig/network-scripts/ifcfg-\<NICNAME>** so the NIC activates on boot
- Run the following commands

    - ``yum update -y``
	- ``yum install -y net-tools open-vm-tools``

- Use ``hostnamectl set-hostname \<hostname>`` to set the correct hostname
- Change the ``/etc/hosts`` file to correspond to the correct name using ``vi /etc/hosts``
- Reboot the Linux machine
- After the first reboot your server should now have the correct hostname, use ``hostnamectl`` to check
- The Linux machine wil now be accessible via SSH for ease of configuration, open a SSH session using your the application of your choice to the Linux machine.
- Set the IP address of the Linux machine to static using [this article](https://www.cyberciti.biz/faq/howto-setting-rhel7-centos-7-static-ip-configuration/). **The used network-card (eth0) might be different on your Linux machine!!**
- Use the below table for the IP addresses for the Linux machines when using them against the Lab guides

  | Linux Machine | IP address | Pre-Fix |
  |---------------|------------|---------|
  | apps-unix     | 10.0.0.30  | 24 |
  | db-unix       | 10.0.0.35  |24 | 
  | devops-unix   | Free of choice | Your subnet |

- Use ``systemctl restart network`` to restart the network. You might loose the ssh session!!!
- Edit the DNS resolving via ``vi /etc/resolv.conf``
- Add two lines:

  1. nameserver 10.0.0.1
  2. search greensafe.lab

- Save the file
- To test type ``ping dc-server.greensfae.lab`` a reply should be given.
  
- CentOS Machines need to have the repo for Centrify Agents added. Run the following commands
- Create a file using ``vi /etc/yum.repos.d/centrify-rpm-redhat.repo``
- Copy the below content in the file

```bash
	# Source: CENTRIFY
	# Repository: CENTRIFY / rpm-redhat
	# Description: YUM repository for RedHat packages (.rpm)
	
	[centrify-rpm-redhat]
	name=centrify-rpm-redhat
	baseurl=https://cloudrepo.centrify.com/Cv3R5EV0RGRwJ21M/rpm-redhat/rpm/el/7/$basearch
	repo_gpgcheck=1
	enabled=1
	gpgkey=https://cloudrepo.centrify.com/Cv3R5EV0RGRwJ21M/rpm-redhat/cfg/gpg/gpg.BDD3FD95B65ECA48.key
	gpgcheck=1
	sslverify=1
	sslcacert=/etc/pki/tls/certs/ca-bundle.crt
	metadata_expire=300
	pkg_gpgcheck=1
	autorefresh=1
	type=rpm-md	
```
```
**NOTE**

URL for the documented details:  https://docs.centrify.com/Content/inst-depl/AgentsOptionsNativeInstall.htm. To get a TOKEN click the Set Me Up as shown below on https://thycotic.force.com/centrifysupport/CentrifyRepo. To check the Centrify Repo can be accessed, type ``yum list Centrify*`` this should return some Centrify results. If you get an error, there will be an issue in the repo file you created.
```
### Extra configuration/installation for apps-unix and db-unix

- Add users, password, their  special groups, home dir (if not \/home\/\<username>) and shell (if not /bin/bash) use ``useradd -m -G wheel <USERNAME>``
	- afoster-a, Centr1fy, wheel (**on db-unix only!!!**)
    - cfyadmin, Centr1fy, wheel
	- heldesk-a, Centr1fy, wheel
	- kim, Centr1fy
	- sam, Centr1fy

	- Use the following commands to get the users in the system:

		```bash
		for name in "afoster-a" "cfyadmin" "heldesk-a";do adduser -m -G wheel $name; echo -e "Centr1fy\nCentr1fy" | passwd $name; done
		```
	  and
	  	```bash
		for name in "kim" "sam";do adduser -m $name; echo -e "Centr1fy\nCentr1fy" | passwd $name; done
		```


### Extra configuration for apps-unix only

As this server also needs a GUI, it can be installed using
			
- ``yum -y groups install "GNOME Desktop"`` *this step will take approx. 10 minutes*
- ``systemctl set-default graphical.target``
- ``reboot``
- You should now have a GUI version of the earlier installed CentOS machine.

### Extra configuration for devops-unix only

- Add users, password, their  special groups, home dir (if not \/home\/\<username>) and shell (if not /bin/bash) use ``useradd -m -G wheel <USERNAME>``
	- afoster-a, Centr1fy, wheel
	- cfyadmin, Centr1fy, wheel
	- heldesk-a, Centr1fy, wheel
- Use the following command to get the users in the system:

	```bash
	for name in "afoster-a" "cfyadmin" "heldesk-a";do adduser -m -G wheel $name; echo -e "Centr1fy\nCentr1fy" | passwd $name; done
	```
<BR/><BR/>

# Your environment should now be ready to run the Lab

Shutdown all VMs as they are ready to be used.
