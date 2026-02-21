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

# Compile and install newer SQLite from source
RUN cd /tmp \
    && wget https://www.sqlite.org/2024/sqlite-autoconf-3450100.tar.gz \
    && tar xzf sqlite-autoconf-3450100.tar.gz \
    && cd sqlite-autoconf-3450100 \
    && CFLAGS="-DSQLITE_ENABLE_COLUMN_METADATA=1" ./configure --prefix=/usr --enable-shared --enable-static \
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

# Copy application files
COPY . .

# Install dependencies
RUN composer install --optimize-autoloader --no-dev
RUN npm install && npm run build

# Setup permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

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

