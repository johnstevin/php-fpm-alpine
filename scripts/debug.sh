#!/bin/bash

while getopts ":c:a:b:d:e" opt
do
    case $opt in
        c)
	        docker rm pfa-test-project
			docker rmi pfa-test-project
			docker rmi php-fpm-alpine
			docker rmi $(docker images -f "dangling=true" -q)
	        ;;
        a)
			cd /Users/mac/Docker/php-fpm-alpine
			docker build --no-cache -t php-fpm-alpine .
			;;
		b)
			cd /Users/mac/Docker/php-fpm-alpine/html
			docker build --no-cache -t pfa-test-project .
			;;
		d)
			docker run -d -p 9001:9000 -e "ENABLE_COMPOSER_MIRRORS=true" -e "RUN_COMPOSER_INSTALL=true" --name pfa-test-project pfa-test-project
			;;
		e)
			docker stop pfa-test-project
			docker rm pfa-test-project
			;;
        ?)
        echo "未知参数"
        exit 1;;
    esac
done