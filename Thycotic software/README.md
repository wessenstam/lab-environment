# Detailed building guide

This guide will provide all detailed information on the building of the LAB/Demo environment for Secret Server and Privilege Manager. It will NOT provide any licenses, just some URLs where the needed software can be downloaded. It will provide detailed steps on how the software is installed, supported (if needed) with screenshots.

## Pre-requisites

To build the environment the following pre-requisites are needed in knowledge and software:

- Basic knowledge

    - Microsoft Windows Server and Workstation
    - Active Directory installation and configuration
    - Linux, CentOS including [vi](https://www.guru99.com/the-vi-editor.html) **(Secret server only)**

- Network

    - 1 network for the Windows Domain and all VMs
    - The network MUST have internet connectivity

- Operating systems

    - Windows 2016 installation media (https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2016)
    - Windows 10 installation media (https://www.microsoft.com/en-us/evalcenter/evaluate-windows-10-enterprise)
    - CentOS 7 or 8 installation media (the guide uses version 7 - https://www.centos.org/download/) **(Secret server only)**

- Hyper-Visor of choice. Lab guide has been built and tested on VMware ESXi 7.0
- Internet connectivity for all VMs
- Extra software:

    - PuTTY (https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
    - SQL 2008-2017. SQL 2017 Developer edition, can be downloaded [here](https://download.microsoft.com/download/5/A/7/5A7065A2-C81C-4A31-9972-8A31AC9388C1/)
    - SQL Management Studio (https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
    - .NET 4.8 installation (https://go.microsoft.com/fwlink/?linkid=2088631)
    - Google Chrome and/or Firefox browser

- Extra configuration for **All Windows** VMs

	- Add all servers to the thylab.local domain **except the devops-win**
	- Disable the firewall
	- Disable the Server Manager start up at boot time (if not already done)
	- Remove IE from the taskbar
	- Run Windows Updates on all machines


**PRO TIP** 

Create a Windows 2016 syspreped template and use it to build all needed Windows machines. Have the template pre-installed with:
- Windows Update ran
- Chrome
- PuTTY

<BR/><BR/>

# DC1

The lab needs a AD Domain Controller with the name **DC1**. This part of the preparation is setting this up.
## Hardware components:

- 2 vCPUs
- 4 GB RAM
- 30 GB HDD

## Installation

- Create a Active Directory Domain named **greensafe.lab**
- After domain has been created:

    - Copy the content of *[users.csv](https://raw.githubusercontent.com/wessenstam/lab-environment/main/Thycotic%20software/users.csv)* in a file called users.csv onto the machine to a location in the AD VM
    - Copy the following script content *[thylab-local-OU-Groups-Users.ps1](https://raw.githubusercontent.com/wessenstam/lab-environment/main/Thycotic%20software/thylab-local-OU-Groups-Users.ps1)* to the same location as the users.csv and name it **AD-Objects.ps1**. Change, if needed, the default password (*Thycotic@2022!*) to something else. Just remember to tell others about the new set password as that is not what is used in the lab guide.
    - Open a Powershell and CD to the location of the two files
    - Run the the Powershell command to let the script create the AD Objects.

- Open the DNS manager (dnsmgmt.msc) and follow these steps:

    - Add a forwarder to the DNS server DC1 use 8.8.8.8 or your local DNS server for "external" DNS resolving
    - Create a reverse *Lookup Zone* for **172.31.32**


<BR/><BR/>

# SSPM

The lab needs a server on which Secret Server and/or Privilege manager will be installed. This server will also have SQL server and IIS installed and configured for usage with the installation.
## Hardware components:

- 2 vCPUs
- 4 GB RAM
- 50 GB HDD

## Extra software

- .NET 4.8 installer (https://go.microsoft.com/fwlink/?linkid=2088631)
- SQL 2008-2017. SQL 2017 Developer edition, can be downloaded [here](https://go.microsoft.com/fwlink/?linkid=853016)
- SQL Management Studio (https://aka.ms/ssmsfullsetup)
- Combined Secret Server and Privilege manager setup file, via Thycotic SE
- Bundled Privilege Manager Agent Installer
- Licenses for Secrete Server and/or Privilege Manager, via Thycotic SE

## SQL Management Studio

Download and install the SQL Management Studio on the **SSPM**

## SQL server

During the installation of the SQL server a few configuration options *must* be selected:
1. Database Engine Services
2. Client Tools Connectivity
3. Install a *Named Instance* and *Instance ID* named **SQLEXPRESS**
4. Make sure the SQL Server Browser is set to Automatic for Startup Type
4. Leave the *Windows authentication mode* and make sure the following users also are shown:

   - SSPM\Administrator
   - THYLAB\Administrator
   - THYLAB\adm-training
   - THYLAB\svc_privilegemanager
   - THYLAB\svc_secretserver

5. Open the **SQL Server 2017 Configuration Manager**
6. Select *SQL Server Network Configuration*
7. Under the *Protocol* tab, double-click **TCP/IP** and set **Enabled** to **Yes**
8. Under the *IP Addresses* Tab, make sure port **1433** is mentioned on all IP Addresses and is the IP address is *Enabled* **Yes**
9. Click **OK** twice
10. Restart the server

## IIS Server

As Secret Server and Privilege Manager are depending on IIS for the webserver, use these steps to get all needed steps automated:

- Copy the following script content *[iis-install.ps1](https://raw.githubusercontent.com/wessenstam/lab-environment/main/Thycotic%20software/iis-lab.ps1)* to the same location as the users.csv and name it **iis-install.ps1**
- Open a Powershell command session with elevated rights
- CD to the location you saved the file
- Run the iis-install.ps1 script. This will install the needed IIS components, Disable the Server Manager from starting and install .NET 4.8 Framework which is also needed. If you get an warning message, click **Yes to all**
- The script will reboot the server, but will not show any messages!!! Check the taskmanager for progress on the installation of the .NET 4.8 Framework

## Extra configuration

- After all is running, log in as **THYLAB\adm-training** and create a directory on the desktop called **Installers**
- Copy the combined installer in the folder.
- Copy the **Bundled Privilege Manager Agent Installer - Windows** in this folder. It can be downloaded [here](https://docs.thycotic.com/privman/11.2.1/install/sw-downloads.md#agent_software)

<BR/><BR/>

# Client

The lab needs to have a Windows 10 client for the test of connections (Secret Server) or Privilege Manager tasks.

## Hardware components:

- 1 vCPUs
- 3 GB RAM
- 30 GB HDD

## Operating System

The Client is based on a Windows 10 installation

## Extra software

Login as THYLAB\adm-training and create a folder on the desktop called **Example Applications**.
Down the following installers into the created folder:

- [Notepad ++ ](https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.1.9.2/npp.8.1.9.2.Installer.exe)
- [uTorrent](https://download-lb.utorrent.com/uuid/d0e1309e-124f-4234-9bee-c7f0b6590a58)

<BR/><BR/>

# CentOS (Secret server only)

The lab needs to have a Windows 10 client for the test of connections (Secret Server).
## Hardware components:

- 1 vCPUs
- 1 GB RAM
- 30 GB HDD

## Operating System

The CentOS Server is based on a CentOS 7 minimum installation source. After the installation of the CentOS 7 O/S the following needs to be installed and configured for all three Linux machines:

- Set *ONBOOT=yes* in **/etc/sysconfig/network-scripts/ifcfg-\<NICNAME>** so the NIC activates on boot
- Run the following commands

    - ``yum update -y``
	- ``yum install -y net-tools open-vm-tools``

- Use ``hostnamectl set-hostname \<hostname>`` to set the correct hostname to centos_server
- Change the ``/etc/hosts`` file to correspond to the correct name using ``vi /etc/hosts`` (add the correct hostname to the lines that exist)
- Reboot the Linux machine
- After the first reboot your server should now have the correct hostname, use ``hostnamectl`` to check
- The Linux machine wil now be accessible via SSH for ease of configuration, open a SSH session using your the application of your choice to the Linux machine.
- Set the IP address of the Linux machine to static using [this article](https://www.cyberciti.biz/faq/howto-setting-rhel7-centos-7-static-ip-configuration/). **The used network-card (eth0) might be different on your Linux machine!!**
- Use the below table for the IP addresses for the Linux machines when using them against the Lab guides

  | Linux Machine | IP address | Pre-Fix |
  |---------------|------------|---------|
  | CentOS_Server | 172.31.32.121 | 24   |

- Use ``systemctl restart network`` to restart the network. You might loose the ssh session!!!
- Edit the DNS resolving via ``vi /etc/resolv.conf``
- Add two lines:

  1. nameserver 172.31.32.10
  2. search thylab.local

- Save the file
- To test type ``ping dc1.thylab.local`` a reply should be given.

- Use the following commands to get the users in the system:

		```bash
		for name in "thycotic" "adminuser" "JoeBloggs" "centosuser";do adduser -m -G wheel $name; echo -e "Thycotic@2022!\nThycotic@2022!" | passwd $name; done
		```


