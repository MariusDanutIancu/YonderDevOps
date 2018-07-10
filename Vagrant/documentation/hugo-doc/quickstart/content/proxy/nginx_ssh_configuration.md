---
title: "Nginx ssh config"
date: 2018-01-28T21:48:10+01:00
anchor: "nginx_ssh_config"
weight: 20
---

1) Create certificate directory
```console
mkdir -p /etc/nginx/ssl/theos.in
```

2) Move to certificate directory
```console
cd /etc/nginx/ssl/theos.in
```

3) Create ssl private key
```console
openssl genrsa -des3 -out self-ssl.key -passout pass:marius 2048
```

4) Create a certificate signing request (CSR)
```console
openssl req -new -key self-ssl.key -out self-ssl.csr -passin pass:marius -subj "/C=RO/ST=Iasi/L=Iasi/O=Yonder/OU=Devops/CN=yonder_devops.com"
```

5) Remove passphrase for nginx
```console
cp -v self-ssl.{key,original}
openssl rsa -in self-ssl.original -out self-ssl.key -passin pass:marius
rm -v self-ssl.original
```

6) Create certificate
```console
openssl x509 -req -days 365 -in self-ssl.csr -signkey self-ssl.key -out self-ssl.crt
```

7) Change directory to:
```console
cd /etc/nginx/
```

8) Add a new server block in nginx config
```console
vim /etc/nginx/sites-enabled/yonder_devops.com.conf
```
```nginx
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

9) Restart nginx
```console
systemctl restart nginx
```

10) Open TCP HTTPS port # 443
```console
iptables -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT
```

11) Disable chrome cache: F12 > network > disable cache

12) Test in host browser at https://10.143.20.2/
