FROM php-fpm-alpine

# 此变量影响运行时在Docker构建完容器启动后执行
ENV ENABLE_COMPOSER_MIRRORS true
ENV RUN_COMPOSER_INSTALL true
#ENV RUN_COMPOSER_CMD_CACHE_CLEAR true
#ENV RUN_COMPOSER_CMD_OPTIMIZE true
#ENV RUN_SCRIPTS true
#ENV RUN_COMPOSER_CLEAR_CACHE=1

ADD src/ /var/www/html/
ADD supervisor_d/ /etc/supervisor.d/
ADD scripts/ ${RUN_SCRIPTS_DIRECTORY}

# 根据项目而定，一般采用Docker构建时composer
RUN echo "======>Set composer mirrors" && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ && \
    echo "======>Enter to workdir" &&cd /var/www/html/ && \
    echo "======>Run composer install" && composer install && \
    echo "======>Run composer cmd-cache-clear" && composer cmd-cache-clear && \
    echo "======>Run composer cmd-optimize" && composer cmd-optimize && \
    echo "======>Run composer clear-cache" && composer clear-cache