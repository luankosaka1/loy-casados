# Variáveis de Ambiente para Railway

## ✅ Variáveis OBRIGATÓRIAS

Copie e cole essas variáveis no Railway Dashboard → **Variables**:

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

## ⚠️ IMPORTANTE

1. **Substitua `seu-projeto.railway.app`** pela URL real do seu projeto no Railway

2. **APP_KEY** pode ser gerado localmente com:
   ```bash
   php artisan key:generate --show
   ```

## 🔍 Como Adicionar as Variáveis no Railway

1. Vá ao **Railway Dashboard**
2. Clique no seu **Projeto**
3. Clique na **Service** (laracheckin)
4. Vá na aba **Variables**
5. Clique em **Raw Editor**
6. Cole o conteúdo acima
7. Clique em **Deploy** (Railway fará redeploy automático)

## 📋 Variáveis Explicadas

| Variável | Valor | Descrição |
|----------|-------|-----------|
| APP_NAME | LoY - CASADOS | Nome da aplicação |
| APP_ENV | production | Ambiente (production) |
| APP_DEBUG | false | Debug desabilitado em produção |
| APP_KEY | base64:... | Chave de encriptação (GERADO) |
| APP_URL | https://... | URL da aplicação |
| DB_CONNECTION | sqlite | Banco de dados SQLite |
| DB_DATABASE | /var/www/html/database/database.sqlite | Caminho do banco |
| SESSION_DRIVER | database | Sessões no banco |
| CACHE_STORE | database | Cache no banco |
| LOG_LEVEL | info | Nível de log |
| MAIL_FROM_ADDRESS | noreply@example.com | Email de saída |

## ✅ Verificação Após Deploy

Após adicionar as variáveis e fazer o deploy:

1. ✅ Acesse a URL (https://seu-projeto.railway.app)
2. ✅ Deve carregar sem erro 500
3. ✅ Acesse /admin (painel administrativo)
4. ✅ Acesse /player/login (login de players)

## 🆘 Se Ainda Houver Erro 500

Verifique os logs no Railway:
- Railway Dashboard → Service → Logs
- Procure por: "Application ready!" (sucesso)
- Procure por: "error", "exception" (erros)

## 📝 Notas

- O banco SQLite é **efêmero** (apagado a cada deploy)
- Para persistência, adicione um **Volume** no Railway
- Alternativamente, use **PostgreSQL** (Railway fornece grátis)

---

**Pronto! Adicione essas variáveis no Railway e faça o deploy.** 🚀

