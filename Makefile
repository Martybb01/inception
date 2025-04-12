NAME		= inception
DOCKER		= docker compose -f srcs/docker-compose.yml
DATA_PATH	= /home/marboccu/data

GREEN		= \033[0;32m
RED			= \033[0;31m
RESET		= \033[0m

all: setup build

setup:
	@printf "$(GREEN)🚀 Preparazione ambiente...$(RESET)\n"
	@mkdir -p $(DATA_PATH)/wordpress_files
	@mkdir -p $(DATA_PATH)/database
	@chmod 777 $(DATA_PATH)/wordpress_files
	@chmod 777 $(DATA_PATH)/database

build_n_run:
	@printf "$(GREEN)🏗️  Costruzione containers...$(RESET)\n"
	@$(DOCKER) build --no-cache
	@$(DOCKER) up -d
	@printf "$(GREEN)✅ Containers avviati con successo!$(RESET)\n"

build:
	@printf "$(GREEN)🏗️  Costruzione containers...$(RESET)\n"
	@$(DOCKER) build --no-cache
	@printf "$(GREEN)✅ Containers costruiti con successo!$(RESET)\n"

up:
	@printf "$(GREEN)▶️  Avvio containers...$(RESET)\n"
	@$(DOCKER) up -d
	@printf "$(GREEN)✅ Containers avviati con successo!$(RESET)\n"

down:
	@printf "$(RED)⏹️  Arresto containers...$(RESET)\n"
	@$(DOCKER) down
	@printf "$(GREEN)✅ Containers fermati con successo!$(RESET)\n"

restart:
	@printf "$(GREEN)🔄 Riavvio containers...$(RESET)\n"
	@$(DOCKER) restart

status:
	@printf "$(GREEN)📊 Stato dei containers:$(RESET)\n"
	@docker ps -a

clean: down
	@printf "$(RED)🧹 Pulizia containers...$(RESET)\n"
	@docker system prune -a --force
	@printf "$(RED)🗑️  Pulizia volumi...$(RESET)\n"
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@printf "$(RED)🗑️  Rimozione directories...$(RESET)\n"
	@sudo rm -rf $(DATA_PATH)/wordpress_files
	@sudo rm -rf $(DATA_PATH)/database

fclean: clean
	@printf "$(GREEN)🔄 Ricostruzione completa...$(RESET)\n"
	@make all

check:
	@printf "$(GREEN)🔍 Controllo servizi...$(RESET)\n"
	@bash srcs/check_services.sh

shell-nginx:
	@docker exec -it nginx /bin/bash

shell-wordpress:
	@docker exec -it wordpress /bin/bash

shell-mariadb:
	@docker exec -it mariadb /bin/bash

.PHONY: all setup build_n_run build up down restart status logs clean fclean check shell-nginx shell-wordpress shell-mariadb
