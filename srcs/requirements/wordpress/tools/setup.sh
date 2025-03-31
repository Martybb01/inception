#!/bin/bash

set -x

echo "Starting WordPress setup..."

set_permissions() {
    echo "Setting correct permissions..."
    find /var/www/inception -type d -exec chmod 755 {} \;
    find /var/www/inception -type f -exec chmod 644 {} \;
    chown -R www-data:www-data /var/www/inception
    chmod -R 755 /var/www/inception
    echo "Permissions set successfully."
}

wait_for_db() {
    echo "Testing database connection..."
    for i in {1..30}; do
        if mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "SELECT 1;" > /dev/null 2>&1; then
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

set_permissions

cd /var/www/inception/

if [ ! -f /var/www/inception/wp-config.php ]; then
    echo "Downloading WordPress core..."
    wp core download --allow-root --force

    echo "Creating wp-config.php using wp-cli..."
    wp config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --dbprefix="wp_" \
        --extra-php <<PHP
define('WP_HOME', getenv('WP_FULL_URL'));
define('WP_SITEURL', getenv('WP_FULL_URL'));
define('FORCE_SSL_ADMIN', true);
define('AUTOMATIC_UPDATER_DISABLED', true);
PHP
    set_permissions
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
    
    set_permissions
fi

set_permissions

echo "Setup complete! Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 --nodaemonize
