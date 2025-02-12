FROM alpine:3.20.3

# Update system and install packages
RUN apk update && apk add --no-cache \
    mariadb mariadb-client mariadb-common bash

# create mysql folders
RUN mkdir -p /run/mysqld /var/log/mysql
RUN chown -R mysql:mysql /run/mysqld /var/log/mysql


# Copy config file
COPY conf/my.cnf /etc/my.cnf.d/my.cnf
RUN chmod 644 /etc/my.cnf.d/my.cnf

# Copy entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3306