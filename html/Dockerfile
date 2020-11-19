FROM php-fpm-alpine

ADD src/ /var/www/html/

ADD supervisor_d/ /etc/supervisor.d/

#RUN chmod -R 755 /var/www/html/storage && \
#    chown -R www-data:www-data /var/www/html/storage
