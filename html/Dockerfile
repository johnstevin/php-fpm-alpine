FROM registry.cn-hangzhou.aliyuncs.com/cool2rong/php-fpm-alpine:1.0.1

ADD src/ /var/www/html/

RUN chmod -R 755 /var/www/html/storage && \
    chown -R www-data:www-data /var/www/html/storage && \
    cd /var/www/html/ && \
    composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ && \
    composer install
