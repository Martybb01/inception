FROM debian:bullseye

EXPOSE 9000

ARG PHP_VERSION=8.2
ARG PHPPATH=/etc/php/${PHP_VERSION}/fpm

RUN apt-get update && \
    apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common wget gnupg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list && \
    wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-imagick \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
	mariadb-client \
	iputils-ping \
    net-tools \
    tar \
	curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN rm -f /usr/local/bin/wp
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php/ && \
    mkdir -p /var/www/inception/ && \
    mkdir -p /var/www/inception/wp-content && \
    mkdir -p /var/www/inception/wp-content/themes && \
    mkdir -p /var/www/inception/wp-content/plugins && \
    mkdir -p /var/www/inception/wp-content/uploads && \
    chown -R www-data:www-data /var/www/inception/ && \
    chmod -R 755 /var/www/inception/

COPY conf/www.conf ${PHPPATH}/pool.d/
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHPPATH}/php.ini && \
    sed -i "s/listen = \/run\/php\/php${PHP_VERSION}-fpm.sock/listen = 9000/g" ${PHPPATH}/pool.d/www.conf && \
    sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' ${PHPPATH}/pool.d/www.conf && \
    sed -i 's/;daemonize = yes/daemonize = no/g' ${PHPPATH}/pool.d/www.conf

RUN chown -R www-data:www-data /var/www/inception/

COPY tools/setup.sh /bin/
RUN chmod +x /bin/setup.sh

COPY conf/wp-config.php /tmp/

WORKDIR /var/www/inception

CMD ["/bin/setup.sh"]
