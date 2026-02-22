# 🚀 Railway.app Environment Variables - Quick Setup

## Copy & Paste into Railway UI (WITHOUT quotes)

```
APP_NAME=LoY - CASADOS
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:odTgF9snyWzcdw9Y4TD6ulhSc+rlgeQ8XMBeP8hgFLY=
APP_URL=https://loy-casados.up.railway.app
LOG_CHANNEL=stack
LOG_LEVEL=info
DB_CONNECTION=sqlite
DB_DATABASE=/var/www/html/database/database.sqlite
SESSION_DRIVER=database
CACHE_STORE=database
BROADCAST_CONNECTION=log
QUEUE_CONNECTION=database
FILESYSTEM_DISK=local
MAIL_MAILER=smtp
MAIL_FROM_ADDRESS=noreply@example.com
APP_LOCALE=pt_BR
APP_FALLBACK_LOCALE=pt_BR
```

---

## ⚠️ IMPORTANT: No Quotes Needed

Railway UI automatically handles quotes. Add the values **exactly as shown above** without any quotes.

---

## ✅ After Adding Variables

1. Click "Deploy" in Railway
2. Wait for build to complete (~3-5 minutes)
3. Access: `https://loy-casados.up.railway.app`
4. Admin login: `https://loy-casados.up.railway.app/admin`
5. Player login: `https://loy-casados.up.railway.app/players/login`

---

## 🔧 If Deploy Fails

Check Railway logs:
- Look for "Application ready!" message
- Check for database migration errors
- Verify all extensions installed correctly

---

## 📊 Health Check

Once deployed, verify:
- [ ] Home page loads (/)
- [ ] Admin panel accessible (/admin)
- [ ] Player login works (/players/login)
- [ ] Database accessible (no 500 errors)
- [ ] Assets loading correctly

---

*Last updated: February 22, 2026*

