#!/bin/bash

mkdir -p ${DATA_PATH}/database
mkdir -p ${DATA_PATH}/wordpress_files

if [[ "$OSTYPE" == "darwin"* ]]; then
    chmod 777 ${DATA_PATH}/database
    chmod 777 ${DATA_PATH}/wordpress_files
else
    chmod 755 ${DATA_PATH}/database
    chmod 755 ${DATA_PATH}/wordpress_files
    chown -R 999:999 ${DATA_PATH}/database
    chown -R www-data:www-data ${DATA_PATH}/wordpress_files
fi
