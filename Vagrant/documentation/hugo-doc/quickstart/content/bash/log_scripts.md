---
title: "Scripts"
date: 2018-01-28T21:48:10+01:00
anchor: "scripts"
weight: 20
---

```bash

#!/bin/bash


if [[ -f "/var/log/systemusage/disk.log" ]]
then
        echo "File exists"
else
        touch /var/log/systemusage/disk.log
        echo "File created"
fi

date +"%d %b %Y %H:%M:%S" >> /var/log/systemusage/disk.log
df -h | awk '{if(NR>1) print $1 " " $5 " " $6 "\n"}' | column -t >> /var/log/systemusage/disk.log
```

```bash

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

```

```bash

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

```

```bash

#!/bin/bash

if [[ -f "/var/log/systemusage/process.log" ]]
then
	echo "File exists"
else
	touch /var/log/systemusage/process.log
	echo "File created"
fi

date +"%d %b %Y %H:%M:%S" >> /var/log/systemusage/process.log
top -b -n1 -o %CPU | head -n12 | tail -n5 | awk '{print $12 " " $1 " " $9 "\n"}' | column -t >> /var/log/systemusage/process.log

```
