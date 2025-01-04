#!/bin/bash

set -x

echo "Starting WordPress setup..."

wait_for_db() {
    echo "Testing database connection..."
    for i in {1..30}; do
        if mysql -h "$DB_HOST" -u "$DB_USER" -p "$DB_PASSWORD" "$DB_NAME" -e "SELECT 1;" > /dev/null 2>&1; then
            echo "Database connection successful!"
            return 0
        fi
        echo "Tentativo $i di 30: MySQL connection failed, retrying in 5 seconds..."
        sleep 5
    done
    echo "Could not connect to database after 30 attempts. Exiting."
    exit 1
}

echo "Setting up WordPress directory..."

mkdir -p /var/www/inception/
mkdir -p /var/www/inception/wp-content/
mkdir -p /var/www/inception/wp-content/themes/
mkdir -p /var/www/inception/wp-content/plugins/
mkdir -p /var/www/inception/wp-content/uploads/

chown -R www-data:www-data /var/www/inception/
chmod -R 755 /var/www/inception/

cd /var/www/inception/

if [ ! -f /var/www/inception/wp-config.php ]; then
    echo "Downloading WordPress core..."
    wp core download --allow-root --force
    
    echo "Copying wp-config.php..."
    cp /tmp/wp-config.php /var/www/inception/
    chown www-data:www-data /var/www/inception/wp-config.php
fi

echo "Waiting for database..."
wait_for_db

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install --allow-root \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    echo "Creating additional user..."
    wp user create --allow-root \
        "$WP_USER" "$WP_EMAIL" \
        --user_pass="$WP_PASSWORD" \
        --role="$WP_ROLE"
fi

chown -R www-data:www-data /var/www/inception/
chmod -R 755 /var/www/inception/
find /var/www/inception/ -type f -exec chmod 644 {} \;
find /var/www/inception/ -type d -exec chmod 755 {} \;

echo "Setup complete! Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 --nodaemonize
