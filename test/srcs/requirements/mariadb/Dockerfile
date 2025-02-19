FROM alpine:3.20.3

RUN apk update && apk add mariadb mariadb-client

COPY mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
RUN chmod 644 /etc/my.cnf.d/mariadb-server.cnf

COPY mariadb_setup.sh /bin/mariadb_setup.sh
RUN chmod +x /bin/mariadb_setup.sh

CMD ["mariadb_setup.sh"]

EXPOSE 3306
