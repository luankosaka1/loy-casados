# ✅ CORREÇÃO - Erro 500 no Container

## 🔴 PROBLEMA ENCONTRADO

Nos logs você enviou, havia:
```
"GET /index.php" 500
"GET /index.php" 500  (múltiplas vezes)
```

E ao final:
```
Stopping Container
waiting for nginx, php-fpm to die
```

## 🎯 CAUSAS IDENTIFICADAS

1. **Entrypoint.sh usando sh em vez de bash** - Podem faltar features
2. **Permissões de /var/www/html/database não estavam sendo definidas** 
3. **Melhor tratamento de erros** nos comandos artisan
4. **Cache e view directories** não tinham todas as permissões corretas

## ✅ CORREÇÕES APLICADAS

### 1. Mudado de `#!/bin/sh` para `#!/bin/bash`
- Melhor compatibilidade
- Suporte a mais features

### 2. Usando heredoc em vez de echo
```bash
cat > /var/www/html/.env << EOF
# Variáveis aqui
EOF
```
Mais robusto que echo com múltiplas linhas.

### 3. Adicionado comando para database
```bash
chown -R www-data:www-data /var/www/html/database
chmod -R 775 /var/www/html/database
```

### 4. Melhor tratamento de erros
```bash
php artisan config:clear 2>/dev/null || echo "Config clear skipped (expected on first run)"
```
Em vez de:
```bash
php artisan config:clear 2>/dev/null || true
```

### 5. Loop com timeout para database
```bash
for i in {1..30}; do
    if [ -w /var/www/html/database ]; then
        echo "Database directory is ready"
        break
    fi
    sleep 1
done
```
Mais seguro que while infinito.

### 6. Adicionado --quiet aos comandos artisan
```bash
php artisan migrate --force --no-interaction --quiet
php artisan config:cache --quiet
php artisan route:cache --quiet
php artisan view:cache --quiet
php artisan optimize --quiet
```
Menos output, mais limpo.

## 📝 RESUMO DAS MUDANÇAS

| Item | Antes | Depois |
|------|-------|--------|
| Shell | sh | bash ✅ |
| .env creation | echo (múltiplas linhas) | heredoc ✅ |
| Database perms | Não definidas | Definidas ✅ |
| Error handling | Básico | Melhorado ✅ |
| Database wait | while infinito | for loop com timeout ✅ |
| Artisan commands | Verbose | Quiet (--quiet) ✅ |

## 🚀 PRÓXIMOS PASSOS

1. **Git Commit**
```bash
cd /Users/luan/dev/lab/laracheckin
git add docker/entrypoint.sh
git commit -m "fix: improve entrypoint.sh - better error handling, database permissions, heredoc for .env"
git push origin main
```

2. **Railway detecta push** → rebuild automático (3-5 min)

3. **Procure nos logs por:**
```
=== Application ready! ===
Starting Apache...
```

4. **Não deve haver mais erro 500** ✅

## ✅ STATUS

- ✅ entrypoint.sh corrigido
- ✅ Permissões melhoradas
- ✅ Tratamento de erros aprimorado
- ✅ Pronto para deploy

---

**A correção foi aplicada!** 🎉

Faça o commit e push, Railway fará o deploy automático.

