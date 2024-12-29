#!/bin/bash

set -e
echo "Starting MariaDB setup..."

# Create necessary directories
mkdir -p /var/lib/mysql/aria_log
mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql
chmod -R 755 /var/lib/mysql
chown -R mysql:mysql /run/mysqld
chmod -R 755 /run/mysqld

# Initialize database
echo "Initializing MariaDB database..."
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Start MariaDB in background with temporary root password
echo "Starting MariaDB in background..."
mysqld_safe --datadir=/var/lib/mysql --skip-grant-tables &

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
for i in {30..0}; do
    if mysqladmin ping &>/dev/null; then
        break
    fi
    echo "Waiting for database... $i"
    sleep 1
done

if [ "$i" = 0 ]; then
    echo >&2 'MariaDB init process failed.'
    exit 1
fi

echo "MariaDB is up - Creating users and databases"

# Configure database
mysql -uroot << EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASS_ROOT}';
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;

USE ${DB_NAME};
SHOW TABLES;
EOF

# Stop MariaDB safely
echo "Stopping temporary MariaDB instance..."
mysqladmin -u root -p${DB_PASS_ROOT} shutdown
echo "Temporary instance stopped."

echo "Starting MariaDB in foreground..."
exec mysqld --user=mysql --console --skip-networking=0 --bind-address=0.0.0.0 --aria-log-dir-path=/var/lib/mysql/aria_log
