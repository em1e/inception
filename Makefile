DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml

all: mariadb_data wordpress_data
	make up

up: mariadb_data wordpress_data
	@$(DOCKER_COMPOSE) up -d --build

down:
	@$(DOCKER_COMPOSE) down

clean: down
	@$(DOCKER_COMPOSE) down --volumes --rmi all

fclean: clean
	chown -Rv $(whoami):$(whoami) ./data/mariadb/* ./srcs/mariadb
	chmod -R 755 ./data ./srcs/mariadb
	rm -rf ./data ./srcs/mariadb
	# chown -Rv $(whoami):$(whoami) ./data/mariadb/* ./srcs/mariadb
	# chmod -R 755 ./data
	# chmod -R 777 ./data/mariadb/mysql ./data/mariadb/performance_schema ./data/mariadb/sys ./data/mariadb/test
	# rm -rf ./data ./srcs/mariadb

re: fclean
	make all

ps:
	@$(DOCKER_COMPOSE) ps

logs:
	@$(DOCKER_COMPOSE) logs

volumes:
	docker volume ls
	docker volume inspect mariadb
	docker volume inspect wordpress

mariadb_data:
	mkdir -p ./data/mariadb

wordpress_data:
	mkdir -p ./data/wordpress

.PHONY: all up down re clean fclean ps logs volumes