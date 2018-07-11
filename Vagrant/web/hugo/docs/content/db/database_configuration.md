---
title: "Database config"
date: 2018-01-28T21:48:10+01:00
anchor: "database_config"
weight: 20
---

1) Install:
```console
yum install postgresql-server postgresql-contrib
postgresql-setup initdb
systemctl start postgresql
systemctl enable postgresql
```

2) Configure postgresql
```console
passwd postgres
su - postgres
psql -d template1 -c "ALTER USER postgres WITH PASSWORD 'password1994';"
```

3) Access postgresql
```console
psql postgres
```

4) Create database
```sql
CREATE DATABASE "2018";
```

5) List databases
```console
\l
```

6) Connect to database
```console
\c 2018
```

7) Create a table
```sql
CREATE TABLE calendar (id int, weekday varchar, zi varchar, luna varchar, an varchar);
```

8) List tables
```console
\dt
```

9) Insert data
```sql
INSERT INTO calendar VALUES (1, '-', '01', '01', '2018');
INSERT INTO calendar VALUES (2, '-', '02', '01', '2018');
INSERT INTO calendar VALUES (3, '-', '03', '01', '2018');
INSERT INTO calendar VALUES (4, '-', '25', '01', '2018');
```

10) Select data
```sql
SELECT * FROM calendar;
```

11) Update data
```sql
UPDATE calendar ca SET weekday = to_char(to_date(concat(c.zi,' ', c.luna, ' ', c.an), 'DD-MM-YYYY'), 'Day') from calendar c where ca.id = c.id;
```

12) Select data
```sql
SELECT * FROM calendar;
```

13) Disconnect from database
```console
\q
```

14) Edit bash script
```console
vim database_script.sh
```
```bash
#!/bin/bash:

# create database
db=2018
psql -U postgres -c "DROP DATABASE \"$db\""
psql -U postgres -c "CREATE DATABASE \"$db\""
psql -U postgres -d 2018 -c "CREATE TABLE calendar (id int, weekday varchar, zi varchar, luna varchar, an varchar);"
echo "Data created"

# set variables
nr_days=$(cal $1 $2 | egrep -v [a-z] |wc -w)
printf -v month "%02d" $1
year=$2
id=$3
echo "Variables set"

# insert data
for day in $(seq -f "%02g" 1 $nr_days)
do
        psql -U postgres -d 2018 -c "INSERT INTO calendar VALUES ($id, '-', '$day', '$month', '$year');"
        (( id += 1 ))
done
echo "Data inserted"

# update data
psql -U postgres -d 2018 -c "UPDATE calendar ca SET weekday = to_char(to_date(concat(c.zi, ' ', c.luna, ' ', c.an), 'DD-MM-YYYY'), 'Day') from calendar c where ca.id = c.id;"
echo "Data updated"
```
15) Run script
```
$1=month
$2=year
#3=id
```

```console
bash database_script.sh 2 2000 1
```

16) Access database
```console	
psql postgres
\c 2018
```

17) Select data
```sql
SELECT * FROM calendar;
```

18) Exit
```console
\q
logout
```
