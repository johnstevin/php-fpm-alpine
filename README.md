# 说明

```sh
docker build -t php-fpm-alpine .
# no cache
docker build --no-cache -t php-fpm-alpine .

docker run -it -p 9000:9000 --name php-test php-fpm-alpine sh

docker run -d -p 9000:9000 --name php-test php-fpm-alpine
```