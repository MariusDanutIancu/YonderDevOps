#!/bin/bash

yum -y install gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel xinetd unzip

useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios

######################################################################################
# install nagios
cd ~
curl -L -O https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.1.tar.gz

tar xvf nagios-*.tar.gz

cd nagios-*

./configure --with-command-group=nagcmd 

make all

make install
make install-commandmode
make install-init
make install-config
make install-webconf

usermod -G nagcmd apache

######################################################################################
# install plugins
cd ~
curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz

tar xvf nagios-plugins-*.tar.gz

cd nagios-plugins-*

./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl

make

make install

######################################################################################
# configure nagios

mkdir /usr/local/nagios/etc/servers
cp /home/vagrant/files/nagios/nagios.cfg /usr/local/nagios/etc/nagios.cfg
cp /home/vagrant/files/nagios/centos7.cfg /usr/local/nagios/etc/servers/centos7.cfg
cp /home/vagrant/files/nagios/commands.cfg /usr/local/nagios/etc/objects/commands.cfg

htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin admin

#######################################################################################
# fix 403 error
yum -y install php
systemctl restart httpd.service

#######################################################################################
# restart
systemctl daemon-reload
systemctl enable nagios.service
systemctl restart nagios.service
systemctl restart httpd.service

chkconfig nagios on
