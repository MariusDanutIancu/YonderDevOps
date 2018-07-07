#!/bin/bash

# SELINUX
setenforce 0

# install
yum -y update
yum -y install epel-release
yum -y install nginx

systemctl start nginx
systemctl enable nginx

# create certificate
mkdir -p /etc/nginx/ssl/theos.in
cd /etc/nginx/ssl/theos.in
openssl genrsa -des3 -out self-ssl.key -passout pass:marius 2048
openssl req -new -key self-ssl.key -out self-ssl.csr -passin pass:marius -subj "/C=RO/ST=Iasi/L=Iasi/O=Yonder/OU=Devops/CN=yonder_devops.com"
cp -v self-ssl.{key,original}
openssl rsa -in self-ssl.original -out self-ssl.key -passin pass:marius
rm -v self-ssl.original
openssl x509 -req -days 365 -in self-ssl.csr -signkey self-ssl.key -out self-ssl.crt
cd /

# create domain folder
mkdir -p /var/www/yonder_devops.com/public_html
chmod 755 /var/www/yonder_devops.com/public_html

touch /var/www/yonder_devops.com/public_html/index.html
echo "Hello world" > /var/www/yonder_devops.com/public_html/index.html

mkdir -p /var/www/yonder_devops.com/public_html/stagiu
cp /var/www/yonder_devops.com/public_html/index.html /var/www/yonder_devops.com/public_html/stagiu

# configure nginx
iptables -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT

mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled

cat <<EOF > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/sites-enabled/*.conf;
    server_names_hash_bucket_size 64;
}
EOF

touch /etc/nginx/sites-available/yonder_devops.com.conf
cat <<EOF > /etc/nginx/sites-available/yonder_devops.com.conf
server {
	listen 10.143.20.2:80;
	server_name yonder_devops.com www.yonder_devops.com;

	# redirect
	return 301 https://\$server_name\$request_uri;
}

server {
	listen 10.143.20.2:443 ssl http2;
	server_name yonder_devops.com www.yonder_devops.com;

	ssl_certificate /etc/nginx/ssl/theos.in/self-ssl.crt;
	ssl_certificate_key /etc/nginx/ssl/theos.in/self-ssl.key;
	ssl_session_cache shared:SSL:20m;
	ssl_session_timeout 180m;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_prefer_server_ciphers on;
	ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DHE+AES128:!ADH:!AECDH:!MD5;

	location / {
	    root /var/www/yonder_devops.com/public_html;
	    index index.html index.htm;
	    try_files \$uri \$uri/ =404;
	}

	location /stagiu {
	    root /var/www/yonder_devops.com/public_html;
	    index index.html index.htm;
	    try_files \$uri \$uri/ =404;
	}

	location /go_intern {
		proxy_pass http://10.143.20.3:18080;
	}

	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
	    root html;
	}
}
EOF

ln -s /etc/nginx/sites-available/yonder_devops.com.conf /etc/nginx/sites-enabled/yonder_devops.com.conf

# restart nginx
systemctl restart nginx