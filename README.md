# Docker setup for TastyIgniter v4 development

A `docker compose` setup for TastyIgniter v4 development, mainly for personal use.
It's only been tested on an Ubuntu host with plain `docker`, so your mileage may vary on Windows, Mac, other Linux distros, Docker Desktop, etc.

| Service     | What it runs                         | Host URL / port                     |
|-------------|--------------------------------------|-------------------------------------|
| `app`       | PHP 8.3 FPM, Composer, Xdebug (off)  | –                                   |
| `webserver` | nginx                                | http://localhost:8080               |
| `db`        | MySQL 8.4                            | `127.0.0.1:3306` (tastyigniter / password) |
| `mailpit`   | Catches all outgoing mail            | http://localhost:8025               |

## Usage

Install `docker` with the compose plugin, clone this repo, and from the repo directory run:

```
./build.sh
docker compose exec app php artisan igniter:passwd admin@domain.tld
```

On first boot the `app` container runs `composer create-project` into `./tastyigniter` and then `igniter:install`. You can watch it with `docker compose logs -f app`. When it's finished:

- Storefront: http://localhost:8080/
- Admin: http://localhost:8080/admin (`admin@domain.tld` / the password you set above)

`./tastyigniter` is bind-mounted into the app container at `/var/www/tastyigniter`. `build.sh` builds the image with your host UID/GID so the files stay owned by you.

## Day-to-day commands

```
docker compose up -d                     # start
docker compose down                      # stop (the DB volume is kept)
docker compose exec app bash             # shell inside the PHP container
docker compose exec app php artisan ...  # artisan
docker compose exec app composer ...     # composer
docker compose exec db mysql -uroot -ppassword tastyigniter
```

Clearing caches after changing extensions or themes:

```
docker compose exec app php artisan optimize:clear
docker compose exec app rm -f bootstrap/cache/classes.php
docker compose exec app php artisan vendor:publish --tag=igniter-assets --force
```

## Xdebug

Xdebug is installed but off by default. To turn it on:

```
XDEBUG_MODE=debug docker compose up -d app
```

It connects to `host.docker.internal:9003`. In your IDE, map `/var/www/tastyigniter` to `./tastyigniter`; PhpStorm's server name is `tastyigniter`. For a one-off CLI run, use `docker compose exec -e XDEBUG_MODE=debug app php artisan ...`.

## Mail

Laravel's mailer points at Mailpit, so order and reservation emails show up at http://localhost:8025. If TI sends real mail anyway, check **System > Settings > Mail** in the admin, because a mailer saved there overrides the env config.

## Configuration overrides

Create a `.env` file next to `docker-compose.yml` (it's gitignored) to override any of these:

```
PHP_VERSION=8.4     # rebuild afterwards: ./build.sh
HTTP_PORT=8080
DB_HOST_PORT=3306
MAILPIT_PORT=8025
XDEBUG_MODE=off
```

## Backups

```
mkdir -p backups
docker compose exec -T db sh -c 'mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" tastyigniter' > backups/tastyigniter-$(date +%F).sql
```

To restore: `docker compose exec -T db sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" tastyigniter' < backups/<file>.sql`
