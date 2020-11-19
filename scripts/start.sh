#!/bin/bash

# Set composer mirrors
if [ ! -z "$ENABLE_COMPOSER_MIRRORS" ]; then
  echo "Set composer mirrors"
  composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
fi

# Run composer install
if [ ! -z "$RUN_COMPOSER_INSTALL" ]; then
  echo "Run composer install"
  cd /var/www/html/ && composer install
fi

# Run composer cmd-cache-clear
if [[ "$RUN_COMPOSER_CMD_CACHE_CLEAR" == "1" ]] ; then
  echo "Run composer cmd-cache-clear"
	cd /var/www/html/ && composer cmd-cache-clear
fi

# Run composer cmd-optimize
if [[ "$RUN_COMPOSER_CMD_OPTIMIZE" == "1" ]] ; then
  echo "Run composer cmd-optimize"
	cd /var/www/html/ && composer cmd-optimize
fi

# Start supervisord and services
exec /usr/bin/supervisord -n -c /etc/supervisord.conf