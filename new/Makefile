all: wordpress_data mariadb_data
	@make up

up: wordpress_data mariadb_data
	@docker compose -f srcs/docker-compose.yml up -d --build

down:
	@docker compose -f srcs/docker-compose.yml down --volumes --rmi all

clean: down
	@sudo rm -rf wordpress_data mariadb_data data

fclean: clean
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force

re: fclean
	@make all

mariadb_data:
	@mkdir -p ~/data/mariadb

wordpress_data:
	@mkdir -p ~/data/wordpress

.PHONY: all up down clean fclean re
