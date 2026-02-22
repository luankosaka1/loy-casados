# ✅ REVISÃO COMPLETA - Dockerfile e Entrypoint

## 🔴 Problemas Encontrados e Corrigidos

### 1. **Dockerfile executava composer install DUAS VEZES**
   - ❌ Linha 72: `RUN composer install`
   - ❌ Entrypoint.sh linha 52: `composer install` novamente
   - ✅ **Corrigido**: Removido do entrypoint, mantido apenas no Dockerfile

### 2. **Erro ao criar .env sem APP_KEY**
   - ❌ APP_KEY não era definido durante o build
   - ✅ **Corrigido**: Cria .env temporário no Dockerfile com chave dummy
   - ✅ Entrypoint.sh regenera .env com as variáveis do Railway

### 3. **Permissões incorretas em storage/**
   - ❌ chmod 755 (errado para escrita)
   - ✅ **Corrigido**: chmod 775 (correto para leitura/escrita)

### 4. **Falta de aspas em valores com espaços**
   - ❌ `APP_NAME=LoY - CASADOS` (erro: dotenv não consegue parsear)
   - ✅ **Corrigido**: `APP_NAME="LoY - CASADOS"`

## ✅ Mudanças Realizadas

### **Dockerfile**
```dockerfile
# ✅ Cria .env temporário para o build não falhar
RUN echo "APP_ENV=production\nAPP_DEBUG=false\nAPP_KEY=base64:AAAA...\nDB_CONNECTION=sqlite" > .env

# ✅ Instala dependências UMA VEZ
RUN composer install --optimize-autoloader --no-dev --no-interaction
RUN npm install && npm run build
```

### **docker/entrypoint.sh**
```bash
# ✅ Cria .env com variáveis do Railway (sobrescreve a temporária)
if [ ! -f /var/www/html/.env ]; then
    echo "APP_NAME=\"${APP_NAME:-LoY - CASADOS}\""
    echo "APP_ENV=${APP_ENV:-production}"
    # ... mais variáveis
fi

# ✅ Sem composer install aqui (já está no Dockerfile)

# ✅ Apenas executa migrations e cache
php artisan migrate --force --no-interaction
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize
```

## 🚀 DEPLOY NO RAILWAY - PASSO A PASSO

### 1. Fazer Commit das Alterações
```bash
cd /Users/luan/dev/lab/laracheckin
git add Dockerfile docker/entrypoint.sh RAILWAY_ENVIRONMENT_VARIABLES.md
git commit -m "fix: correct dockerfile and entrypoint - remove duplicate composer install, fix .env creation"
git push origin main
```

### 2. Adicionar Variáveis de Ambiente no Railway

**Railway Dashboard → Variables → Raw Editor**

Cole exatamente isso:
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

⚠️ **SUBSTITUA**: `seu-projeto.railway.app` pela URL real do seu projeto

### 3. Railway Fará Deploy Automático
- ⏱️ Tempo: 3-5 minutos
- 📦 Build: Compila SQLite, instala dependências, build NPM
- 🚀 Deploy: Inicia com supervisord (nginx + php-fpm)

### 4. Verificar Status
No Railway, vá em **Logs** e procure por:
- ✅ `=== Application ready! ===` (sucesso!)
- ✅ `[DATE] NOTICE: ready to handle connections`

## 📊 Resumo das Correções

| Problema | Antes | Depois |
|----------|-------|--------|
| Composer install | 2x (Dockerfile + entrypoint) | 1x (apenas Dockerfile) ✅ |
| .env no build | Erro (sem APP_KEY) | Criado com valores dummy ✅ |
| .env no runtime | Não regenerado | Regenerado com Railway vars ✅ |
| Permissões storage | 755 (sem escrita) | 775 (com escrita) ✅ |
| Valores com espaços | `APP_NAME=LoY - CASADOS` | `APP_NAME="LoY - CASADOS"` ✅ |
| Aspas em MAIL_FROM_NAME | Sem aspas | Com aspas ✅ |

## 📝 Arquivo de Referência

Arquivo completo de variáveis: **RAILWAY_ENVIRONMENT_VARIABLES.md**

## 🎯 Resultado Esperado

Após o deploy:
- ✅ Status HTTP 200 (sem erro 500)
- ✅ Aplicação carrega normalmente
- ✅ Admin em `/admin`
- ✅ Login de players em `/player/login`
- ✅ Banco de dados SQLite funcionando

## ❓ Dúvidas Frequentes

### "Como gero um novo APP_KEY?"
```bash
php artisan key:generate --show
```
Copie a saída e atualize a variável `APP_KEY` no Railway.

### "O banco SQLite será persistido?"
**NÃO** - Railway usa storage efêmero. Para persistir:
1. Adicione um **Volume** no Railway para `/var/www/html/database`
2. Ou migre para **PostgreSQL** (Railway fornece grátis)

### "Preciso de mais extensões PHP?"
No Dockerfile, na linha do `docker-php-ext-install`, adicione as extensões necessárias.

---

## ✅ PRONTO PARA DEPLOY!

Faça commit, push e adicione as variáveis no Railway. 🚀

