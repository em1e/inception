#!/bin/bash
set -e

echo "I am executing mariaDB entrypoint script"

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "I am creating a new container for mariadb"
	mysql_install_db --datadir=/var/lib/mysql --skip-test-db --user=mysql 
	mysqld --user=mysql --bootstrap << EOF


FLUSH PRIVILEGES;
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
GRANT ALL PRIVILEGES on *.* to 'root'@'%' IDENTIFIED BY '$DB_ROOT_PWD';
GRANT ALL PRIVILEGES ON *.* TO '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PWD' WITH GRANT OPTION;
GRANT SELECT ON mysql.* TO '$WP_DB_USER'@'%';
FLUSH PRIVILEGES;
EOF
	echo "Initialization is complete"
fi

echo "MariaDB is starting"
exec mysqld --user=mysql