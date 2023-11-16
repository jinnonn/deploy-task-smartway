#!/bin/bash

sudo apt update
sudo apt install nginx

echo "server {
    listen 80;
    server_name 158.160.31.247:80;
    access_log /var/log/nginx/blog.zeroxzed.ru-access.log;
    error_log /var/log/nginx/blog.zeroxzed.ru-error.log;

location /grafana {
    proxy_pass http://10.129.0.13:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Port  $server_port;
    }
}" > /etc/nginx/sites-enabled/proxy

sudo service nginx restart
