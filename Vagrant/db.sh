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

touch database_script.sh
cat <<EOF > database_script.sh
#!/bin/bash:

# create database
db=2018
sudo -u postgres psql -c "DROP DATABASE \"\$db\""
sudo -u postgres psql -c "CREATE DATABASE \"\$db\""
sudo -u postgres psql -d 2018 -c "CREATE TABLE calendar (id int, weekday varchar, zi varchar, luna varchar, an varchar);"
echo "Data created"

# set variables
nr_days=\$(cal \$1 \$2 | egrep -v [a-z] |wc -w)
printf -v month "%02d" $1
year=\$2
id=\$3
echo "Variables set"

# insert data
for day in \$(seq -f "%02g" 1 \$nr_days)
do
        sudo -u postgres psql -d 2018 -c "INSERT INTO calendar VALUES (\$id, '-', '\$day', '\$month', '\$year');"
        (( id += 1 ))
done
echo "Data inserted"

# update data
sudo -u postgres psql -d 2018 -c "UPDATE calendar ca SET weekday = to_char(to_date(concat(c.zi, ' ', c.luna, ' ', c.an), 'DD-MM-YYYY'), 'Day') from calendar c where ca.id = c.id;"
echo "Data updated"
EOF

bash database_script.sh 2 2000 1

sed -i 59s#.*#listen_addresses=\'*\'# /var/lib/pgsql/data/postgresql.conf
sed -i '82s#.*#host    all             all              0.0.0.0/0                       md5#' /var/lib/pgsql/data/pg_hba.conf
sed -i '84s#.*#host    all             all              ::/0                            md5#' /var/lib/pgsql/data/pg_hba.conf

# restart
systemctl restart postgresql

# change path
cd /