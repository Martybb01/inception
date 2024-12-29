#!/bin/bash

set -e
echo "Starting MariaDB setup..."

# Crea directory necessarie
mkdir -p /var/lib/mysql/aria_log
chown -R mysql:mysql /var/lib/mysql
chmod 777 /var/run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    
    # Initialize database
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo "Database initialized."

    # Start MariaDB in background
    echo "Starting MariaDB in background..."
    mysqld_safe --datadir=/var/lib/mysql --aria-log-dir-path=/var/lib/mysql/aria_log &

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
    mysql -u root << EOF
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASS_ROOT}';
FLUSH PRIVILEGES;

SELECT User, Host FROM mysql.user;
SHOW DATABASES;
EOF

    # Stop MariaDB safely
    echo "Stopping temporary MariaDB instance..."
    mysqladmin -u root -p${DB_PASS_ROOT} shutdown
    echo "Temporary instance stopped."
fi

echo "Starting MariaDB in foreground..."
exec mysqld --user=mysql --console --skip-networking=0 --bind-address=0.0.0.0 --aria-log-dir-path=/var/lib/mysql/aria_log
