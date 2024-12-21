#!/bin/bash

mysqld_safe --datadir="/var/lib/mysql" &
sleep 5

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%'       IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_PASS_ROOT'
    WITH GRANT OPTION;

SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"$DB_PASS_ROOT" shutdown
exec mysqld_safe --datadir="/var/lib/mysql"
