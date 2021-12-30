# Lab-Environment

This repo can be used to build a lab environment for the different Lab/Demo environments for ThycoticCentrify software. It has all needed publicly available scripts to build the environment(s).

## Scripts available

Under each folder (Centrify / Thycotic software) you will find:

1. The PowerShell script 
2. Supporting files to populate the needed AD
3. The build of the Lab environment

    1. What O/S's are needed
    2. What networking is needed
    3. Which software is needed and installed
    4. Extra configuration items

---
## High level overview lab environments

### Centrify Server/Cloud Suite

This environment has 7 VMs.

1. Windows 2016, Domain Controller, dc-server
2. Windows 2016, DB server, db-server
3. Windows 2016, Apps server, apps-server
4. Windows 2016, DevOps Windows, devops-win
5. CentOS 7, DB Server, db-unix
6. CentOS 7, Apps Server, apps-unix
7. CentOS 7, DevOps machine, devops-unix

Except the DevOps related machine all machines are in 1 IP range. The DevOps machines are in another IP range. No routing between the networks, but both networks need internet connectivity.

*Domain used*: greensafe.lab

### Thycotic Secret Server

This environment has 4 VMs.

1. Windows 2016, Domain Controller, DC1
2. Windows 2016, SSPM, SSPM
3. Windows 10, Client, Client
4. CentOS 7, CentOS Server, CentOS Server

All machines are in 1 IP range.

*Domain used*: thylab.local

### Thycotic Privilege Manager

This environment has 3 VMs.

1. Windows 2016, Domain Controller, DC1
2. Windows 2016, SSPM, SSPM
3. Windows 10, Client, Client

All machines are in 1 IP range.

*Domain used*: thylab.local

---
#### REMARK

This guide **WILL NOT** provide any licenses needed for the O/S and used software. That is on the builder of the Lab/Demo environment!!!

 
