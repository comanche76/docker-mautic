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

ps: ## docker-compose ps | Lis process
	$(DOCKER_COMPOSE) ps

.PHONY: build up up-nodemon restart down log kill ps

CMD_ON_PROJECT = docker-compose run -u www-data --rm php
PHP_RUN = $(CMD_ON_PROJECT) php

composer.lock: composer.json
	$(PHP_RUN) -d memory_limit=4G /usr/local/bin/composer update

vendor: composer.lock
	$(PHP_RUN) -d memory_limit=4G /usr/local/bin/composer install

.PHONY: cache
cache:
	$(CMD_ON_PROJECT) rm -rf var/cache && $(PHP_RUN) bin/console cache:warmup

.PHONY: bash
bash:
	$(DOCKER_COMPOSE) exec fpm bash

## TODO
# Rebuild web assets
# RUN cd /var/www/html && \
#     npm install && \
#     php bin/console mautic:assets:generate && \
#     php bin/console cache:clear
