# 🚀 TESTE DE PRODUÇÃO LOCAL

## 📝 Como Usar

Este guia explica como testar sua aplicação em **modo produção** localmente, antes de fazer deploy no Railway.

---

## 🎯 Objetivo

Detectar erros que só aparecem em produção ANTES de enviar para Railway:

✅ Problemas com permissões
✅ Erros de cache
✅ Migrations falhando
✅ Configurações incorretas
✅ Extensões PHP faltando

---

## 🚀 PASSO A PASSO

### 1️⃣ Executar o Script de Setup

```bash
cd /Users/luan/dev/lab/laracheckin

# Execute o script de teste de produção
./test-production.sh
```

**O script vai:**
- ✅ Carregar `.env.production.local` (config de produção)
- ✅ Limpar todos os caches
- ✅ Verificar/criar database
- ✅ Rodar migrações
- ✅ Gerar caches de produção
- ✅ Otimizar a aplicação

### 2️⃣ Iniciar o Servidor

Após o script completar, execute:

```bash
php artisan serve
```

**Ou para acessar de outros computadores:**

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

### 3️⃣ Testar a Aplicação

Abra no navegador:

- 🏠 **Home**: http://localhost:8000
- 👤 **Admin**: http://localhost:8000/admin
- 🎮 **Player Login**: http://localhost:8000/players/login

### 4️⃣ Monitorar Logs

Em outro terminal:

```bash
tail -f storage/logs/laravel.log
```

---

## 📊 Diferenças: Local vs Produção

### Configuração Local (desenvolvimento):
```env
APP_ENV=local
APP_DEBUG=true
LOG_LEVEL=debug
CACHE_STORE=database (com logs)
```

### Configuração Produção (`.env.production.local`):
```env
APP_ENV=production
APP_DEBUG=false
LOG_LEVEL=info
CACHE_STORE=database (otimizado)
```

---

## ⚠️ O Que Muda em Produção

### 1. APP_DEBUG=false
- ❌ Erros não mostram stack trace completo
- ✅ Mais seguro
- ⚠️ Menos informações para debug

### 2. Cache Ativado
- ✅ Config é cacheado
- ✅ Routes são cacheados
- ✅ Views são cacheadas
- ⚠️ Mudanças em código requerem `config:clear`

### 3. LOG_LEVEL=info
- ❌ Logs debug não aparecem
- ✅ Menos I/O
- ⚠️ Apenas erros importantes são registrados

### 4. Otimização
- ✅ Autoloader otimizado
- ✅ Menos callbacks desnecessários
- ✅ Melhor performance

---

## 🔍 Checklist de Testes

Após executar o script, verifique:

```
□ Script completou sem erros
□ .env foi carregado como "production"
□ Banco de dados foi criado
□ Migrações rodaram
□ Caches foram gerados
□ Home page carrega (http://localhost:8000)
□ Admin panel abre (/admin)
□ Login de players funciona (/players/login)
□ Logs não mostram erros críticos
□ Database operations funcionam
□ Filament functions funcionam
□ CSV imports funcionam (se tiver)
□ Rewards system funciona
□ All features você testará
```

---

## 🚨 Se Encontrar Erros

### Erro: "APP_DEBUG must be false or true"
```bash
# Verifique o .env
grep APP_DEBUG .env

# Deve estar assim:
APP_DEBUG=false
# Não assim:
APP_DEBUG="false"
```

### Erro: "Cache table not found"
```bash
# Execute migrations novamente
php artisan migrate:fresh --seed
php artisan config:cache
```

### Erro: "Route cache stale"
```bash
# Limpe route cache
php artisan route:clear
php artisan route:cache
```

### Erro: "View compile failed"
```bash
# Limpe view cache
php artisan view:clear
php artisan view:cache
```

### Erro ao acessar admin
```bash
# Verifique permissões
chmod -R 775 storage/
chmod -R 775 bootstrap/cache/

# Limpe tudo
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

---

## 🎯 Workflow de Desenvolvimento

### Normal (desenvolvimento):
```bash
# Editar código
nano app/Http/Controllers/SomeController.php

