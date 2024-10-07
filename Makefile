

NAME			= Inception
USER			= tburtin

SYSTEM_USER		= $(shell echo $$USER)

SRC_DIR			= ./srcs
VOL_DIR			= /home/tburtin/data

WP_NAME			= wordpress
MDB_NAME		= mariadb

all:		volumes hosts up
			@echo "\n"
			@echo "${GREEN}#-------------------------------------------------------------------------------#${NC}"
			@echo "${GREEN}#\t\tWordpress is running at ${USER}.42.fr\t\t\t\t#${NC}"
			@echo "${GREEN}#\t\tTo access wordpress admin, go to ${USER}.42.fr/wp-admin\t#${NC}"
			@echo "${GREEN}#-------------------------------------------------------------------------------#${NC}"
			@echo "\n"

volumes:
			@echo "${YELLOW}-----Creating Docker Volumes-----${NC}"
			sudo mkdir -p ${VOL_DIR}/${WP_NAME}
			sudo docker volume create --driver local --opt type=none --opt device=${VOL_DIR}/${WP_NAME} --opt o=bind ${WP_NAME}
			sudo mkdir -p ${VOL_DIR}/${MDB_NAME}
			sudo docker volume create --driver local --opt type=none --opt device=${VOL_DIR}/${MDB_NAME} --opt o=bind ${MDB_NAME}
			@echo "${GREEN}-----Volumes Created-----${NC}"

hosts:
			@echo "${YELLOW}-----Editing hosts file with domain name-----${NC}"
			@if ! grep -qFx "127.0.0.1 ${USER}.42.fr" /etc/hosts; then \
				sudo sed -i '2i\127.0.0.1\t${USER}.42.fr' /etc/hosts; \
			fi
			@echo "${GREEN}-----Hosts file edited-----${NC}"

up:
			@echo "${YELLOW}-----Starting Docker-----${NC}"
			sudo docker compose -f ${SRC_DIR}/docker-compose.yml up -d --build
			@echo "${GREEN}-----Docker Started-----${NC}"

down:
			@echo "${YELLOW}-----Stopping Docker-----${NC}"
			@docker compose -f ${SRC_DIR}/docker-compose.yml down
			@echo "${GREEN}-----Docker Stopped-----${NC}"

clean:		down
			@echo "${YELLOW}-----Removing Docker Volumes-----${NC}"
			docker volume rm ${WP_NAME}
			sudo rm -rf ${VOL_DIR}/${WP_NAME}
			docker volume rm ${MDB_NAME}
			sudo rm -rf ${VOL_DIR}/${MDB_NAME}
			@echo "${RED}-----Volumes Removed-----${NC}"
			@echo "${YELLOW}-----Removing domain name from hosts file-----${NC}"
			sudo sed -i '/127\.0\.0\.1\t${USER}\.42\.fr/d' /etc/hosts
			@echo "${RED}-----Hosts file edited-----${NC}"

fclean:		clean
			docker system prune -af

re:			clean all



PHONY:		all clean fclean re prepare

# Colors
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
NC = \033[0m