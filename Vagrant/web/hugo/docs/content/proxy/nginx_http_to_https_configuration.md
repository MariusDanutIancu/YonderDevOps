---
title: "Ngnix http to https config"
date: 2018-01-28T21:48:10+01:00
anchor: "nginx_http_to_https_config"
weight: 34
---

1) To redirect http to https edit

```bash
vim /etc/nginx/sites-enabled/yonder_devops.com.conf
```

```nginx
server {
               listen 10.143.20.2:80;
               server_name yonder_devops.com www.yonder_devops.com;

               # redirect
               return 301 https://$server_name$request_uri;
}

server {
	        listen 10.143.20.2:443 ssl http2;
	        server_name yonder_devops.com www.yonder_devops.com;

	        ssl_certificate      /etc/nginx/ssl/theos.in/self-ssl.crt;
	        ssl_certificate_key  /etc/nginx/ssl/theos.in/self-ssl.key;
            ssl_session_cache shared:SSL:20m;
            ssl_session_timeout 180m;
            ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
            ssl_prefer_server_ciphers on;
            ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DHE+AES128:!ADH:!AECDH:!MD5;


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

2) Restart nginx

```bash
systemctl restart nginx
```

3) Edit host /etc/hosts file and add

```conf
10.143.20.2	www.yonder_devops.com yonder_devops.com
```

4) Test in host browser at http://10.143.20.2/
