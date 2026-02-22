FROM php:8.4-apache

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    wget \
    git \
    curl \
    nodejs \
    npm \
    zip \
    unzip \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libcurl4-openssl-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# Compile and install newer SQLite from source with session support
RUN cd /tmp \
    && wget https://www.sqlite.org/2024/sqlite-autoconf-3450100.tar.gz \
    && tar xzf sqlite-autoconf-3450100.tar.gz \
    && cd sqlite-autoconf-3450100 \
    && CFLAGS="-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_SESSION=1 -DSQLITE_ENABLE_PREUPDATE_HOOK=1" \
       ./configure --prefix=/usr --enable-shared --enable-static \
    && make -j$(nproc) \
    && make install \
    && cd / \
    && rm -rf /tmp/sqlite*

# Update library cache and verify SQLite
RUN ldconfig \
    && sqlite3 --version


# Set PKG_CONFIG_PATH to find the new SQLite
ENV PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/local/lib/pkgconfig
# Set environment for Laravel
ENV APP_ENV=production
ENV APP_DEBUG=false

# Install PHP extensions - only essential ones
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_sqlite \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    intl \
    zip \
    dom \
    xml

# Enable Apache modules
RUN a2enmod rewrite \
    && a2enmod headers

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files (but not .env - it will be created at runtime)
COPY . .

# Create a temporary .env for build time (will be regenerated at runtime)
RUN echo "APP_ENV=production\nAPP_DEBUG=false\nAPP_KEY=base64:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\nDB_CONNECTION=sqlite" > .env

# Install PHP dependencies with increased memory limit
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader --no-dev --no-interaction --no-scripts

# Install Node dependencies
RUN npm ci && npm run build

# Run composer scripts after npm build
RUN COMPOSER_MEMORY_LIMIT=-1 composer run-script post-install-cmd 2>/dev/null || true

# Setup permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Create all necessary directories with proper permissions
RUN mkdir -p /var/www/html/storage/framework/cache \
    && mkdir -p /var/www/html/storage/framework/sessions \
    && mkdir -p /var/www/html/storage/framework/views \
    && mkdir -p /var/www/html/storage/logs \
    && chown -R www-data:www-data /var/www/html/storage \
    && chmod -R 775 /var/www/html/storage

# Create SQLite database directory
RUN mkdir -p /var/www/html/database && \
    touch /var/www/html/database/database.sqlite && \
    chown -R www-data:www-data /var/www/html/database && \
    chmod -R 775 /var/www/html/database

# Copy Apache config
COPY docker/apache-vhost.conf /etc/apache2/sites-available/000-default.conf
RUN a2dissite 000-default 2>/dev/null || true \
    && a2ensite 000-default

# Copy entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

CMD ["/usr/local/bin/entrypoint.sh"]

