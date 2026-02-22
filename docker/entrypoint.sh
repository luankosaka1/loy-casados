#!/bin/bash

set -e

echo "=== Laravel Container Startup ==="
echo "Setting up permissions..."

# Give full permissions to the entire application directory
chmod -R 777 /var/www/html

# Create cache directories with proper permissions first
mkdir -p /var/www/html/storage/framework/cache
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/bootstrap/cache

# Set www-data as owner for web-accessible directories
chown -R www-data:www-data /var/www/html/storage
chown -R www-data:www-data /var/www/html/bootstrap/cache
chown -R www-data:www-data /var/www/html/database

# Ensure full permissions
chmod -R 777 /var/www/html/storage
chmod -R 777 /var/www/html/bootstrap/cache
chmod -R 777 /var/www/html/database

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

# Verify .env file was created and has APP_KEY
if [ ! -f /var/www/html/.env ]; then
    echo "ERROR: .env file was not created!"
    exit 1
fi

if ! grep -q "APP_KEY=" /var/www/html/.env; then
    echo "ERROR: APP_KEY not found in .env file!"
    exit 1
fi

echo ".env file verified successfully"
cat /var/www/html/.env

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

# Ensure database file exists
if [ ! -f /var/www/html/database/database.sqlite ]; then
    echo "Creating SQLite database file..."
    touch /var/www/html/database/database.sqlite
    chown www-data:www-data /var/www/html/database/database.sqlite
    chmod 666 /var/www/html/database/database.sqlite
fi

echo "Database file status:"
ls -lah /var/www/html/database/database.sqlite

# Clear all caches (ignore errors)
echo "Clearing caches..."
php artisan config:clear 2>/dev/null || echo "Config clear skipped (expected on first run)"
php artisan cache:clear 2>/dev/null || echo "Cache clear skipped"
php artisan view:clear 2>/dev/null || echo "View clear skipped"
php artisan route:clear 2>/dev/null || echo "Route clear skipped"

# Run migrations (but don't fail if they error)
echo "Running migrations..."
php artisan migrate --force --no-interaction 2>&1 || echo "Migrations completed with warnings (this is OK on first run)"

# Cache config, routes and views (ignore errors to ensure Apache starts)
echo "Caching configuration..."
php artisan config:cache 2>&1 || echo "Config cache skipped"
php artisan route:cache 2>&1 || echo "Route cache skipped"
php artisan view:cache 2>&1 || echo "View cache skipped"

# Optimize for production (ignore errors)
echo "Optimizing application..."
php artisan optimize 2>&1 || echo "Optimization skipped"

echo "=== Application ready! ==="
echo "Starting Apache in foreground..."
echo "Application URL: ${APP_URL:-http://localhost}"

# Start Apache in foreground - this MUST happen
exec apache2-foreground

php artisan serve --port=80 --host=0.0.0.0
