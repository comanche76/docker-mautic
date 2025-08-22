#!/bin/sh
set -e

CONF_DIR="/usr/local/etc/php/conf.d"
ACTION="$1"
CHANGED=0

if [ "$ACTION" = "disable" ]; then
  for f in "$CONF_DIR"/*xdebug*.ini; do
    if [ -f "$f" ]; then
      mv "$f" "$f.disabled"
      echo "xdebug disabled"
      CHANGED=1
    fi
  done
elif [ "$ACTION" = "enable" ]; then
  for f in "$CONF_DIR"/*.ini.disabled; do
    if [ -f "$f" ]; then
      mv "$f" "${f%.disabled}"
      echo "xdebug enabled"
      CHANGED=1
    fi
  done
else
  echo "Use: $0 [enable|disable]"
  exit 1
fi

if [ "$CHANGED" -eq 0 ]; then
  if [ "$ACTION" = "disable" ]; then
    echo "xdebug already disabled"
  elif [ "$ACTION" = "enable" ]; then
    echo "xdebug already enabled"
  fi
fi

if pgrep php-fpm > /dev/null 2>&1; then
  pkill -o -USR2 php-fpm
  echo "php-fpm reloaded"
fi