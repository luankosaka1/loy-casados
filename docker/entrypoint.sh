#!/bin/sh

set -e

# Create supervisor log directory
mkdir -p /var/log/supervisor

# Wait for database directory to be writable
while [ ! -w /var/www/html/database ]; do
    echo "Waiting for database directory to be writable..."
    sleep 1
done

# Run migrations if needed
php artisan migrate --force --no-interaction

# Clear and cache config
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Create admin user if needed (optional)
# php artisan make:filament-user

# Start supervisor
exec /usr/bin/supervisord -c /etc/supervisord.conf

