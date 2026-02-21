# Railway Deploy - SQLite Version Fix

## Problem
Railway deployment was failing because it required SQLite version 3.7.7 or higher, but Alpine Linux's default SQLite package is too old.

## Solution
The Dockerfile has been updated to compile and install SQLite 3.45.1 from source, which is a much newer version that meets all requirements.

## Changes Made

### Dockerfile
1. **Compile SQLite from source**: Downloads and compiles SQLite 3.45.1
2. **Update library paths**: Sets `LD_LIBRARY_PATH` and `PKG_CONFIG_PATH` to use the new SQLite
3. **Build PHP extensions**: PHP PDO SQLite extension now uses the new SQLite version

### Key Steps in Build Process
- Downloads SQLite source code from official website
- Compiles with `./configure --prefix=/usr/local`
- Installs to `/usr/local/lib`
- Updates library cache with `ldconfig`
- PHP extensions are built against the new SQLite

## SQLite Version
The new SQLite version is **3.45.1** (released in 2024), which is far above the minimum requirement of 3.7.7.

## Deployment Steps for Railway

1. **Commit the changes**:
   ```bash
   git add Dockerfile
   git commit -m "fix: Update SQLite to version 3.45.1 for Railway deployment"
   git push origin main
   ```

2. **Railway will automatically rebuild** with the new Dockerfile

3. **Verify after deployment**:
   - Check deployment logs to ensure build succeeds
   - The SQLite version can be verified by checking PHP's PDO SQLite driver

## Testing Locally
To test the new Dockerfile locally:
```bash
docker build -t laracheckin:latest .
docker run -p 8080:80 laracheckin:latest
```

Then visit http://localhost:8080 to verify it works.

## Notes
- The build process takes longer due to compiling SQLite from source
- The image size is slightly larger but still optimized
- Build dependencies are removed after compilation to minimize final image size
- Runtime SQLite libraries remain in the image at `/usr/local/lib`

