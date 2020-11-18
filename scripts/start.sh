#!/bin/bash

# Set composer register
if [[ "$SET_COMPOSER_MIRRORS" == "1" ]] ; then
  composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
fi

# Run composer install
if [[ "$RUN_COMPOSER_INSTALL" == "1" ]] ; then
  if [ -d "/var/www/html/" ]; then
    
	echo "Run composer install"

  	cd /var/www/html/ && composer install

  else
    echo "Can't find html directory"
  fi
fi

# Run composer cmd-cache-clear
if [[ "$RUN_COMPOSER_CMD_CACHE_CLEAR" == "1" ]] ; then
  if [ -d "/var/www/html/" ]; then
    
    echo "Run composer cmd-cache-clear"

  	cd /var/www/html/ && composer cmd-cache-clear

  else
    echo "Can't find html directory"
  fi
fi

# Run composer cmd-optimize
if [[ "$RUN_COMPOSER_CMD_OPTIMIZE" == "1" ]] ; then
  if [ -d "/var/www/html/" ]; then
    
    echo "Run composer cmd-optimize"

  	cd /var/www/html/ && composer cmd-optimize

  else
    echo "Can't find html directory"
  fi
fi

# Start supervisord and services
exec /usr/bin/supervisord -n -c /etc/supervisord.conf