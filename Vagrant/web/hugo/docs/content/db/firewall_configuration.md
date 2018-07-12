---
title: "Firewall configuration"
date: 2018-01-28T21:48:10+01:00
anchor: "firewall_db_config"
weight: 52
---

0) Install firewalld

```bash
yum -y install firewalld
```

1) enable and start firewall

```bash
systemctl enable firewalld
systemctl start firewalld
```

2) Disable selinux

```bash
setenforce 0
```

3) Create a zone

```bash
firewall-cmd --permanent --new-zone=yonder
```

4) Check if zone was created

```bash
firewall-cmd --permanent --get-zones
```

5) Reload firewall

```bash
firewall-cmd --reload
```

6) Check if zone was added

```bash
firewall-cmd --get-zones
```

7) Create and edit custom service file
```bash
cp /usr/lib/firewalld/services/ssh.xml /etc/firewalld/services/postgre.xml
vi /etc/firewalld/services/postgre.xml
```

```xml
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>postgre</short>
  <description>Postgre service</description>
  <port protocol="tcp" port="5432"/>
</service>

```

8) Add rules to zone and check

```bash
firewall-cmd --zone=yonder --permanent --add-service=ssh
firewall-cmd --zone=yonder --permanent --add-service=dhcp
firewall-cmd --zone=yonder --permanent --add-service=snmp
firewall-cmd --zone=yonder --permanent --add-service=postgre
firewall-cmd --zone=yonder --list-all
```
9) Add interfaces and set zone as default 

```bash
firewall-cmd --zone=yonder --permanent --change-interface=eth0
firewall-cmd --zone=yonder --permanent --change-interface=eth1
firewall-cmd --zone=yonder --permanent --change-interface=wlol
firewall-cmd --set-default-zone=home
```

10) Reload and check if the changes were made

```bash
systemctl restart network
systemctl reload firewalld
firewall-cmd --get-active-zones
```