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
			cd /Users/mac/Develop/docker/php-fpm-alpine
			docker build -t php-fpm-alpine .
			;;
		b)
			cd /Users/mac/Develop/docker/php-fpm-alpine/html
			docker build --no-cache -t pfa-test-project .
			;;
		d)
			docker run -d -p 9010:9000 -v /Users/mac/Develop/docker/php-fpm-alpine/html/src/:/var/www/html/ --name pfa-test-project pfa-test-project
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