# Uses latest stable alpine version
FROM alpine:3.20.3

# Update system and install packages
RUN apk update && apk add mariadb mariadb-client

# Copy config file
COPY server.cnf /etc/my.cnf.d/server.cnf
RUN chmod 644 /etc/my.cnf.d/server.cnf

# Copy entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose default port
EXPOSE 3306