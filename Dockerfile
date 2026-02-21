FROM php:8.2-fpm-alpine

# Install build dependencies and compile SQLite from source
RUN apk add --no-cache --virtual .build-deps \
    gcc \
    g++ \
    make \
    autoconf \
    pkgconfig \
    wget \
    && mkdir -p /tmp/sqlite \
    && cd /tmp/sqlite \
    && wget https://www.sqlite.org/2024/sqlite-autoconf-3450100.tar.gz \
    && tar xzf sqlite-autoconf-3450100.tar.gz \
    && cd sqlite-autoconf-3450100 \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && cd / \
    && rm -rf /tmp/sqlite

# Update library cache to use the new SQLite
RUN ldconfig /usr/local/lib || true

# Install system dependencies
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
    openssl

# Set environment to use the new SQLite
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

# Install PHP extensions with the new SQLite
RUN docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd

# Clean up build dependencies but keep runtime libraries
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

