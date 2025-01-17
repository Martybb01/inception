FROM debian:bullseye

RUN	apt-get update && apt-get -y install mariadb-server

RUN mkdir -p /run/mysqld && \
    mkdir -p /var/lib/mysql/aria_log && \
    chown -R mysql:mysql /var/lib/mysql && \
    chown mysql:mysql /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY tools/setup.sh /bin/
RUN	chmod +x /bin/setup.sh

EXPOSE 3306

CMD	["/bin/setup.sh"]
