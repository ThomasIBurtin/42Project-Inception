FROM debian:bullseye

ARG MYSQL_HOSTNAME
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_PASSWORD
ARG MYSQL_USER
ARG MYSQL_DATABASE
ARG WP_USER
ARG WP_USER_PASSWORD
ARG WP_ADMIN
ARG WP_PASSWORD

# Update and install necessary packages
RUN apt-get update -y && apt-get upgrade -y
RUN apt -y install wget php7.4-fpm php7.4-mysql mariadb-client

# Configure PHP so it can communicate with NGINX
RUN         mv /etc/php/7.4/fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf.default
COPY        ./conf/www.conf /etc/php/7.4/fpm/pool.d/
RUN         ln -s $(find /usr/sbin -name 'php-fpm*') /usr/bin/php-fpm

# Expose port
EXPOSE      9000

# Create PID directory for PHP-FPM
RUN         mkdir -p /run/php
RUN         chmod 755 /run/php

# Execute Wordpress Initialization script
COPY        ./tools/init.sh /usr/local/bin/
RUN         chmod 755 /usr/local/bin/init.sh
RUN         bash /usr/local/bin/init.sh

# Copy wpscript script
COPY        ./tools/wpscript.sh /usr/local/bin/
RUN         chmod 755 /usr/local/bin/wpscript.sh

# Use the wrapper script as the entrypoint
ENTRYPOINT ["bash", "/usr/local/bin/wpscript.sh"]

