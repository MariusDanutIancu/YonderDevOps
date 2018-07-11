#!/bin/bash

# SELINUX
setenforce 0

# install
yum -y update
yum -y install vim
yum install createrepo
yum install httpd

mkdir -p /repos/centos/7/Packages
mkdir -p /var/www/html/localrepo

cat <<EOF > /etc/yum.repos.d/localrepo.repo
[localrepo]
name=yonder_devops Repository
baseurl=file:///var/www/html/localrepo
gpgcheck=0
enabled=1
EOF

createrepo -v /var/www/html/localrepo
createrepo --update /var/www/html/localrepo

systemctl start httpd
systemctl enable httpd