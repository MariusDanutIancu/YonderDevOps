#!/bin/bash

# SELINUX
setenforce 0

# install
yum -y update
yum -y install git
yum -y install golang
yum -y install vim
yum -y install wget

# remove go-intern
yum -y remove go-interns 
userdel gouser

# add a new repo 
cp /home/vagrant/files/localrepo.repo /etc/yum.repos.d/localrepo.repo

# set yum
yum clean all
yum –y update

# install go-intern
yum --enablerepo=localrepo install go-intern

# configure database configuration
cp /home/vagrant/files/conf.json /opt/go-interns/conf.json

# restart
systemctl daemon-reload
systemctl restart rsyslog.service
systemctl restart go-intern.service

# add new repo
cd /etc/yum.repos.d/
wget https://copr.fedorainfracloud.org/coprs/daftaupe/hugo/repo/epel-7/daftaupe-hugo-epel-7.repo

# set yum
yum clean all
yum –y update

# install hugo
yum -y install hugo

# make directory
mkdir /home/hugo

# cp data
cp -r /home/vagrant/files/hugo/docs/* /home/hugo

# change directory
cd /home/vagrant/files/hugo/docs

# start hugo
nohup hugo server --bind 10.143.20.3 -p 443 -b https://10.143.20.2/docs -D & 2> /dev/null
