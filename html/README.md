# Test

uoss


```sh
# 创建镜像
docker build --no-cache --build-arg ENABLE_XDEBUG=1 -t php-fpm-alpine:1.0.5 .

# 启动容器
docker run -d -p 9001:9000 -v /Users/mac/Develop/html/easeus-uoss/src/:/var/www/html/ -e 'ENABLE_COMPOSER_MIRRORS=1' --name pfa-uoss php-fpm-alpine:1.0.5
```