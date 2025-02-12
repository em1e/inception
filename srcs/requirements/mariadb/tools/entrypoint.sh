#!/bin/sh

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld /var/log/mysql
	chown -R mysql:mysql /run/mysqld /var/log/mysql
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
	chown -R mysql:mysql /var/lib/mysql
	echo "installing mariadb"
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
	echo "mariadb installed"
	echo "creating mariadb database"
	mysqld --bootstrap --datadir=/var/lib/mysql --user=mysql << EOF
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MDB_ROOT_PWD';
CREATE DATABASE $MDB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$MDB_USER'@'%' IDENTIFIED by '$MDB_USER_PWD';
GRANT ALL PRIVILEGES ON $MDB_NAME.* TO '$MDB_USER'@'%';
FLUSH PRIVILEGES;
EOF
	echo "mariadb database created"
fi

mysqld_safe