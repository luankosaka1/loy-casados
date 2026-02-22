FROM php:8.4-fpm-alpine

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps \
    gcc \
    g++ \
    make \
    autoconf \
    automake \
    libtool \
    pkgconfig \
    wget \
    tcl-dev

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
RUN ldconfig /usr/lib 2>/dev/null || true \
    && sqlite3 --version

# Install system dependencies (keep sqlite for compatibility)
RUN apk add --no-cache \
    nginx \
    supervisor \
    nodejs \
    npm \
    git \
    zip \
    unzip \
    curl \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    openssl \
    sqlite-dev \
    icu-dev \
    libzip-dev \
    zlib-dev

# Set PKG_CONFIG_PATH to find the new SQLite
ENV PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/local/lib/pkgconfig
# Set environment for Laravel
ENV APP_ENV=production
ENV APP_DEBUG=false

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd intl zip

# Verify PHP SQLite version
RUN php -r "echo 'PHP SQLite Version: ' . SQLite3::version()['versionString'] . PHP_EOL;"

# Clean up build dependencies
RUN apk del .build-deps

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files (but not .env - it will be created at runtime)
COPY . .

# Create a temporary .env for build time (will be regenerated at runtime)
RUN echo "APP_ENV=production\nAPP_DEBUG=false\nAPP_KEY=base64:AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\nDB_CONNECTION=sqlite" > .env

# Install dependencies
RUN composer install --optimize-autoloader --no-dev --no-interaction
RUN npm install && npm run build

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

# Copy nginx config
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/default.conf /etc/nginx/http.d/default.conf

# Copy supervisor config
COPY docker/supervisord.conf /etc/supervisord.conf

# Copy entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

