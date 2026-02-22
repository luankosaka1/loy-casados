FROM php:8.4-apache

# Install minimal dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install essential PHP extensions only
RUN docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_sqlite \
    mbstring \
    && a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy files
COPY . .

# Install dependencies
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev --no-interaction 2>&1 | head -50

# Set permissions
RUN chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

# Copy entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

CMD ["/usr/local/bin/entrypoint.sh"]

