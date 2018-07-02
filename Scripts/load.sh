#!/bin/bash

if [[ -f "/var/log/systemusage/load.log" ]]
then
        echo "File exists"
else
        touch /var/log/systemusage/load.log
        echo "File created"
fi

date +"%d %b %Y %H:%M:%S" >> /var/log/systemusage/load.log
cat /proc/loadavg | awk '{print $1 " " $2 " " $3 "\n"}' >> /var/log/systemusage/load.log

