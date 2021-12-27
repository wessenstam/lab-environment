# Detailed building guide

This guide will provide all detailed information on the building of the LAB/Demo environments. It will NOT provide any licenses, just some URLs where the needed software can be downloaded. It will provide detailed steps on how the software is installed, supported (if needed) with screenshots.

## Pre-requisites

To build the environment the following pre-requisites are needed in knowledge and software:

- Basic knowledge

    - Microsoft Windows Server and Workstation
    - Active Directory installation and configuration
    - Linux, CentOS

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

## Windows Active Directory

The lab needs a AD Domain Controller.
### Hardware components:

- 2 vCPUs
- 4 GB RAM
- 30 GB HDD

### Installation

- Create a Active Directory Domain named **greensafe.lab**
- After domain has been created:

    - Copy the *[users.csv](./users.csv)* file onto the machine to a location in the AD VM
    - Copy the following script *[Greensafe-lab-OU-Groups-Users.ps1](./Greensafe-lab-OU-Groups-Users.ps1)* to the same location as the users.csv. Change if wanted the default password to something else.
    - Open a Powershell and CD to the location of the two files
    - Run the the Powershell command to let the script create the AD Objects.

## Apps-server

The lab will be run from this server, so some parts have to be installed and prepared and is member of the greensafe.lab domain.

### Hardware

- 4 vCPU
- 8 GB RAM
- 30 GB HDD

### Extra software

- PuTTY (https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
- WinSCP (https://winscp.net/eng/downloads.php)
- Windows Adminstrative Tools (https://www.hammer-software.com/how-to-install-remote-server-administration-tools-rsat-on-windows-server-2016/)

### Configuration

- PuTTY shortcut on the desktop
- WinSCP shortcut on the desktop
- GPO editor shortcut on the desktop and pinned to the taskbar
- Services shortcut on the desktop and pinned to the taskbar
- Google Chrome shortcut on the desktop and pinned to the taskbar (https://www.google.com/chrome/?standalone=1)
- Active Directory Users and Computers shortcut on the desktop and pinned to the taskbar


## DB-server

This server will provide the SQL database instance needed for the lab/demo environment and is member of the greensafe.lab domain

### Hardware

- 4 vCPU
- 8 GB RAM
- 60 GB HDD

### Extra software

- .NET 4.8 installer (https://go.microsoft.com/fwlink/?linkid=2088631)
- SQL 2008-2016 (test 2017 Developer!?  https://download.microsoft.com/download/5/A/7/5A7065A2-C81C-4A31-9972-8A31AC9388C1/SQLServer2017-SSEI-Dev.exe)

    - including Reporting Services
 
- SQL Management Studio (https://aka.ms/ssmsfullsetup)

## devops-windows

This Windows 10 Client machine which is not part of the domain and in another Network IP Range. It will be used in the lab as Connector and to remote control into it.

### Hardware

- 2 vCPUs
- 4 GB RAM
- 30 GB HDD

### Extra software

- PuTTY on desktop
- Chrome on desktop

## Linux machines

The three Linux machines are based on the CentOS 7 distribution. Download the minimum iso (approx. 1GB) from http://isoredirect.centos.org/centos/7/isos/x86_64/.

### Hardware

Two out of the three Linux machines have the same hardware requirement. The last one (devops-unix) is smaller in size.
#### apps-unix and db-unix

- 2 vCPUs
- 4GB RAM
- 30 GB HDD

#### devops-unix

- 1 vCPU
- 1 GB RAM
- 30 GB HDD

### Installation steps

Install CentOS as a minimum installation using the downloaded ISO file. For the **root** password use **password1**
#### Post O/S installation

##### General steps for all three Linux machines

After the installation of the CentOS 7 O/S the following needs to be installed and configured for all three Linux machines:

- Set *ONBOOT=yes* in **/etc/sysconfig/network-scripts/ifcfg-\<NICNAME>** so the NIC activates on boot
- Run the following commands

    - ``yum update -y``
	- ``yum install -y net-tools``
	- ``yum install -y open-vm-tools``

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

URL for the documented details:  https://docs.centrify.com/Content/inst-depl/AgentsOptionsNativeInstall.htm. To get a TOKEN click the Set Me Up as shown below on https://thycotic.force.com/centrifysupport/CentrifyRepo.

##### Extra configuration/installation for apps-unix and db-unix

- Add users, password, their  special groups, home dir (if not \/home\/\<username>) and shell (if not /bin/bash) use ``useradd -m -G wheel <USERNAME>``
	- afoster-a, Centr1fy, wheel (**on db-unix only!!!**)
    - cfyadmin, Centr1fy, wheel
	- heldesk-a, Centr1fy, wheel
	- kim, Centr1fy
	- sam, Centr1fy

##### Extra configuration for apps-unix only

As this server also needs a GUI, it can be installed using
			
- ``yum -y groups install "GNOME Desktop"``
- ``systemctl set-default graphical.target``
- ``reboot``
- Finish the installation after the reboot and *create 1 user* **afoster-a**, account will be part of the wheel group by default

##### Extra configuration for devops-unix only

- Add users, password, their  special groups, home dir (if not \/home\/\<username>) and shell (if not /bin/bash) use ``useradd -m -G wheel <USERNAME>``
	- afoster-a, Centr1fy, wheel
	- cfyadmin, Centr1fy, wheel
	- heldesk-a, Centr1fy, wheel