# Servidor já está rodando
# Apenas recarregue o navegador - tudo funciona!
```

### Teste de Produção:
```bash
# 1. Preparar configuração
./test-production.sh

# 2. Iniciar servidor
php artisan serve

# 3. Testar tudo
# Acesse http://localhost:8000 no navegador

# 4. Se algo falhar, verifique logs
tail -f storage/logs/laravel.log

# 5. Fazer ajustes
nano app/...

# 6. Limpar caches (importante em produção!)
php artisan config:clear
php artisan route:clear
php artisan view:clear

# 7. Recarregar página
# Testar novamente
```

---

## 💡 Dicas

### Para Reverter para Desenvolvimento

```bash
# Se você tiver um .env.local
cp .env.local .env

# Ou edite manualmente:
nano .env
# E mude:
# APP_ENV=local
# APP_DEBUG=true
# LOG_LEVEL=debug
```

### Para Entender Melhor

```bash
# Ver config carregado
php artisan config:show

# Ver rotas
php artisan route:list

# Ver variáveis de ambiente
php artisan tinker
# Dentro do tinker:
env('APP_NAME')
env('APP_ENV')
env('APP_DEBUG')
config('app.name')
```

### Para Teste Rápido de Um Feature

```bash
# Apenas limpar e cachear
php artisan config:cache
php artisan route:cache

# Testar no navegador
# Se falhar:
php artisan config:clear
# Fazer ajuste no código
# Tentar novamente
```

---

## 📚 Arquivos Relacionados

- **`.env.production.local`** - Configuração de produção para testes
- **`test-production.sh`** - Script de setup automático
- **`storage/logs/laravel.log`** - Log da aplicação
- **`bootstrap/cache/`** - Caches gerados
- **`database/database.sqlite`** - Banco de dados local

---

## 🚀 Próximas Etapas

### Depois de testar e resolver erros:

1. ✅ Confirmar que tudo funciona em produção local
2. ✅ Fazer commit das mudanças
3. ✅ Push para Railway
4. ✅ Aguardar deploy
5. ✅ Testar em https://loy-casados.up.railway.app

---

## 🎉 Exemplo de Uso Completo

```bash
# 1. Preparar produção local
./test-production.sh

# Output esperado:
# ✅ .env configurado como produção
# ✅ Caches limpos
# ✅ Banco de dados OK
# ✅ Migrações concluídas
# ✅ Caches gerados
# ✅ Aplicação otimizada

# 2. Iniciar servidor
php artisan serve

# Output esperado:
# Laravel development server started: http://127.0.0.1:8000

# 3. Em outro terminal, monitorar logs
tail -f storage/logs/laravel.log

# 4. Testar no navegador
# http://localhost:8000

# 5. Se algo falhar, ver o erro no terminal dos logs
# Fazer ajuste no código
# Limpar caches se necessário
php artisan config:clear

# 6. Recarregar página e testar novamente
```

---

## 📞 Troubleshooting

### Script não executa?
```bash
# Dar permissão
chmod +x test-production.sh

# Executar
./test-production.sh
```

### Erro de permissão no banco?
```bash
# Dar permissão 666 no database
chmod 666 database/database.sqlite

# Ou 777 no diretório
chmod 777 database/
```

### Composer não reconhece mudanças?
```bash
# Regenerar autoload
composer dump-autoload

# Ou com otimização
composer dump-autoload --optimize
```

### Ainda não funciona?
```bash
# Nuclear option - limpar tudo
rm -rf bootstrap/cache/*
rm -rf storage/logs/*
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Rodar migrations
php artisan migrate:fresh

# Recriar tudo
./test-production.sh

# Iniciar
php artisan serve
```

---

*Guia criado em: 22 de Fevereiro de 2026*  
*Para testar configurações de produção localmente*  
*Simula exatamente: Railway.app environment*

