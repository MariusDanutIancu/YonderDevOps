#!/bin/bash

if [[ -f "/var/log/systemusage/disk.log" ]]
then
        echo "File exists"
else
        touch /var/log/systemusage/disk.log
        echo "File created"
fi

date +"%d %b %Y %H:%M:%S" >> /var/log/systemusage/disk.log
df -h | awk '{if(NR>1) print $1 " " $5 " " $6}' | column -t >> /var/log/systemusage/disk.log
echo >> /var/log/systemusage/disk.log
