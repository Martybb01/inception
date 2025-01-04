FROM debian:bullseye

RUN apt-get update && apt-get -y install nginx curl openssl

ARG CERT_FOLDER=/etc/nginx/ssl
ARG CERTIFICATE=/etc/nginx/ssl/nginx.crt
ARG KEY=/etc/nginx/ssl/nginx.key
ARG COUNTRY=IT
ARG STATE=TUS
ARG LOCALITY=Florence
ARG ORGANIZATION=42
ARG UNIT=42
ARG COMMON_NAME=marboccu.42.fr

ARG	CERT_FOLDER CERTIFICATE KEY COUNTRY STATE LOCALITY ORGANIZATION UNIT COMMON_NAME

RUN mkdir -p ${CERT_FOLDER} && \
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-out ${CERTIFICATE} -keyout ${KEY} \
	-subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${COMMON_NAME}"

COPY conf/nginx.conf /etc/nginx/
COPY conf/server.conf /etc/nginx/conf.d

EXPOSE 443

RUN	mkdir -p /var/www/
RUN	chown -R www-data:www-data /var/www/

CMD ["nginx", "-g", "daemon off;"]
