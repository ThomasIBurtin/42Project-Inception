all:		volumes hosts up

volumes:
			sudo mkdir -p /home/vboxuser/data/wordpress
			sudo docker volume create --driver local --opt type=none --opt device=/home/vboxuser/data/wordpress --opt o=bind wordpress
			sudo mkdir -p /home/vboxuser/data/mariadb
			sudo docker volume create --driver local --opt type=none --opt device=/home/vboxuser/data/mariadb --opt o=bind mariadb

hosts:
			@if ! grep -qFx "127.0.0.1 tburtin.42.fr" /etc/hosts; then \
				sudo sed -i '2i\127.0.0.1\ttburtin.42.fr' /etc/hosts; \
			fi

up:
			sudo docker compose -f ./srcs/docker-compose.yml up -d --build
down:
			@docker compose -f ./srcs/docker-compose.yml down

clean:		down
			docker volume rm wordpress
			sudo rm -rf /home/vboxuser/data/wordpress
			docker volume rm mariadb
			sudo rm -rf /home/vboxuser/data/mariadb
			sudo sed -i '/127\.0\.0\.1\ttburtin\.42\.fr/d' /etc/hosts

fclean:		clean
			docker system prune -af

re:			clean all
