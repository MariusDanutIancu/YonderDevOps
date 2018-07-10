---
title: "Nginx config"
date: 2018-01-28T21:48:10+01:00
anchor: "nginx_config"
weight: 10
---

1) Install an editor: 
```console
yum install -y vim
```

2) Install nginx: 
```console
yum install -y epel-release
yum -y install nginx
```

3) Start nginx:
```console
systemctl start nginx
systemctl enable nginx
```

4) Configure NGINX to serve for your domain
```console
mkdir -p /var/www/yonder_devops.com/public_html
```

5) Create an index file
```console
vim /var/www/yonder_devops.com/public_html/index.html
```

6) Add rights
```console
chmod 755 /var/www/yonder_devops.com/public_html
```

7) Configure nginx to recognize server blocks
```console
mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled
```

8) Tell nginx where to look for server blocks
```console
vim /etc/nginx/nginx.conf
```
* add following lines to the end of http{} block
```bash
include /etc/nginx/sites-enabled/*.conf;
server_names_hash_bucket_size 64;
```
* remove everything from include /etc/nginx/conf.d/*.conf to the new added lines

9) Create a file for the server block of your domain
```console
vim /etc/nginx/sites-available/yonder_devops.com.conf
```

```nginx
server {
   	listen 10.143.20.2:80;
   	server_name yonder_devops.com www.yonder_devops.com;

   	location / {
      	        root /var/www/yonder_devops.com/public_html;
      		index index.html index.htm;
      		try_files $uri $uri/ =404;
   	}

   	error_page 500 502 503 504 /50x.html;
   		
   	location = /50x.html {
      		root html;
   	}
}
```

10) Create a symbolic link between sites-available and sites-enabled
```console
ln -s /etc/nginx/sites-available/yonder_devops.com.conf /etc/nginx/sites-enabled/yourdomain.com.conf
```
11) Restart nginx
```console
systemctl restart nginx
```

12) Test in host browser at http://10.143.20.2/
