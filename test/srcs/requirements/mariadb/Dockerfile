FROM alpine:3.20.3

RUN apk update && apk add mariadb mariadb-client

COPY server.cnf /etc/my.cnf.d/server.cnf
RUN chmod 644 /etc/my.cnf.d/server.cnf

COPY m_entrypoint.sh /bin/m_entrypoint.sh
RUN chmod +x /bin/m_entrypoint.sh

CMD ["m_entrypoint.sh"]

EXPOSE 3306
