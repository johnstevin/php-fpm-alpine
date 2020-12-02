FROM php:7.4.12-fpm-alpine3.12

LABEL maintainer="STEVIN.JOHN <STEVIN.JOHN@QQ.COM>"

ARG ENABLE_XDEBUG=0

ENV TIMEZONE=Asia/Shanghai \
    RUN_SCRIPTS_DIRECTORY=/var/scripts/ \
    ENABLE_XDEBUG=${ENABLE_XDEBUG:-"0"}

ADD conf/repositories /etc/apk/repositories

RUN apk update && \
	apk add --no-cache gcc musl-dev linux-headers libffi-dev augeas-dev make autoconf openssl-dev zlib zlib-dev libpng libpng-dev supervisor tzdata freetype-dev libjpeg-turbo-dev libzip-dev && \
	docker-php-ext-configure gd --with-freetype --with-jpeg && \
	docker-php-ext-install bcmath opcache pcntl gd mysqli sockets pdo pdo_mysql zip && \
	pecl channel-update pecl.php.net && \
	pecl install mongodb && \
    docker-php-ext-enable mongodb && \
	pecl install redis && \
    docker-php-ext-enable redis && \
    pecl install xdebug && \
	curl -sS https://getcomposer.org/installer | php && \
	mv composer.phar /usr/local/bin/composer && \
	cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
	apk del gcc musl-dev linux-headers libffi-dev augeas-dev make autoconf openssl-dev && \
    rm -rf /var/cache/apk/* && \
    rm -rf /var/lib/apk/* && \
    rm -rf /tmp/*

ADD conf/php.ini /usr/local/etc/php/php.ini
ADD conf/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf

ADD conf/supervisord.conf /etc/supervisord.conf

ADD scripts/start.sh /start.sh

ADD html/ /var/www/html/

RUN chmod 755 /start.sh && \
	mkdir -p ${RUN_SCRIPTS_DIRECTORY}

CMD ["/bin/sh","/start.sh"]