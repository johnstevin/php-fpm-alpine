FROM registry.cn-hangzhou.aliyuncs.com/cool2rong/php-fpm-alpine:1.0.7

ENV ENABLE_COMPOSER_MIRRORS=1 \
    RUN_SCRIPTS=1 \
    PHP_POST_MAX_SIZE="20M" \
    PHP_UPLOAD_MAX_FILESIZE="20M" \
    FPM_PM_MAX_CHILDREN=20 \
    FPM_PM_START_SERVERS=10 \
    FPM_PM_MIN_SPARE_SERVERS=5 \
    FPM_PM_MAX_SPARE_SERVERS=20 \
    OPCACHE_VALIDATE_TIMESTAMPS=0 \
    OPCACHE_REVALIDATE_FREQ=0

ADD src/ /var/www/html/
ADD supervisor_d/ /etc/supervisor.d/
ADD scripts/ ${RUN_SCRIPTS_DIRECTORY}

RUN echo "======>Set composer mirrors" && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ && \
    echo "======>Enter to workdir" &&cd /var/www/html/ && \
    echo "======>Run composer install" && composer install -o --no-dev --classmap-authoritative && \
    echo "======>Run composer cmd-cache-clear" && composer cmd-cache-clear && \
    echo "======>Run composer cmd-optimize" && composer cmd-optimize && \
    echo "======>Run composer clear-cache" && composer clear-cache

# PROD
# composer dump-autoload -o --no-dev --classmap-authoritative
