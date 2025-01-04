#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

check_container() {
    local container_name=$1
    if [ "$(docker container inspect -f '{{.State.Status}}' $container_name 2>/dev/null)" == "running" ]; then
        echo -e "${GREEN}✓${NC} $container_name is running"
        return 0
    else
        echo -e "${RED}✗${NC} $container_name is not running"
        return 1
    fi
}

check_db_connection() {
    local db_host=$(docker exec wordpress printenv DB_HOST)
    local db_user=$(docker exec wordpress printenv DB_USER)
    local db_pass=$(docker exec wordpress printenv DB_PASSWORD)
    local db_name=$(docker exec wordpress printenv DB_NAME)

    echo "Checking MariaDB connection from WordPress..."
    if docker exec wordpress mysql -h "$db_host" -u "$db_user" -p"$db_pass" "$db_name" -e "SELECT 1;" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Database connection successful"
        return 0
    else
        echo -e "${RED}✗${NC} Database connection failed"
        return 1
    fi
}

check_nginx() {
    echo "Checking NGINX..."
    if curl -k https://localhost:443 >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} NGINX is responding on port 443"
        return 0
    else
        echo -e "${RED}✗${NC} NGINX is not responding"
        return 1
    fi
}

echo "Starting services check..."

check_container "nginx"
check_container "wordpress"
check_container "mariadb"

sleep 5

check_db_connection

check_nginx

echo "Check complete!"
