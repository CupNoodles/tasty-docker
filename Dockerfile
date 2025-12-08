FROM php:8.3-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    openssl \
    zip \
    unzip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libpng-dev \
    libmcrypt-dev \
    libxml2-dev \
    libonig-dev \
    libzip-dev \
    libicu-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install bcmath pdo_mysql dom mbstring exif intl zip
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for webapp
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Switch to www user
USER www

# Create and set entrypoint script
COPY create-tastyigniter.sh /usr/local/bin/create-tastyigniter.sh
COPY --chown=www:www create-tastyigniter.sh /usr/local/bin/create-tastyigniter.sh
ENTRYPOINT ["/usr/local/bin/create-tastyigniter.sh"]


# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
