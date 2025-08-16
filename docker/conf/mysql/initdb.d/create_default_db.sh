#!/bin/sh

mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE mautic"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON mautic.* TO '${MYSQL_USER}'@'%'"