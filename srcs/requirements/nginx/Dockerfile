FROM debian:bullseye

ARG CERTS_CRT
ARG CERTS_KEY

RUN mkdir -p /etc/nginx/ssl

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx vim openssl

RUN mkdir -p /etc/nginx/ssl /var/run/nginx

RUN openssl req -x509 -nodes \
    -out $CERTS_CRT -keyout $CERTS_KEY \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=tburtin.42.fr/UID=tburtin"

RUN mkdir -p /var/run/nginx
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]