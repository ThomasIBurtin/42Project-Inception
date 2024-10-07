

NAME			= Inception
USER			= tburtin

SYSTEM_USER		= $(shell echo $$USER)

SRC_DIR			= ./srcs
VOL_DIR			= /home/tburtin/data

WP_NAME			= wordpress
MDB_NAME		= mariadb

all:		volumes hosts up

volumes:
			sudo mkdir -p ${VOL_DIR}/${WP_NAME}
			sudo docker volume create --driver local --opt type=none --opt device=${VOL_DIR}/${WP_NAME} --opt o=bind ${WP_NAME}
			sudo mkdir -p ${VOL_DIR}/${MDB_NAME}
			sudo docker volume create --driver local --opt type=none --opt device=${VOL_DIR}/${MDB_NAME} --opt o=bind ${MDB_NAME}

hosts:
			@if ! grep -qFx "127.0.0.1 ${USER}.42.fr" /etc/hosts; then \
				sudo sed -i '2i\127.0.0.1\t${USER}.42.fr' /etc/hosts; \
			fi

up:
			sudo docker compose -f ${SRC_DIR}/docker-compose.yml up -d --build
down:
			@docker compose -f ${SRC_DIR}/docker-compose.yml down

clean:		down
			docker volume rm ${WP_NAME}
			sudo rm -rf ${VOL_DIR}/${WP_NAME}
			docker volume rm ${MDB_NAME}
			sudo rm -rf ${VOL_DIR}/${MDB_NAME}
			sudo sed -i '/127\.0\.0\.1\t${USER}\.42\.fr/d' /etc/hosts

fclean:		clean
			docker system prune -af

re:			clean all
