FROM alpine:3.20.3

RUN apk update && apk add --no-cache mariadb mariadb-client mariadb-common bash

COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY ./tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql
RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld
RUN mkdir -p /var/log/mysql && chown -R mysql:mysql /var/log/mysql

EXPOSE 3306

ENTRYPOINT [ "entrypoint.sh" ]
