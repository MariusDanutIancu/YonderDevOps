#!/bin/bash

# SELINUX
setenforce 0

# install
yum -y update
yum -y install vim
yum -y install createrepo
yum -y install httpd

mkdir -p /var/www/html/localrepo

cp -ar /home/vagrant/files/rpm/* /var/www/html/localrepo
cp  /home/vagrant/files/localrepo.repo /etc/yum.repos.d/localrepo.repo

createrepo -v /var/www/html/localrepo
createrepo --update /var/www/html/localrepo

systemctl start httpd
systemctl enable httpd