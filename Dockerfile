FROM php:7.4.12-fpm-alpine3.12

LABEL maintainer="STEVIN.JOHN <stevin.john@qq.com>"

ENV TIMEZONE Asia/Shanghai
ENV RUN_SCRIPTS_DIRECTORY /var/scripts/

ADD conf/repositories /etc/apk/repositories

RUN apk update && \
	apk add --no-cache gcc musl-dev linux-headers libffi-dev augeas-dev make autoconf openssl-dev zlib zlib-dev libpng libpng-dev supervisor tzdata freetype-dev libjpeg-turbo-dev && \
	docker-php-ext-configure gd --with-freetype --with-jpeg && \
	docker-php-ext-install bcmath opcache pcntl gd mysqli sockets pdo pdo_mysql && \
	pecl channel-update pecl.php.net && \
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

ADD scripts/start.sh /start.sh

ADD html/ /var/www/html/

RUN chmod 755 /start.sh && \
	mkdir -p ${RUN_SCRIPTS_DIRECTORY}

CMD ["/bin/sh","/start.sh"]