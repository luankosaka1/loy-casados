#!/bin/sh

set -e

echo "=== Laravel Container Startup ==="

# Create supervisor log directory
mkdir -p /var/log/supervisor

# Create cache directories with proper permissions first
mkdir -p /var/www/html/storage/framework/cache
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/bootstrap/cache

# Create .env file BEFORE any artisan commands
if [ ! -f /var/www/html/.env ]; then
    echo "Creating .env from environment variables..."
    {
        echo "APP_NAME=\"${APP_NAME:-LoY - CASADOS}\""
        echo "APP_ENV=${APP_ENV:-production}"
        echo "APP_KEY=${APP_KEY:-base64:odTgF9snyWzcdw9Y4TD6ulhSc+rlgeQ8XMBeP8hgFLY=}"
        echo "APP_DEBUG=${APP_DEBUG:-false}"
        echo "APP_URL=${APP_URL:-http://localhost}"
        echo "APP_LOCALE=pt_BR"
        echo "APP_FALLBACK_LOCALE=pt_BR"
        echo "APP_FAKER_LOCALE=pt_BR"
        echo "DB_CONNECTION=${DB_CONNECTION:-sqlite}"
        echo "DB_DATABASE=${DB_DATABASE:-/var/www/html/database/database.sqlite}"
        echo "SESSION_DRIVER=database"
        echo "BROADCAST_CONNECTION=log"
        echo "FILESYSTEM_DISK=local"
        echo "QUEUE_CONNECTION=database"
        echo "CACHE_STORE=database"
        echo "LOG_CHANNEL=stack"
        echo "LOG_LEVEL=${LOG_LEVEL:-info}"
        echo "MAIL_MAILER=smtp"
        echo "MAIL_FROM_ADDRESS=hello@example.com"
        echo "MAIL_FROM_NAME=\"${APP_NAME:-LoY - CASADOS}\""
    } > /var/www/html/.env
    echo ".env file created successfully!"
fi

# Set proper permissions for all storage directories
chown -R www-data:www-data /var/www/html/storage
chmod -R 775 /var/www/html/storage
chown -R www-data:www-data /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/bootstrap/cache
chown www-data:www-data /var/www/html/.env
chmod 644 /var/www/html/.env

# Wait for database directory to be writable
while [ ! -w /var/www/html/database ]; do
    echo "Waiting for database directory to be writable..."
    sleep 1
done


# Clear all caches (ignore errors)
echo "Clearing caches..."
php artisan config:clear 2>/dev/null || true
php artisan cache:clear 2>/dev/null || true
php artisan view:clear 2>/dev/null || true
php artisan route:clear 2>/dev/null || true

# Run migrations if needed
echo "Running migrations..."
php artisan migrate --force --no-interaction

# Cache config, routes and views
echo "Caching configuration..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Optimize for production
echo "Optimizing application..."
php artisan optimize

echo "=== Application ready! ==="
echo "Starting supervisor..."

# Start supervisor
exec /usr/bin/supervisord -c /etc/supervisord.conf

