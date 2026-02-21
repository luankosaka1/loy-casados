# Erro 500 no Railway - Solução

## Problema
```
127.0.0.1 - 21/Feb/2026:17:10:09 +0000 "GET /index.php" 500
```

## Causa Raiz
O erro 500 ocorria por:
1. ❌ Permissões de arquivo incorretas em `/storage` e `/bootstrap/cache`
2. ❌ Diretórios de cache não criados
3. ❌ Cache não inicializado antes do primeiro acesso
4. ❌ Banco de dados SQLite não inicializado

## Solução Implementada

### 1. Dockerfile - Criar Diretórios de Cache
```dockerfile
# Create all necessary directories with proper permissions
RUN mkdir -p /var/www/html/storage/framework/cache \
    && mkdir -p /var/www/html/storage/framework/sessions \
    && mkdir -p /var/www/html/storage/framework/views \
    && mkdir -p /var/www/html/storage/logs \
    && chown -R www-data:www-data /var/www/html/storage \
    && chmod -R 775 /var/www/html/storage
```

### 2. Entrypoint - Inicializar Cache Antes de Tudo
```bash
# Clear all caches first
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear

# Run migrations
php artisan migrate --force --no-interaction

# Cache everything
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize
```

### 3. Permissões de Arquivo
```bash
chmod -R 775 /var/www/html/storage
chmod -R 775 /var/www/html/bootstrap/cache
chown -R www-data:www-data /var/www/html/storage
chown -R www-data:www-data /var/www/html/bootstrap/cache
```

## Arquivos Modificados

✅ `Dockerfile` - Adicionar criação de diretórios de cache
✅ `docker/entrypoint.sh` - Melhorar inicialização do aplicativo
✅ `.env.railway` - Novo arquivo com configurações para produção

## Para Fazer Deploy

1. **Commit das mudanças**:
```bash
git add Dockerfile docker/entrypoint.sh .env.railway
git commit -m "fix: resolve 500 error by improving cache initialization and permissions"
git push origin main
```

2. **No Railway Dashboard**:
   - Defina as variáveis de ambiente:
     ```
     APP_ENV=production
     APP_DEBUG=false
     APP_URL=https://seu-railway-url.railway.app
     ```
   - Ou copie o conteúdo de `.env.railway` para as variáveis

3. **Railway fará um novo deploy automaticamente**

## Verificação

Após o deploy:
- ✅ Verificar se os logs não mostram mais erros 500
- ✅ Acessar a página inicial da aplicação
- ✅ Testar login de players
- ✅ Verificar que o banco de dados está sendo utilizado

## Observações

- O erro 500 é comumente causado por permissões no Laravel
- A cache é essencial para performance em produção
- SQLite requer diretório de banco de dados com permissões de escrita
- A inicialização do entrypoint garante que tudo esteja pronto antes de aceitar requisições

## Se Persistir o Erro 500

Verifique o log detalhado do Railway:
1. Acesse o Rails dashboard
2. Vá para "Logs" da aplicação
3. Procure por mensagens de erro específicas do PHP/Laravel
4. Verifique se há erros de permissão ou arquivo não encontrado

Comandos úteis para diagnóstico:
```bash
# Ver logs do supervisor
railway run tail -f /var/log/supervisor/supervisord.log

# Ver logs do nginx
railway run tail -f /var/log/nginx/error.log

# Ver logs do Laravel
railway run tail -f /var/www/html/storage/logs/laravel.log

# Verificar permissões
railway run ls -la /var/www/html/storage
railway run ls -la /var/www/html/bootstrap/cache
```

