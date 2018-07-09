#!/bin/bash

# SELINUX
setenforce 0

# change path
cd /

# install
yum -y update
yum -y install postgresql-server postgresql-contrib
yum -y install vim
postgresql-setup initdb
systemctl start postgresql
systemctl enable postgresql

# configure
echo "password1994" | passwd postgres --stdin
sudo -u postgres psql -d template1 -c "ALTER USER postgres WITH PASSWORD 'password1994';"

cp /home/vagrant/files/database_script.sh database_script.sh

bash database_script.sh 2 2000 1

sed -i 59s#.*#listen_addresses=\'*\'# /var/lib/pgsql/data/postgresql.conf
sed -i '82s#.*#host    all             all              0.0.0.0/0                       md5#' /var/lib/pgsql/data/pg_hba.conf
sed -i '84s#.*#host    all             all              ::/0                            md5#' /var/lib/pgsql/data/pg_hba.conf

# restart
systemctl restart postgresql

# change path
cd /