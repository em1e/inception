#!/bin/bash

cd /var/www/wp

if [ ! -f /var/www/wp/wp-config.php ]; then

    mariadb-admin ping --protocol=tcp --host=mariadb -u $MDB_USER --password=$MDB_USER_PWD --wait >/dev/null 2>/dev/null

    wp core download    --allow-root \
                        --version='latest'

    wp config create    --allow-root \
                        --dbname=$MDB_NAME \
                        --dbuser=$MDB_USER \
                        --dbpass=$MDB_USER_PWD \
                        --dbhost=mariadb:3306

    wp core install     --allow-root \
                        --skip-email \
                        --url=$WP_URL \
                        --title=$WP_TITLE \
                        --admin_user=$WP_ADMIN \
                        --admin_email=$WP_ADMIN_MAIL \
                        --admin_password=$WP_ADMIN_PWD
                        

    wp user create      --allow-root \
                        --path=/var/www/wp \
                        $WP_USER $WP_USER_MAIL \
                        --user_pass=$WP_USER_PWD
fi

chown -R www-data:www-data /var/www/wp

php-fpm83 -F