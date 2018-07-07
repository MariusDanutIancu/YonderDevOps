#!/bin/bash

# SELINUX
setenforce 0

# install
yum -y update
yum -y install git
yum -y install golang
yum -y install vim

git clone https://github.com/aso930/go-interns.git

yum install -y dos2unix
cd go-interns
dos2unix build.sh
bash build.sh
cd ..

# config
cat <<EOF > /home/vagrant/go-interns/conf.json
{
    "DBName": "2018",
    "User": "postgres",
    "Password": "password1994",
    "Host": "10.143.20.4",
    "Port": "5432"
}
EOF

touch /etc/systemd/system/go-intern.service
cat <<EOF > /etc/systemd/system/go-intern.service
[Unit]
Description=go-intern-service

[Service]
ExecStart=/home/vagrant/go-interns/main
WorkingDirectory=/home/vagrant/go-interns
Type=simple
KillMode=process
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=go-intern

[Install]
WantedBy=multi-user.target
EOF

mkdir /var/log/go-intern
touch /etc/rsyslog.d/go-intern.conf
cat <<EOF > /etc/rsyslog.d/go-intern.conf
if \$programname == 'go-intern' then /var/log/go-intern/go-intern.log
if \$programname == 'go-intern' then ~
EOF

# restart
systemctl daemon-reload
systemctl restart rsyslog.service
systemctl restart go-intern.service

# change path
cd /