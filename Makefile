## DOCKER CONSTANTS
DOCKER_COMPOSE = docker-compose
DOCKER_DB_SERVICE = mysql
DOCKER_PHP_SERVICE = php

build: ## docker-compose up --build
	$(DOCKER_COMPOSE) up --build

up: ## docker-compose ps
	$(DOCKER_COMPOSE) up -d

up-nodemon:
	$(DOCKER_COMPOSE) up

restart: ## docker-compose restart container
	$(DOCKER_COMPOSE) restart

down: ## docker-compose down
	$(DOCKER_COMPOSE) down

log: ## docker-compose log | Show log of a container
	$(DOCKER_COMPOSE) logs

kill: ## docker-compose kill | Kill container
	$(DOCKER_COMPOSE) kill

.PHONY: build up up-nodemon restart down log kill