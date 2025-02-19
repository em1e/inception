FROM alpine:3.20.3

RUN apk update && apk add --no-cache mariadb-client \
   php83 php83-fpm php83-mysqli php83-phar php83-mbstring

RUN addgroup -S data-buddies && \
    adduser -S -G data-buddies -g data-buddies data-buddies

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Create a symlink for `php`
RUN ln -sf /usr/bin/php83 /usr/bin/php

RUN mkdir -p /run/php/ /var/www/wp

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

#WORKDIR /var/www/wp

EXPOSE 9000

ENTRYPOINT [ "sh", "/usr/local/bin/entrypoint.sh" ]
