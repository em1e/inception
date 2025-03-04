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

attempts=0
while ! mariadb -h $DB_HOST -u$DB_USER -p$DB_PWD; do
	attempts=$((attempts + 1))
	echo "MariaDB unavailable. Attempt $attempts: Retrying in 5 sec."
	if [ "$attempts" -ge 12 ]; then
            echo "Max attempts reached. MariaDB connection could not be established."
            exit 1
        fi
        sleep 5
done
echo "MariaDB connection established!"

echo "Listing databases: -----------"
mariadb -h$DB_HOST -u$DB_USER -p$DB_PWD $DB_NAME <<EOF
SHOW DATABASES;
EOF
echo "------------------------------"

cd /var/www/wp/

if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating database cofig..."
    wp config create --allow-root \
	--dbname=$DB_NAME \
	--dbuser=$DB_USER \
	--dbpass=$DB_PWD \
	--dbhost=mariadb:3306 \
	--path=/var/www/wp/
else
    echo "WordPress already exists. Skipping download."
fi

echo "Checking if admin user $WP_ADMIN_USER already exists..."
if wp user list --allow-root --path=/var/www/wp/ | grep -q "$WP_ADMIN_USER"; then
    echo "Admin user $WP_ADMIN_USER already exists. Skipping admin creation."
else
    echo "Creating admin user..."
    wp core install --allow-root \
        --skip-email \
        --url=$DOMAIN \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PWD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path=/var/www/wp/
fi


echo "Checking if user $WP_USER already exists..."
if wp user list --allow-root --path=/var/www/wp/ | grep -q "$WP_USER"; then
    echo "User $WP_USER already exists. Skipping user creation."
else
    echo "Creating user..."
    wp user create --allow-root \
        $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PWD \
        --role=author \
        --path=/var/www/wp/
fi

echo "Changing ownership and perms..."

chown -R data-buddies:data-buddies /var/www/wp
chmod -R 755 /var/www/wp

echo "Wordpress is working!"

sed -i 's|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|' /etc/php83/php-fpm.d/www.conf

php-fpm83 -F