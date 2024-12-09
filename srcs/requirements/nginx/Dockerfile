FROM debian:buster

RUN apt-get update && apt-get -y install nginx curl openssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY ./ssl /etc/nginx/ssl

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
