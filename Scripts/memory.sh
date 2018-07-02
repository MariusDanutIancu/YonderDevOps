#!/bin/bash

if [[ -f "/var/log/systemusage/memory.log" ]]
then
        echo "File exists"
else
        touch /var/log/systemusage/memory.log
        echo "File created"
fi

date +"%d %b %Y %H:%M:%S" >> /var/log/systemusage/memory.log
free -m | head -2 | tail -1 | awk '{print $2 " " $3 " " $4 " " $5 " " $6 "\n"}' | column -t >> /var/log/systemusage/memory.log
