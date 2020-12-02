#!/bin/bash


# Increase the memory_limit
if [ ! -z "$PHP_MEM_LIMIT" ]; then
    sed -i "s/memory_limit = 128M/memory_limit = ${PHP_MEM_LIMIT}M/g" /usr/local/etc/php/php.ini
fi

# Increase the post_max_size
if [ ! -z "$PHP_POST_MAX_SIZE" ]; then
    sed -i "s/post_max_size = 8M/post_max_size = ${PHP_POST_MAX_SIZE}M/g" /usr/local/etc/php/php.ini
fi

# Increase the upload_max_filesize
if [ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ]; then
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize= ${PHP_UPLOAD_MAX_FILESIZE}M/g" /usr/local/etc/php/php.ini
fi

if [ ! -z "$FPM_PM_MAX_CHILDREN" ]; then
    sed -i "s/pm.max_children = 5/pm.max_children = ${FPM_PM_MAX_CHILDREN}/g" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$FPM_PM_START_SERVERS" ]; then
    sed -i "s/pm.start_servers = 2/pm.start_servers = ${FPM_PM_START_SERVERS}/g" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$FPM_PM_MIN_SPARE_SERVERS" ]; then
    sed -i "s/pm.min_spare_servers = 1/pm.min_spare_servers = ${FPM_PM_MIN_SPARE_SERVERS}/g" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$FPM_PM_MAX_SPARE_SERVERS" ]; then
    sed -i "s/pm.max_spare_servers = 3/pm.max_spare_servers = ${FPM_PM_MAX_SPARE_SERVERS}/g" /usr/local/etc/php-fpm.d/www.conf
fi

# Enable xdebug
XdebugFile='/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
if [[ "$ENABLE_XDEBUG" == "1" ]] ; then
  if [ -f $XdebugFile ]; then
  	echo "Xdebug enabled"
  else
  	echo "Enabling xdebug"
  	echo "If you get this error, you can safely ignore it: /usr/local/bin/docker-php-ext-enable: line 83: nm: not found"
  	# see https://github.com/docker-library/php/pull/420
    docker-php-ext-enable xdebug
    # see if file exists
    if [ -f $XdebugFile ]; then
        # See if file contains xdebug text.
        if grep -q xdebug.remote_enable "$XdebugFile"; then
            echo "Xdebug already enabled... skipping"
        else
            echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > $XdebugFile # Note, single arrow to overwrite file.
            echo "xdebug.remote_enable=1 "  >> $XdebugFile
            echo "xdebug.remote_host=host.docker.internal" >> $XdebugFile
            echo "xdebug.remote_log=/tmp/xdebug.log"  >> $XdebugFile
            echo "xdebug.remote_autostart=false "  >> $XdebugFile # I use the xdebug chrome extension instead of using autostart
            # NOTE: xdebug.remote_host is not needed here if you set an environment variable in docker-compose like so `- XDEBUG_CONFIG=remote_host=192.168.111.27`.
            #       you also need to set an env var `- PHP_IDE_CONFIG=serverName=docker`
        fi
    fi
  fi
else
    if [ -f $XdebugFile ]; then
        echo "Disabling Xdebug"
      rm $XdebugFile
    fi
fi

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