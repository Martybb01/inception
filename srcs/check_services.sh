#!/bin/bash

echo "Checking Docker services..."
docker ps -a

echo -e "\nChecking MariaDB logs..."
docker logs mariadb 2>&1 | tail -n 20

echo -e "\nChecking WordPress logs..."
docker logs wordpress 2>&1 | tail -n 20

echo -e "\nChecking Nginx logs..."
docker logs nginx 2>&1 | tail -n 20

echo -e "\nChecking network connectivity..."
docker exec wordpress ping -c 2 mariadb
docker exec wordpress ping -c 2 nginx

echo -e "\nChecking MariaDB connection from WordPress..."
docker exec wordpress mysqladmin ping -h mariadb -u "${DB_USER}" --password="${DB_PASSWORD}" || echo "Failed to connect to MariaDB"
