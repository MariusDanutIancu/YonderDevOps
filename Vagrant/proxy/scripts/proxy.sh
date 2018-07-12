#!/bin/bash

# SELINUX
setenforce 0

# install
yum -y update
yum -y install epel-release
yum -y install nginx
yum -y install vim

systemctl start nginx
systemctl enable nginx

# create certificate
mkdir -p /etc/nginx/ssl/theos.in
cd /etc/nginx/ssl/theos.in
openssl genrsa -des3 -out self-ssl.key -passout pass:marius 2048
openssl req -new -key self-ssl.key -out self-ssl.csr -passin pass:marius -subj "/C=RO/ST=Iasi/L=Iasi/O=Yonder/OU=Devops/CN=yonder_devops.com"
cp -v self-ssl.{key,original}
openssl rsa -in self-ssl.original -out self-ssl.key -passin pass:marius
rm -v self-ssl.original
openssl x509 -req -days 365 -in self-ssl.csr -signkey self-ssl.key -out self-ssl.crt
cd /

# create domain folder
mkdir -p /var/www/yonder_devops.com/public_html
chmod 755 /var/www/yonder_devops.com/public_html

touch /var/www/yonder_devops.com/public_html/index.html
echo "Hello world" > /var/www/yonder_devops.com/public_html/index.html

mkdir -p /var/www/yonder_devops.com/public_html/stagiu
cp /var/www/yonder_devops.com/public_html/index.html /var/www/yonder_devops.com/public_html/stagiu

# configure nginx
iptables -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT

mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled

cp /home/vagrant/files/nginx.conf /etc/nginx/nginx.conf
cp /home/vagrant/files/yonder_devops.com.conf /etc/nginx/sites-available/yonder_devops.com.conf

ln -s /etc/nginx/sites-available/yonder_devops.com.conf /etc/nginx/sites-enabled/yonder_devops.com.conf

# restart nginx
systemctl restart nginx

# change path
cd /