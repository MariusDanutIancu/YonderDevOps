#!/bin/bash

yum -y install net-snmp net-snmp-utils

cp /home/vagrant/files/snmp/snmpd.conf /etc/snmp/snmpd.conf

systemctl restart snmpd
systemctl enable snmpd