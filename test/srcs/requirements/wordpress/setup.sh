#!/bin/bash

echo "Changing to higher memory limit..."

# Increase PHP memory limit
echo "memory_limit = 512M" >> /etc/php83/php.ini

echo "Debug: -------"
echo "DB_NAME=$DB_NAME"
echo "DB_USER=$DB_USER"
echo "DB_PWD=$DB_PWD"
echo "DB_HOST=$DB_HOST"
echo "--------------"

if [ ! -f /var/www/wp/wp-config.php ]; then

    mariadb-admin ping --protocol=tcp --host=mariadb -u $DB_USER --password=$DB_PWD --wait >/dev/null 2>/dev/null

    wp core download    --allow-root \
                        --version='latest'

    wp config create    --allow-root \
                        --dbname=$DB_NAME \
                        --dbuser=$DB_USER \
                        --dbpass=$DB_PWD \
                        --dbhost=mariadb:3306

    wp core install     --allow-root \
                        --skip-email \
                        --url=$DOMAIN \
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
