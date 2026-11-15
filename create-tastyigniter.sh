#!/bin/bash
set -e

TI_DIR=/var/www/tastyigniter

# First boot: bootstrap a fresh TastyIgniter v4 install into the (empty) bind mount.
if [ ! -e "$TI_DIR/artisan" ]; then
    echo "[tastyigniter] No install found in $TI_DIR, running composer create-project..."
    composer create-project --no-interaction tastyigniter/tastyigniter:^4.0 "$TI_DIR"

    # Keep .env consistent with the compose environment (compose env vars win at runtime anyway).
    sed -i \
        -e "s/^DB_HOST=.*/DB_HOST=${DB_HOST:-db}/" \
        -e "s/^DB_PORT=.*/DB_PORT=${DB_PORT:-3306}/" \
        -e "s/^DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE:-tastyigniter}/" \
        -e "s/^DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME:-tastyigniter}/" \
        -e "s/^DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD:-password}/" \
        "$TI_DIR/.env"

    cd "$TI_DIR"
    php artisan igniter:install --no-interaction
    echo "[tastyigniter] Install complete. Set an admin password with:"
    echo "  docker compose exec app php artisan igniter:passwd admin@domain.tld"
fi

exec "$@"
