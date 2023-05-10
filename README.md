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

### Start order
After the initial download, as the Windows VMs are sysprepped, the imported OVAs need to be started in order. This paragraph describes the order, the amount of anticipated time it takes to get the VMs one by one ready to be used as well as the start order.
The below table provides the information:

| # | OVA | Time needed | Size OVA |
|-|-|-|-|
| 1 | vRouter | 5 minutes | 245 MB |
| 2 | DC | 10-15 minutes | 6.4 GB |
| 3 | APP | 10-15 minutes | 8.6 GB |
| 4 | ENDPOINT | 5-10 minutes | 14 GB |
| 5 | LINUX | 5 minutes | 1.3 GB |

After the OVas are running this is also the order in which the VMs should be started to make sure that the router, Domain Controller, the APP and the Endpoint are started correctly and can find each other.

### Firewall settings
The firewall settings are default for the Windows and Linux machines. As of initial run, only the RDP protocol is allowed as extra port in the Windows VMs. Any other port/protocol and or applications need to be configured according to the needs of the environment. For the 

## Accounts and Groups
After the Domain Controller (DC) is ready it will have the following accounts, groups and group membership created (all passwords are set to **Delinea/4u**, including the root and vyos account on the respectively Linux and VyOS VM):

| First name | Last name | account | Group membership | OU |
| - | - | - | - | - |
| Alex | Foster | afoster | Domain Admins <BR> IT - Database Team <BR> IT - Desktop Team <BR> IT - Server Group | Users |
| Amy | Houston | ahouston |  IT - Database Team <BR> Secret Server Administrator |Users |
| Ann | Washington | awashington | IT - Unix Team |Users |
| Bob | Hughes | bhughes |  IT - Database Team <BR> IT - Server Team |Users |
| Bradley | Adams | badams | IT - Unix Team |Users |
| Brandon | Michaels | bmichaels |  IT - Database Team IT - Desktop Team |Users |
| Carol | Nichols | cnichols | Development Team |Users |
| Centrify | Administrator | cfyadmin | Domain Admins |Users |
| Diego | Martinez | dmartinez | Development Team |Users |
| Domain Helpdesk | Support | helpdesk-a |  Domain Admins |Users |
| Felipe | Montoya | fmontoya | Development Team |Users |
| Jennifer | Charles | jcharles |  IT - Database Team IT - Server Team |Users |
| Joe | Miller | jmiller |  IT - Database Team IT - Server Team |Users |
| John | Smith | jsmith |  IT - Database Team IT - Desktop Team |Users |
| Kim | Rogers | krogers | Finance Team <BR> IT Engineering Team |Users |
| Larry | Pattel | lpattel | Finance Team |Users |
| Laura | Bennett | lbennett | Development Team |Users |
| Li | Wang | lwang | Finance Team |Users |
| Linda | Scott | lscott |  IT - Database Team IT - Desktop Team |Users |
| Mia | Thompson | mthompson | Secret Server Administrators |Users |
| Michael | Perry | mperry | IT - Unix Team |Users |
| Nancy | Jenkins | njenkins | IT - Unix Team |Users |
| Nelson | Long | nlong | Secret Server Administrators |Users |
| Robert | Johnson | rjohnson |  IT - Database Team IT - Desktop Team |Users |
| Sam | Nguyen | snguyen |  |Users |
| Trevor | Harley | tharley |  |Users |
| Wilson | Spaulding | wspaulding |  |Users |
| Alex | Foster(admin) | afoster-a |  Administrators |Users |
| Helpdesk | Local admin | helpdesk-d |  Administrators |Users |
| adm-training |  | adm-training |  Domain Admins <BR> DemoAccounts|
| adm_checkout1 |  | adm_checkout1 |  Domain Admins <BR> DemoAccounts|
| adm_rfa1 |  | adm_rfa1 |  Domain Admins <BR> DemoAccounts|
| Barry | Saunders | BSaunders | IT - Desktop Team |Users |
| Dennis | Hughes | DHughes | IT - Server Team |Users |
| Hardeep | Patel | HPatel | IT - Server Team |Users |
| Kim | Morris | KMorris | IT - Unix Team |Users |
| Lucy | Andrews | LAndrews | IT - Desktop Team |Users |
| Michael | Wong | MWong | IT - Unix Team |Users |
| Sarah | Tate | STate | Secret Server Administrators |Users |
| Terry | Marshall | TMarshall |  IT - Database Team |Users |
| Tom | Smith | TSmith | Secret Server Administrators | Users |
| svc_discovery |  | svc_discovery | |ServiceAccounts|
| svc_pmsync |  | svc_pmsync | | ServiceAccounts|
| svc_privilegemanager |  | svc_privilegemanager | |ServiceAccounts|
| svc_privilegemanager |  | svc_privilegemanager | |ServiceAccounts|
| svc_RPC |  | svc_RPC |  |ServiceAccounts|
| svc_secretserver |  | svc_secretserver | | ServiceAccounts|
| svc_service1 |  | svc_service1 | | ServiceAccounts|
| svc_sync |  | svc_sync | | ServiceAccounts|
| adm_desktopteam1 |  | adm_desktopteam1 | Domain Admins | DemoAccounts|
| adm_desktopteam2 |  | adm_desktopteam2 |  Domain Admins | DemoAccounts|
| adm_desktopteam3 |  | adm_desktopteam3 |  Domain Admins | DemoAccounts|
| adm_serverteam1 |  | adm_serverteam1 |  Domain Admins | DemoAccounts|
| adm_serverteam2 |  | adm_serverteam2 |  Domain Admins | DemoAccounts|
| adm_serverteam3 |  | adm_serverteam3 | Domain Admins | DemoAccounts|
| svc_application1 |  | svc_application1 | ServiceAccounts|
| Developer |  | developer | Development Team | Users |
| FinanceUser |  | FinanceUser | Finance Team | Users |
| ITenginner |  | ITEngineer | IT Engineering Team | Users |
| SalesUser |  | SalesUser | Sales Team | Users |
| StandardUser |  | User | | Users |
| Joe | Bloggs | JBloggs | Privilege Manager Administrators | Users |

**Other group membership for the accounts have to be configured for the required needs**
