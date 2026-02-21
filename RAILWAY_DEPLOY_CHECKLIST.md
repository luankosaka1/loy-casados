# 📋 Checklist para Deploy no Railway

## ✅ Antes do Deploy

- [ ] Verifique se todos os arquivos foram commitados
- [ ] Execute localmente: `bash test-local.sh`
- [ ] Teste a página inicial: http://localhost:8000
- [ ] Verifique se o banco de dados foi criado em `database/database.sqlite`
- [ ] Confirme que não há erros no terminal

## 📝 Comandos para Deploy

```bash
# 1. Adicionar arquivos modificados
git add Dockerfile docker/entrypoint.sh docker/default.conf .env .env.railway

# 2. Adicionar novos arquivos (documentação e scripts)
git add ERRO_500_RAILWAY_SOLUCAO.md test-local.sh RAILWAY_DEPLOY_FIX.md RAILWAY_DEPLOY_INSTRUCTIONS.md DEPLOYMENT_COMPLETE.md

# 3. Commit
git commit -m "fix: resolve 500 error - improve cache init, permissions, and nginx config"

# 4. Push para Railway
git push origin main
```

## 🚀 Após o Push

Railway detectará as mudanças automaticamente:

1. **Build começa automaticamente** (3-5 minutos)
2. **Verifique os logs** no Railway dashboard
3. **Procure por erros** na seção de "Logs"

## 🔍 Verificações no Railway Dashboard

### Na seção "Logs":
```
✅ Procure por: "Blade templates cached successfully"
✅ Procure por: "Routes cached successfully"
✅ Procure por: "Configuration cached successfully"
❌ Procure por erros: "error", "exception", "500"
```

### Indicadores de Sucesso:
- ✅ `[21-Feb-2026 11:18:23] NOTICE: ready to handle connections`
- ✅ `spawned: 'nginx' with pid 20`
- ✅ `spawned: 'php-fpm' with pid 21`
- ✅ `success: nginx entered RUNNING state`
- ✅ `success: php-fpm entered RUNNING state`

## 🌐 Teste a Aplicação

1. **Acesse a URL do Railway** (ex: https://your-app.railway.app)
2. **Verifique a página inicial** - deve carregar sem erros
3. **Teste o login** - acesse `/player/login`
4. **Monitore os logs** - observe requisições chegarem

## ⚠️ Se Ainda Houver Erro 500

### 1. Verifique o Log Detalhado
```
Vá em Railway Dashboard → Aplicação → Logs
Procure por mensagens de erro específicas do PHP/Laravel
```

### 2. Comandos de Diagnóstico
```bash
# Ver variáveis de ambiente
railway vars

# Executar migrations manualmente
railway run php artisan migrate --force

# Ver permissões do diretório
railway run ls -la /var/www/html/storage

# Ver logs do Laravel
railway run tail -f /var/www/html/storage/logs/laravel.log
```

### 3. Problemas Comuns
| Problema | Solução |
|----------|---------|
| `storage` sem permissão de escrita | Railway usará volume efêmero - configure volume persistente |
| `database.sqlite` não existe | Entrypoint cria automaticamente |
| Cache corrompido | Entrypoint limpa cache automaticamente |
| APP_KEY faltando | Defina em Railway Variables |

## 📦 Variáveis de Ambiente Necessárias

No Railway Dashboard, defina:

```
APP_NAME=LoY - CASADOS
APP_ENV=production
APP_DEBUG=false
APP_URL=https://seu-railway-url.railway.app
APP_KEY=base64:odTgF9snyWzcdw9Y4TD6ulhSc+rlgeQ8XMBeP8hgFLY=
DB_CONNECTION=sqlite
DB_DATABASE=/var/www/html/database/database.sqlite
LOG_LEVEL=info
```

## 📚 Documentação Relacionada

- **Solução do Erro 500**: `ERRO_500_RAILWAY_SOLUCAO.md`
- **SQLite Fix**: `RAILWAY_DEPLOY_FIX.md`
- **Deploy Instructions**: `RAILWAY_DEPLOY_INSTRUCTIONS.md`

## ✅ Status Atual

| Item | Status |
|------|--------|
| SQLite 3.45.1 | ✅ Compilado |
| PHP 8.4 | ✅ Configurado |
| Cache Initialization | ✅ Melhorado |
| Permissões | ✅ Corrigidas |
| Nginx Config | ✅ Otimizado |
| .env | ✅ SQLite configurado |

---

**Pronto para deploy!** 🚀

Execute os comandos acima e monitore o processo no Railway Dashboard.

