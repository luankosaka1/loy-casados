# Deploy Docker para [LoY] CASADOS

Este guia detalha o processo de deploy usando Docker em hospedagens econômicas.

## 🎯 Resumo Rápido

**Melhor opção**: Railway.app ($5/mês)
- Setup em 2 minutos
- SSL grátis + domínio incluso
- Um único container com tudo dentro

## 📦 O que está no Container?

O Dockerfile criado empacota **tudo em um único container**:
- ✅ PHP 8.2 + FPM
- ✅ Nginx (servidor web)
- ✅ Node.js (para assets)
- ✅ SQLite (banco de dados)
- ✅ Supervisor (gerencia processos)
- ✅ Laravel + Filament compilados

**Sem necessidade de:**
- ❌ Container separado de banco
- ❌ Container separado de web server
- ❌ Docker Compose
- ❌ Orquestração complexa

## 🚀 Deploy no Railway (RECOMENDADO)

### Passo 1: Preparar o código

```bash
# Gerar APP_KEY
php artisan key:generate --show
# Copie o valor gerado (ex: base64:xxx...)

# Commit dos arquivos Docker
git add Dockerfile docker/ railway.json .dockerignore
git commit -m "Add Docker configuration for Railway"
git push origin main
```

### Passo 2: Configurar Railway

1. Acesse https://railway.app e faça login com GitHub
2. Clique em "New Project" → "Deploy from GitHub repo"
3. Selecione o repositório `laracheckin`
4. Railway detecta o Dockerfile automaticamente

### Passo 3: Variáveis de Ambiente

Na aba "Variables" do Railway, adicione:

```
APP_NAME=LoY - CASADOS
APP_ENV=production
APP_KEY=base64:SUA_CHAVE_AQUI
APP_DEBUG=false
APP_URL=https://seu-app.up.railway.app
DB_CONNECTION=sqlite
LOG_LEVEL=error
SESSION_DRIVER=file
CACHE_STORE=file
```

### Passo 4: Volume Persistente (Importante!)

1. Na aba "Settings" → "Volumes"
2. Clique em "New Volume"
3. Mount Path: `/var/www/html/database`
4. Isso garante que o SQLite persiste entre deploys

### Passo 5: Deploy

- Railway faz deploy automaticamente
- Acompanhe os logs em tempo real
- URL disponível em ~2-3 minutos

### Passo 6: Criar Usuário Admin

Instale o Railway CLI:
```bash
npm install -g @railway/cli
railway login
railway link
```

Crie o usuário:
```bash
railway run php artisan make:filament-user
```

## 🛠 Deploy no Fly.io (Alternativa Barata)

### Setup Inicial

```bash
# Instalar CLI
curl -L https://fly.io/install.sh | sh

# Login
fly auth login

# Criar app
fly launch --no-deploy

# Responda:
# - Nome do app: laracheckin
# - Região: gru (São Paulo) ou mia (Miami)
# - Postgres? NÃO
# - Redis? NÃO
```

### Criar Volume

```bash
fly volumes create laracheckin_data --region gru --size 1
```

### Configurar Secrets

```bash
fly secrets set APP_KEY="base64:SUA_CHAVE_AQUI"
fly secrets set APP_URL="https://laracheckin.fly.dev"
```

### Deploy

```bash
fly deploy
```

### Criar Admin

```bash
fly ssh console
cd /var/www/html
php artisan make:filament-user
exit
```

## 🐳 Teste Local com Docker

Antes de fazer deploy, teste localmente:

```bash
# Build
docker build -t laracheckin:test .

# Gerar APP_KEY
php artisan key:generate --show

# Run
docker run -d \
  -p 8080:80 \
  --name laracheckin-test \
  -e APP_KEY="base64:SUA_CHAVE" \
  -e APP_URL="http://localhost:8080" \
  -v $(pwd)/database:/var/www/html/database \
  laracheckin:test

# Ver logs
docker logs -f laracheckin-test

# Acessar
open http://localhost:8080/admin

# Criar admin
docker exec -it laracheckin-test php artisan make:filament-user

# Parar e remover
docker stop laracheckin-test
docker rm laracheckin-test
```

## 💰 Comparação de Custos

| Plataforma | Custo/mês | Setup | SSL | Domínio | Volume |
|-----------|-----------|-------|-----|---------|--------|
| **Railway** | $5 | ⭐⭐⭐⭐⭐ | ✅ | ✅ | ✅ |
| **Fly.io** | $3-5 | ⭐⭐⭐⭐ | ✅ | ✅ | ✅ |
| **Render** | $7 | ⭐⭐⭐⭐⭐ | ✅ | ✅ | ✅ |
| **DigitalOcean** | $5 | ⭐⭐⭐ | ✅ | ❌ | ✅ |

## 🔧 Troubleshooting

### Container não inicia

```bash
# Ver logs
railway logs
# ou
fly logs

# Problema comum: APP_KEY não configurada
# Solução: Configure a variável APP_KEY
```

### Banco de dados vazio após deploy

```bash
# Verificar se volume está montado
railway run ls -la /var/www/html/database

# Rodar migrations manualmente
railway run php artisan migrate --force
```

### Permissões do SQLite

```bash
# No container
railway run chmod -R 775 /var/www/html/database
railway run chown -R www-data:www-data /var/www/html/database
```

### Assets não aparecem

```bash
# Rebuild com cache limpo
railway up --force

# Ou limpar cache manualmente
railway run php artisan config:clear
railway run php artisan view:clear
railway run php artisan cache:clear
```

## 🔐 Segurança

### Variáveis obrigatórias em produção:

```env
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:... (único e secreto)
LOG_LEVEL=error
```

### Backup do banco

```bash
# Railway
railway run cat database/database.sqlite > backup-$(date +%Y%m%d).sqlite

# Fly.io
fly ssh sftp get /var/www/html/database/database.sqlite backup.sqlite
```

### Restaurar backup

```bash
# Railway - via volume direto
railway up backup.sqlite

# Fly.io
fly ssh console
cd /var/www/html/database
# copie o arquivo via SFTP antes
```

## 📊 Monitoramento

### Railway
- Dashboard tem métricas em tempo real
- Logs acessíveis pela interface
- Alertas de downtime inclusos

### Fly.io
```bash
# Métricas
fly dashboard

# Logs em tempo real
fly logs

# Status
fly status
```

## 🎓 Próximos Passos

1. ✅ Configure domínio customizado
2. ✅ Configure backups automáticos
3. ✅ Configure alertas de monitoramento
4. ✅ Teste performance com usuários reais

## 🆘 Suporte

- Railway: https://railway.app/help
- Fly.io: https://fly.io/docs
- Issues: Abra issue no GitHub do projeto

