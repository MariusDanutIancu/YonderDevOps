#!/bin/bash

if [[ -f "/var/log/systemusage/process.log" ]]
then
	echo "File exists"
else
	touch /var/log/systemusage/process.log
	echo "File created"
fi

date +"%d %b %Y %H:%M:%S" >> /var/log/systemusage/process.log
top -b -n1 -o %CPU | head -n12 | tail -n5 | awk '{print $12 " " $1 " " $9 "\n"}' >> /var/log/systemusage/process.log
