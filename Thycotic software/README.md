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
    - Centrify Cloud Tenant (\<tenant>.my.centrify.net. request via ThycoticCentrify SE)
    - Centrify Server Suite Software (request via ThycoticCentrify SE)
    - Google Chrome and/or Firefox browser

- Extra configuration for **All Windows 2016 Server** machines

	- Add all servers to the greensafe.lab domain **except the devops-win**
	- Disable the firewall
	- Disable the Server Manager start up at boot time
	- Remove IE from the taskbar
	- Run Windows Updates on all machines


**PRO TIP** 

Create a Windows 2016 syspreped template and use to build the all needed Windows machines. Have to template pre-installed with:
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
    - Copy the following script content *[thylab-local-OU-Groups-Users.ps1](https://raw.githubusercontent.com/wessenstam/lab-environment/main/Thycotic%20software/thylab-local-OU-Groups-Users.ps1)* to the same location as the users.csv and name it **AD-Objects.ps1**. Change, if needed, the default password (*Thycotic@2022*) to something else. Just remember to tell others about the new set password as that is not what is used in the lab guide.
    - Open a Powershell and CD to the location of the two files
    - Run the the Powershell command to let the script create the AD Objects.

<BR/><BR/>

# SSPM

The lab needs a AD Domain Controller with the name **DC1**. This part of the preparation is setting this up.
## Hardware components:

- 2 vCPUs
- 4 GB RAM
- 40 GB HDD


<BR/><BR/>

# Client

## Hardware components:

- 1 vCPUs
- 3 GB RAM
- 30 GB HDD



<BR/><BR/>

# CentOS (Secret server only)

## Hardware components:

- 1 vCPUs
- 1 GB RAM
- 30 GB HDD
