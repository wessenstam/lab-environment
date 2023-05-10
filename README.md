# Building guide

This guide will provide all detailed information on the building of the LAB/Demo environment for Secret Server and/or Privilege Manager. The environment can be used in combination with other Delinea's solutions. It will **NOT** provide any licenses. **Licenses for Delinea's solutions can be requested via the Delinea Channel SE for your region.**

## Pre-requisites

To build the environment the following pre-requisites are needed in knowledge and software:

- Basic knowledge

    - Microsoft Windows Server and Workstation
    - Active Directory installation and configuration
    - Linux including [vi](https://www.guru99.com/the-vi-editor.html)

- Network

    - 1 network for the Windows Domain, including the Linux machine
    - 1 network for routing purposes to the internet. THis is provided by the VyOS routing solution.

- Operating systems used

    - Microsoft Windows Server 2022
    - Rocky 9 Linux

- Hyper-Visor of choice. Lab guide has been built and tested on VMware ESXi 7.0 U3
- Internet connectivity for all VMs directly, or via the VyOS router VM.

## Instructions

This chapter describes the steps and information needed to to start the lab environment.

### Distribution
All Microsoft Windows VMs are sysprepped and will run steps for installation, configuration and installation of needed functions using an unattended installation. The Linux VM is delivered as is. All VMs are available for download in OVA format. **The URLs for the OVA files can be requested via the Delinea Channel SE for your region**.

- DC; After the start of this VM, it will take approx. 10 minutes to be functionally ready. The unattend will run the following steps:

    1. Set the IP address of the server to 172.31.32.10/24 with 172.31.32.253 as the default gateway
    2. Install Active Directory components and run "DC Promo" for the **delinealabs.com** domain
    3. Install DNS server and add the **8.8.8.8** as a forwarder for the DNS server
    4. INstall the Authorized CA feature
    5. Reboots
    6. Configure users and groups needed for the lab

- APP; After the start of the VM, it will take approx. 10 minutes to be ready. The unattend installation run the following steps:

    1. Set the IP address of the server to 172.31.32.20/24 with 172.31.32.253 as the default gateway
    1. Disable the server Manager UI
    1. Set the IP address to 172.31.32.20/24 with the default gateway to 172.31.32.253
    1. Set the DNS Server to 172.31.32.10
    1. Join the domain using the domain admin account
    1. Reboot
    1. Install MS SQL Server 2017 Developer Edition
    1. Install MS SQL Server management Studio 19.0.2
    1. Reboot

- Endpoint; After the start of the VM, it takes approx. 10 minutes before the VM is ready for usage. The unattend installation will run the following steps:

    1. Set the IP address of the server to 172.31.32.100/24 with 172.31.32.253 as the default gateway
    1. Set the IP address to 172.31.32.20/24 with the default gateway to 172.31.32.253
    1. Set the DNS Server to 172.31.32.10
    1. Join the domain using the domain admin account
    1. Reboot


### IP Addresses

Below table shows the IP addresses of the machines in the Lab environment:

| Name | Description | IP Address |
|-|-|-|
| DC | Domain controller with DNS Server | 172.31.32.10 |
| APP | Installation server for installation of Delinea's Solution <BR> SQL Server 2017 Developer Edition | 172.31.32.20 |
| Endpoint | Client VM, Windows 10 | 172.31.32.100 |
| Linux | Rocky 9.1 Linux VM | 172.31.32.200 |
| VyOS | Router between the internet and Lab | 172.31.32.253 |

