#!/bin/bash

yum -y update
yum -y install git
yum -y install golang
git clone https://github.com/aso930/go-interns.git
cd /home/vagrant/go-interns/
yum install -y dos2unix
dos2unix build.sh
bash build.sh

cat <<EOF > conf.json
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

touch /etc/rsyslog.d/go-intern.conf
cat <<EOF > /etc/rsyslog.d/go-intern.conf
if $programname == 'go-intern' then /var/log/go-intern/go-intern.log
if $programname == 'go-intern' then ~
EOF

mkdir /var/log/go-intern
setenforce 0

systemctl daemon-reload
systemctl restart rsyslog.service
systemctl start go-intern.service
