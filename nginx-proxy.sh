#!/bin/bash

sudo apt update
sudo apt install nginx

# openssl req -new -text -passout pass:abcd -subj /CN=localhost -out /etc/nginx/server.req -keyout /etc/nginx/cert.pem
# openssl rsa -in /etc/nginx/cert.pem -passin pass:abcd -out /etc/nginx/cert.key
# openssl req -x509 -in /etc/nginx/server.req -text -key /etc/nginx/cert.key -out /etc/nginx/server.crt
# chmod 600 /etc/nginx/cert.key

openssl req -x509 -nodes -newkey rsa:4096 -subj /CN=localhost -keyout /etc/nginx/cert.key -out /etc/nginx/cert.pem -days 365

echo "server {
    listen 80;
    listen 443 ssl;
    server_name 158.160.31.247;
    ssl_certificate  /etc/nginx/cert.pem;
    ssl_certificate_key /etc/nginx/cert.key;
    ssl_protocols   TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers   HIGH:!aNULL:!MD5;
    access_log /var/log/nginx/blog.zeroxzed.ru-access.log;
    error_log /var/log/nginx/blog.zeroxzed.ru-error.log;

location /grafana/ {
    proxy_pass http://10.129.0.13:3000;
    proxy_set_header Host \$host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Port  \$server_port;
    }
}" > /etc/nginx/sites-enabled/proxy

sudo service nginx restart
