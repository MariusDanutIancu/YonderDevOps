#!/bin/bash

# SELINUX
setenforce 0

# install
yum -y update
yum -y install git
yum -y install golang
yum -y install vim


# prepare go-intern rpm
#######################################################################################################
# install packages
yum -y install gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools dos2unix

# prepare go-intern
git clone https://github.com/aso930/go-interns.git
cp /home/vagrant/files/go-intern.service /home/vagrant/go-interns
cp /home/vagrant/files/go-intern.conf /home/vagrant/go-interns

cd /home/vagrant/go-interns
dos2unix build.sh

# prepare rpm
mkdir /tmp/go-interns-1.0

cd /home/vagrant/go-interns
cp build.sh /tmp/go-interns-1.0
cp conf.json /tmp/go-interns-1.0
cp main.go /tmp/go-interns-1.0
cp go-intern.service /tmp/go-interns-1.0
cp go-intern.conf /tmp/go-interns-1.0
cp -r templates /tmp/go-interns-1.0

rpmdev-setuptree

cd /tmp/
tar -cvzf go-interns-1.0.tar.gz go-interns-1.0

mv /tmp/go-interns-1.0.tar.gz /root/rpmbuild/SOURCES
cp /home/vagrant/files/go-intern.spec /root/rpmbuild/SPECS/go-intern.spec
rpmlint /root/rpmbuild/SPECS/go-intern.spec

# build rpm
rpmbuild -bb /root/rpmbuild/SPECS/go-intern.spec
mv /root/rpmbuild/RPMS/x86_64/go-interns-1.0-1.el7.x86_64.rpm /home/vagrant/

########################################################################################################
# remove go-intern
yum -y remove go-interns 
userdel gouser

# install go-intern
cd /
rpm -ivh /home/vagrant/go-interns-1.0-1.el7.x86_64.rpm

# configure database configuration
cp /home/vagrant/files/conf.json /opt/go-interns/conf.json

# restart
systemctl daemon-reload
systemctl restart rsyslog.service
systemctl restart go-intern.service
