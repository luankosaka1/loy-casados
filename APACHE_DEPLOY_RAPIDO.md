# 🎯 DEPLOY COM APACHE - PASSO A PASSO

## ✅ MUDANÇA REALIZADA

Mudei de **PHP-FPM + Nginx** para **PHP Apache** (mais simples e compatível).

---

## 1️⃣ GIT COMMIT

```bash
cd /Users/luan/dev/lab/laracheckin
git add Dockerfile docker/entrypoint.sh docker/apache-vhost.conf
git add MUDANCA_PARA_APACHE.md
git commit -m "feat: switch to apache for better compatibility"
git push origin main
```

**Tempo:** 1-2 minutos

---

## 2️⃣ RAILWAY - VARIÁVEIS (IGUAIS)

Railway Dashboard → Variables → Raw Editor

Cole:
```env
APP_NAME=LoY - CASADOS
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:odTgF9snyWzcdw9Y4TD6ulhSc+rlgeQ8XMBeP8hgFLY=
APP_URL=https://seu-projeto.railway.app
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

⚠️ Substitua: `seu-projeto.railway.app` pela URL real

**Tempo:** 2-3 minutos

---

## 3️⃣ AGUARDAR DEPLOY

Railway detecta push → build automático (3-5 min)

**Procure nos logs por:**
```
=== Application ready! ===
Starting Apache...
```

Se não houver erro, está funcionando! ✅

---

## 4️⃣ TESTAR

1. Abra: `https://seu-projeto.railway.app`
2. Deve carregar sem erro 500
3. Teste `/admin` e `/player/login`

---

## 🎉 PRONTO!

Tempo total: ~10 minutos

✅ **Sua aplicação estará no ar com Apache!** 🚀

