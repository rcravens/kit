#!/usr/bin/env bash

if [[ $# -gt 0 ]]; then
    exec "$@"
else
   # Start PHP-FPM and Nginx
    echo "Starting PHP-FPM"
    service php8.3-fpm start
    service php8.3-fpm status
    echo "Starting Nginx"
    nginx -g "daemon off;"
fi