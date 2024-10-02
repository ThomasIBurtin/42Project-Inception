FROM debian:bullseye

ARG CERTS_CRT
ARG CERTS_KEY

RUN mkdir -p /etc/nginx/ssl

# Update and install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx vim openssl

# Create necessary directories
RUN mkdir -p /etc/nginx/ssl /var/run/nginx

# Generate SSL certificate
RUN openssl req -x509 -nodes \
    -out $CERTS_CRT -keyout $CERTS_KEY \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=tburtin.42.fr/UID=tburtin"

# Copy custom nginx configuration
RUN mkdir -p /var/run/nginx
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Set permissions
RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Start nginx
CMD ["nginx", "-g", "daemon off;"]