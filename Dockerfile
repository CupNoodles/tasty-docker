ARG PHP_VERSION=8.3
FROM php:${PHP_VERSION}-fpm

# Match the container user to your host user so files in the ./tastyigniter
# bind mount stay owned by you. build.sh passes these through automatically.
ARG UID=1000
ARG GID=1000

# Helper that pulls in the right system libs for each PHP extension
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        unzip \
        zip \
        vim \
        default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# dom, mbstring, curl, etc. are already compiled into the official image.
# xdebug is installed but disabled unless XDEBUG_MODE is set (see compose file).
RUN install-php-extensions \
        bcmath \
        exif \
        gd \
        intl \
        opcache \
        pcntl \
        pdo_mysql \
        zip \
        xdebug

RUN groupadd -g ${GID} www \
    && useradd -u ${UID} -g www -ms /bin/bash www \
    && mkdir -p /var/www/tastyigniter /home/www/.composer \
    && chown -R www:www /var/www /home/www

COPY --chmod=755 create-tastyigniter.sh /usr/local/bin/create-tastyigniter.sh

WORKDIR /var/www/tastyigniter
USER www

ENV COMPOSER_HOME=/home/www/.composer

ENTRYPOINT ["/usr/local/bin/create-tastyigniter.sh"]

EXPOSE 9000
CMD ["php-fpm"]
