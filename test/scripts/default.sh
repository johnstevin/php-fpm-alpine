#!/bin/bash

echo "======>Run project script"

chmod -R 755 /var/www/html/storage
chown -R www-data:www-data /var/www/html/storage

# dev网络很慢，暂时关闭
#curl -sLO https://github.com/gordalina/cachetool/releases/latest/download/cachetool.phar
#chmod +x cachetool.phar
#php cachetool.phar opcache:status --fcgi=0.0.0.0:9000
#php cachetool.phar opcache:reset --fcgi=0.0.0.0:9000