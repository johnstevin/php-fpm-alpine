# 说明

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