FROM debian:bullseye

RUN	apt-get update && apt-get -y install mariadb-server

COPY conf/50-server.conf /etc/mysql/mariadb.conf.d/

COPY tools/setup.sh /bin/
RUN	chmod +x /bin/setup.sh

EXPOSE 3306

CMD	["/bin/setup.sh"]
