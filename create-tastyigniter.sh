#!/bin/bash

if [ ! -e '/var/www/tastyigniter/app' ]; then
    composer create-project tastyigniter/tastyigniter:^v4.0 /var/www/tastyigniter
    sed -i "/DB_HOST=.*/DB_HOST=db/" /var/www/tastyigniter/.env
    sed -i "/DB_DATABASE=.*/DB_DATABASE=tastyigniter/" /var/www/tastyigniter/.env
    sed -i "/DB_USERNAME=.*/DB_USERNAME=tastyigniter/" /var/www/tastyigniter/.env
    sed -i "/DB_PASSWORD=.*/DB_PASSWORD=password/" /var/www/tastyigniter/.env
    php artisan igniter:install --no-interaction
fi

exec "$@"
