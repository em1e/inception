FROM alpine:3.20.3

RUN apk update && apk add bash wget php83 php83-fpm php83-phar php83-curl php83-cgi php83-mysqli php83-iconv mariadb-client

COPY www.conf /etc/php83/php-fpm.d/www.conf
COPY w_entrypoint.sh /bin/w_entrypoint.sh
RUN chmod +x /bin/w_entrypoint.sh

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/wp
RUN adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data

CMD ["w_entrypoint.sh"]

EXPOSE 9000