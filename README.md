# Docker setup for Tastyigniter v4 development

Here's a quick `docker compose` setup for TastyIgniter v4 development.

As this is mostly for personal use, it has so far only been tested on an Ubuntu host using `docker`, ymmv for Windows, Mac, other linux distro's, `docker desktop`, etc.


## Usage

First, install `docker` and `docker compose`.

Clone this repo and from the repo directory, run

```
./build.sh
docker compose exec app php artisan igniter:passwd admin@domain.tld
```

This should get you to the point of being able to load a default TIv4 installation at http://localhost:8080/, and log into the admin at http://localhost:8080/admin (user email is `admin@domain.tld` and password is what you set it to above).

For local development, `./tastyigniter` is set up as a bind mount into the app containers `/var/www/tastyigniter`.
