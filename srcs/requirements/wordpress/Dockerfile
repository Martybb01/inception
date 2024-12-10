FROM debian:latest

RUN apt-get update && apt-get install -y \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    wget \
    unzip && \
    wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && apt-get install -y \
    php8.1-fpm \
    php8.1-mysql \
    php8.1-curl

RUN wget https://wordpress.org/latest.zip && unzip latest.zip && rm latest.zip

# COPY ./srcs/requirements/wordpress/wp-config.php /wordpress/wp-config.php

CMD ["php-fpm8.1", "-F"]
