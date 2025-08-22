# Docker Mautic Project

## Abstract

## Mautic sources

Download sources and unzip in project folder.

## Installation

make up



## Debug with IntelliJ/PHPStorm

### httpd web server

Go to Settings > Language & Frameworks > PHP > Servers

Add new server and set:
- Name: mautic-docker-web
- Host: localhost
- Port: 8081 (or port set in docker-compose for httpd server)
- Add Path Mappings with Absolute Path on the server = /srv/mautic

### Nginx web server

TODO