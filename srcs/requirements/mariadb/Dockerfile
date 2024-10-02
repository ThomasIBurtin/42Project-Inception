FROM debian:bullseye

ARG         MYSQL_DATABASE
ARG         MYSQL_USER
ARG         MYSQL_PASSWORD
ARG         MYSQL_ROOT_PASSWORD

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y mariadb-server mariadb-client


#allow mysqld daemon to run, purge and recreate /var/lib/mysql with appropriate ownership
RUN			mkdir -p /var/lib/mysql /var/run/mysqld
RUN			chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
RUN			chmod 777 /var/run/mysqld

# Copy the MariaDB configuration file
COPY        ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/
RUN         chmod 644 /etc/mysql/mariadb.conf.d/mariadb.cnf


COPY        ./tools/maria_script.sh /usr/local/bin/
RUN         bash /usr/local/bin/maria_script.sh

EXPOSE      3306

ENTRYPOINT ["mysqld_safe"]


