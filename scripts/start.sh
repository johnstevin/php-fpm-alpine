#!/bin/bash

# Set composer mirrors
if [ ! -z "$ENABLE_COMPOSER_MIRRORS" ]; then
  	echo "======>Set composer mirrors"
  	composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
fi

# Run composer install
if [ ! -z "$RUN_COMPOSER_INSTALL" ]; then
  	echo "======>Run composer install"
  	cd /var/www/html/ && composer install
fi

# Run composer cmd-cache-clear
if [ ! -z "$RUN_COMPOSER_CMD_CACHE_CLEAR" ] ; then
  	echo "======>Run composer cmd-cache-clear"
	cd /var/www/html/ && composer cmd-cache-clear
fi

# Run composer cmd-optimize
if [ ! -z "$RUN_COMPOSER_CMD_OPTIMIZE" ] ; then
  	echo "======>Run composer cmd-optimize"
	cd /var/www/html/ && composer cmd-optimize
fi

# Run project scripts
if [ ! -z "$RUN_SCRIPTS" ] ; then
	echo "======>Run project scripts"
	if [ -d "${RUN_SCRIPTS_DIRECTORY}" ]; then
		# make scripts executable incase they aren't
		chmod -Rf 750 ${RUN_SCRIPTS_DIRECTORY}*; sync;
		# run scripts in number order
		for i in `ls ${RUN_SCRIPTS_DIRECTORY}`; do sh ${RUN_SCRIPTS_DIRECTORY}$i ; done
	else
		echo "Can't find script directory"
	fi
fi

# Start supervisord and services
exec /usr/bin/supervisord -n -c /etc/supervisord.conf