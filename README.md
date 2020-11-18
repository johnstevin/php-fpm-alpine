# 基础镜像

```sh
docker build -t php-fpm-alpine .
# no cache
docker build --no-cache -t php-fpm-alpine .

docker run -it -p 9000:9000 --name php-test php-fpm-alpine sh

docker run -d -p 9000:9000 --name php-test php-fpm-alpine
```

`nginx配置`

```sh
server{
    listen 8082;

    access_log /usr/local/var/log/nginx/xxx.access.log;
    error_log /usr/local/var/log/nginx/xxx.error.log;

    index index.php;

    location / {
        # First attempt to serve request as file, then
        # as directory, then fall back to index.html
        # try_files $uri $uri/ =404;
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ .*\.(js|ico|css|ttf|woff|woff2|png|jpg|jpeg|svg|gif|htm)$ {
        root /Users/mac/Develop/html/xxx/src/public/;
    }

    location ~ \.php$ {
        #try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME /var/www/html/src/public$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
        fastcgi_index index.php;
        include fastcgi_params;
    }

}
```

# 上层应用

1. 运行项目内的Dockerfile生成新的镜像

`示例html目录下面`

```sh
docker build --no-cache -t pfa-test-project .
```

2. 然后启动项目容器

```sh
docker run -d -p 9001:9000 --name pfa-test-project pfa-test-project
```

`若测试所用挂载项目`

```sh
docker run -d -p 9001:9000 -v /Users/mac/Develop/html/`<project>`/src/:/var/www/html/ --name pfa-test-project php-fpm-alpine
```

加载环境变量

```sh
docker run -d -p 9001:9000 【-v /Users/mac/Develop/html/easeus-uoss/src/:/var/www/html/] [-e 'SET_COMPOSER_MIRRORS=1'] [-e 'RUN_COMPOSER_INSTALL=1'] --name pfa-<project> php-fpm-alpine
```

常用变量

- SET_COMPOSER_MIRRORS=1
- RUN_COMPOSER_INSTALL=1
- RUN_COMPOSER_CMD_CACHE_CLEAR=1
- RUN_COMPOSER_CMD_OPTIMIZE=1

