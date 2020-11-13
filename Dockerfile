FROM php:7.4.12-fpm-alpine3.12

LABEL maintainer="Stevin.John <stevin.john@qq.com>"

ENV TIMEZONE Asia/Shanghai

ADD conf/repositories /etc/apk/repositories

RUN apk update && \
	apk add --no-cache gcc musl-dev linux-headers libffi-dev augeas-dev make autoconf openssl-dev zlib zlib-dev libpng libpng-dev supervisor tzdata && \
	docker-php-ext-install bcmath opcache pcntl gd mysqli sockets pdo pdo_mysql && \
	pecl install mongodb && \
    docker-php-ext-enable mongodb && \
	pecl install redis && \
    docker-php-ext-enable redis && \
	curl -sS https://getcomposer.org/installer | php && \
	mv composer.phar /usr/local/bin/composer && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
	apk del gcc musl-dev linux-headers libffi-dev augeas-dev make autoconf openssl-dev && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/lib/apk/* && \
    rm -rf /tmp/*

ADD conf/supervisord.conf /etc/supervisord.conf

ADD scripts/start.sh /root/start.sh

RUN chmod 755 /root/start.sh

ADD html/ /var/www/html/

CMD ["/root/start.sh"]