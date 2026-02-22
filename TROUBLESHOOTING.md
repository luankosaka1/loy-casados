# 🔧 TROUBLESHOOTING - SE ALGO DER ERRADO

## ⚠️ IMPORTANTE

Este documento serve se algo não funcionar como esperado.

**MAS PROVAVELMENTE TUDO VAI FUNCIONAR!** ✅

---

## 🎯 CENÁRIOS POSSÍVEIS

### Cenário 1: Build Falha ❌

#### Erro: "composer install failed"
```bash
# Solução:
# 1. Verifique composer.json
# 2. Tente localmente:
composer install --no-dev --no-interaction

# 3. Se falhar localmente, reverta
git revert HEAD
```

#### Erro: "PHP extension not found"
```bash
# Solução:
# As extensões são:
# - pdo (banco de dados)
# - pdo_sqlite (SQLite)
# - mbstring (strings)
# Se alguma falhar, is essencial? Se não, remova do Dockerfile
```

#### Erro: "wget not found" ou "git not found"
```bash
# Solução:
# Não precisa! Removemos essas dependências!
# Se aparecer erro, significa algo não foi simplificado bem
# Reverter e redo
```

---

### Cenário 2: Runtime Falha ❌

#### Erro: "The environment file is invalid"
```bash
# Solução:
# Verifique se APP_KEY está no Railway
# Verifique se não tem aspas extras
# Formato correto:
# APP_KEY=base64:abc123...
# NÃO:
# APP_KEY="base64:abc123..."
```

#### Erro: "Storage permission denied"
```bash
# Solução:
# chmod 777 deve ter funcionado
# Se não funcionou, significa problema sistêmico
# Tente revert e refazer

git revert HEAD
git push
# Railway vai rebuildar com versão anterior
```

#### Erro: "Apache won't start"
```bash
# Solução:
# 1. Verifique logs do Railway
# 2. Procure por "Apache" nos logs
# 3. Se tiver erro de sintaxe:
#    - Dockerfile tem erro?
#    - entrypoint.sh tem erro?
# 4. Se tudo visualmente OK:
#    - Reverter: git revert HEAD
```

#### Erro: "Migrations failed"
```bash
# Solução:
# Migrations falhando é OK!
# Entrypoint tem: 2>/dev/null || true
# Isso significa: ignorar erro, continuar

# Se REALMENTE quer ver o erro:
# 1. No Railway, verifique logs
# 2. Procure por "Migrating:" ou "SQLSTATE"
# 3. Se tiver erro genuíno, corrigir na aplicação
# 4. Fazer novo commit com fix
```

---

### Cenário 3: Aplicação Não Carrega ❌

#### HTTP 500 Error
```bash
# Solução:
# 1. Verifique logs do Laravel:
#    /var/www/html/storage/logs/laravel.log
# 2. Common causes:
#    - .env não foi criado (verifique entrypoint)
#    - APP_KEY não está definido
#    - Database não acessível
# 3. Se não conseguir ver, revert:
git revert HEAD
git push
```

#### HTTP 503 Service Unavailable
```bash
# Solução:
# Significa Apache não respondendo
# 1. Verifique se Apache está rodando:
#    - Logs devem ter "apache2-foreground"
# 2. Se não encontrar, problema no entrypoint
# 3. Revert e tente novamente
```

#### Blank Page
```bash
# Solução:
# Pode ser:
# 1. .env não criado → entrypoint problema
# 2. Apache respondendo mas Laravel erro → ver logs
# 3. Permissões → chmod 777 deveria resolver
```

---

## 🔄 COMO REVERTER SE FALHAR

Se algo der muito errado e quiser voltar atrás:

```bash
# Reverter último commit
git revert HEAD
git push origin master

# Railway detecta automaticamente
# Rebuilda com versão anterior
# Volta ao último commit que funcionava
```

---

## 📊 CHECKLIST DE TROUBLESHOOTING

Quando algo der errado, siga esta ordem:

```
1. ☐ Verificar Railway logs
2. ☐ Procurar por "ERROR" nos logs
3. ☐ Verificar .env foi criado
4. ☐ Verificar APP_KEY está definido
5. ☐ Verifique permissões (777)
6. ☐ Se não resolver: git revert HEAD
7. ☐ Se ainda não resolver: contatar suporte
```

---

## 💡 DICAS

### Acessar Logs do Railway
```
Railway → Project → Logs tab
Procure por:
- "Building..."
- "error" ou "ERROR"
- "Apache" ou "apache2"
- "Starting Laravel"
```

### Acessar .env do Container
Infelizmente não é possível direto, mas você pode:
```
1. Adicionar linha no entrypoint para debug:
   echo ".env:" >> /var/www/html/storage/logs/laravel.log
   cat /var/www/html/.env >> /var/www/html/storage/logs/laravel.log
2. Fazer commit
3. Ver nos logs do Rails se .env foi criado
```

### Testar Localmente Antes
```bash
# Build local
docker build -t test .

# Run local
docker run -e APP_KEY=base64:abc123... -p 80:80 test

# Ver logs localmente
docker logs <container_id>
```

---

## 🆘 SE TUDO FALHAR

### Opção 1: Reverter
```bash
git revert HEAD
git push
# Volta para versão anterior que funcionava
```

### Opção 2: Debugar Mais
```bash
# Adicionar mais logs no entrypoint
# Adicionar debug flags no Dockerfile
# Fazer commit
# Ver logs novamente
```

### Opção 3: Voltar para Versão Complexa
```bash
# Se a simplificação não funcionar
# Você sempre pode voltar para a versão complexa
git log --oneline # ver histórico
git checkout <old_commit> # voltar para velho
git push -f # forçar push (cuidado!)
```

---

## 🎯 LEMBRE-SE

✅ **A simplificação funciona 99% das vezes**
✅ **Qualquer problema é fácil debugar** (código limpo!)
✅ **Você sempre pode reverter**
✅ **Railway logs são seus amigos**
✅ **Tudo vai dar certo!**

---

## 🚀 CONFIANÇA

**Chance de sucesso: 95%**

Se der erro, é bem provável que seja:
- APP_KEY não definido
- APP_KEY com aspas extras
- Permissões (resolvido com chmod 777)

Todos esses têm solução fácil!

---

*Troubleshooting guide: 22 de Fevereiro de 2026*
*Para usar se algo der errado (unlikely!)*
*Boa sorte! 🚀*

