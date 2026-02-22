#!/bin/bash

set -e

echo "=== Laravel Container Startup ==="

# Create cache directories with proper permissions first
mkdir -p /var/www/html/storage/framework/cache
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/bootstrap/cache

# Create .env file BEFORE any artisan commands
if [ ! -f /var/www/html/.env ]; then
    echo "Creating .env from environment variables..."
    cat > /var/www/html/.env << EOF
APP_NAME="${APP_NAME:-LoY - CASADOS}"
APP_ENV=${APP_ENV:-production}
APP_KEY=${APP_KEY:-base64:odTgF9snyWzcdw9Y4TD6ulhSc+rlgeQ8XMBeP8hgFLY=}
APP_DEBUG=${APP_DEBUG:-false}
APP_URL=${APP_URL:-http://localhost}
APP_LOCALE=pt_BR
APP_FALLBACK_LOCALE=pt_BR
APP_FAKER_LOCALE=pt_BR
DB_CONNECTION=${DB_CONNECTION:-sqlite}
DB_DATABASE=${DB_DATABASE:-/var/www/html/database/database.sqlite}
SESSION_DRIVER=database
BROADCAST_CONNECTION=log
FILESYSTEM_DISK=local
QUEUE_CONNECTION=database
CACHE_STORE=database
LOG_CHANNEL=stack
LOG_LEVEL=${LOG_LEVEL:-info}
MAIL_MAILER=smtp
MAIL_FROM_ADDRESS=hello@example.com
MAIL_FROM_NAME="${APP_NAME:-LoY - CASADOS}"
EOF
    echo ".env file created successfully!"
else
    echo ".env file already exists, skipping creation"
fi

# Set proper permissions for all storage directories
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html/storage
chmod -R 775 /var/www/html/storage
chown -R www-data:www-data /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/bootstrap/cache
chown www-data:www-data /var/www/html/.env
chmod 644 /var/www/html/.env
chown -R www-data:www-data /var/www/html/database
chmod -R 775 /var/www/html/database

# Wait for database directory to be writable
echo "Waiting for database directory to be writable..."
for i in {1..30}; do
    if [ -w /var/www/html/database ]; then
        echo "Database directory is ready"
        break
    fi
    echo "Waiting... ($i/30)"
    sleep 1
done

# Clear all caches (ignore errors)
echo "Clearing caches..."
php artisan config:clear 2>/dev/null || echo "Config clear skipped (expected on first run)"
php artisan cache:clear 2>/dev/null || echo "Cache clear skipped"
php artisan view:clear 2>/dev/null || echo "View clear skipped"
php artisan route:clear 2>/dev/null || echo "Route clear skipped"

# Run migrations
echo "Running migrations..."
php artisan migrate --force --no-interaction --quiet

# Cache config, routes and views
echo "Caching configuration..."
php artisan config:cache --quiet
php artisan route:cache --quiet
php artisan view:cache --quiet

# Optimize for production
echo "Optimizing application..."
php artisan optimize --quiet

echo "=== Application ready! ==="
echo "Starting Apache..."

# Start Apache in foreground
exec apache2-foreground

