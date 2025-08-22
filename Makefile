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

.PHONY: fpm-ssh
fpm-ssh:
	$(DOCKER_COMPOSE) exec fpm bash

CMD_ON_PROJECT = docker-compose run -u www-data --rm php
PHP_RUN = $(CMD_ON_PROJECT) php

composer.lock: composer.json
	$(PHP_RUN) -d memory_limit=4G /usr/local/bin/composer update

vendor: composer.lock
	$(PHP_RUN) -d memory_limit=4G /usr/local/bin/composer install

.PHONY: cache
cache:
	$(CMD_ON_PROJECT) rm -rf var/cache && $(PHP_RUN) -d memory_limit=4G bin/console cache:warmup

npm-install:
	$(CMD_ON_PROJECT) npm install

.PHONY: assets
assets:
	$(PHP_RUN) -d memory_limit=4G bin/console mautic:assets:generate

.PHONY: dependencies
dependencies: vendor

.PHONY: mautic
mautic:
	$(MAKE) dependencies
	$(MAKE) npm-install
	$(MAKE) assets
	$(MAKE) cache

.PHONY: xdebug-enable
xdebug-enable:
	$(DOCKER_COMPOSE) exec fpm toggle-xdebug.sh enable

.PHONY: xdebug-disable
xdebug-disable:
	$(DOCKER_COMPOSE) exec fpm toggle-xdebug.sh disable