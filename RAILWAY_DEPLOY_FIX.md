# Railway Deploy - SQLite Version Fix

## Problem
Railway deployment was failing because it required SQLite version 3.7.7 or higher, but Alpine Linux's default SQLite package is too old (version 3.x).

## Solution
The Dockerfile has been updated to:
1. Compile and install **SQLite 3.45.1** from source with session extensions
2. Upgrade to **PHP 8.4** (required by some Symfony dependencies)
3. Add missing PHP extensions (intl, zip)
4. Fix supervisor log directory issue

## Changes Made

### Dockerfile
1. **Upgraded to PHP 8.4-FPM-Alpine** base image
2. **Compile SQLite from source**: Downloads and compiles SQLite 3.45.1 with session extensions enabled
3. **Update library paths**: Sets `PKG_CONFIG_PATH` to ensure proper library detection
4. **Build PHP extensions**: PHP PDO SQLite extension now uses the new SQLite version
5. **Added PHP extensions**: intl and zip (required by Filament and OpenSpout)

### docker/entrypoint.sh
- Added creation of `/var/log/supervisor` directory to prevent supervisor errors

### Key Steps in Build Process
- Downloads SQLite source code from official website (2024 release)
- Compiles with session extension flags:
  - `SQLITE_ENABLE_COLUMN_METADATA=1`
  - `SQLITE_ENABLE_SESSION=1`
  - `SQLITE_ENABLE_PREUPDATE_HOOK=1`
- Installs to `/usr/lib` for system-wide availability
- Updates library cache with `ldconfig`
- PHP extensions are built against the new SQLite

## SQLite Version
The new SQLite version is **3.45.1** (released in 2024), which is far above the minimum requirement of 3.7.7.

## PHP Version
Upgraded from **PHP 8.2** to **PHP 8.4** to match the Symfony and Laravel dependencies in composer.lock.

## Build Verification
✅ Docker build completed successfully
✅ All PHP extensions installed (pdo, pdo_sqlite, mbstring, exif, pcntl, bcmath, gd, intl, zip)
✅ SQLite 3.45.1 with session extensions enabled
✅ Composer dependencies installed without errors
✅ NPM build completed successfully

## Deployment Steps for Railway

1. **Commit the changes**:
   ```bash
   git add Dockerfile docker/entrypoint.sh RAILWAY_DEPLOY_FIX.md
   git commit -m "fix: Update SQLite to 3.45.1 and PHP to 8.4 for Railway deployment"
   git push origin main
   ```

2. **Railway will automatically rebuild** with the new Dockerfile

3. **Verify after deployment**:
   - Check deployment logs to ensure build succeeds
   - The SQLite version can be verified by checking PHP's PDO SQLite driver
   - Application should start without SQLite version errors

## Testing Locally
To test the new Dockerfile locally:
```bash
docker build -t laracheckin:latest .
docker run -p 8080:80 laracheckin:latest
```

Then visit http://localhost:8080 to verify it works.

## Technical Details

### Why Session Extension?
Node.js (installed via npm) requires SQLite session functions:
- `sqlite3session_attach`
- `sqlite3changeset_apply`
- `sqlite3session_create`
- `sqlite3session_changeset`
- `sqlite3session_patchset`
- `sqlite3session_delete`

These are only available when SQLite is compiled with `-DSQLITE_ENABLE_SESSION=1` and `-DSQLITE_ENABLE_PREUPDATE_HOOK=1`.

### Installation Order
1. Install build dependencies
2. Compile and install SQLite with session extensions
3. Install system packages (Node.js, etc.)
4. Build PHP extensions against the new SQLite
5. Clean up build dependencies

## Notes
- The build process takes longer due to compiling SQLite from source (~2-3 minutes)
- The image size is slightly larger but still optimized
- Build dependencies are removed after compilation to minimize final image size
- Runtime SQLite libraries remain in the image at `/usr/lib`
- All PHP extensions are properly linked with the new SQLite version

