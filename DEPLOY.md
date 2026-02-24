# Deploy Docker para [LoY] CASADOS

Este guia detalha o processo de deploy usando Docker em hospedagens econômicas.

## 📦 O que está no Container?

O Dockerfile criado empacota **tudo em um único container**:
- ✅ PHP 8.4 + Apache
- ✅ SQLite (banco de dados)
- ✅ Laravel + Filament compilados

**Características:**
- Single container com tudo que precisa
- Sem necessidade de orquestração complexa
- Fácil de fazer deploy em qualquer hospedagem

## 🌐 Hospedagens Recomendadas

### 1. **Fly.io** (Recomendado)
- **Custo**: ~$3-5/mês
- **Vantagens**: Múltiplas regiões, SSL grátis, fácil setup
- **Docs**: https://fly.io/docs

### 2. **Render.com**
- **Custo**: $7/mês
- **Vantagens**: Interface intuitiva, SSL grátis
- **Docs**: https://render.com/docs

### 3. **DigitalOcean App Platform**
- **Custo**: $5/mês
- **Vantagens**: Infraestrutura confiável
- **Docs**: https://docs.digitalocean.com

## 🐳 Teste Local com Docker

Antes de fazer deploy, teste localmente:

```bash
# Build
docker build -t laracheckin:test .

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

## 🔧 Variáveis de Ambiente Necessárias

Ao fazer deploy, configure estas variáveis:

```env
APP_NAME=LoY - CASADOS
APP_ENV=production
APP_KEY=base64:SUA_CHAVE_AQUI (gere com: php artisan key:generate --show)
APP_DEBUG=false
APP_URL=https://seu-dominio.com
DB_CONNECTION=sqlite
LOG_LEVEL=error
SESSION_DRIVER=file
CACHE_STORE=file
```

## 📊 Banco de Dados

O projeto usa SQLite. Certifique-se de:

1. Criar um volume persistente para `/var/www/html/database`
2. Configurar permissões corretas (775)
3. Fazer backups regularmente

### Backup Manual

```bash
# Copiar banco do container
docker cp seu-container:/var/www/html/database/database.sqlite ./backup-$(date +%Y%m%d).sqlite
```

## 🔐 Segurança em Produção

- ✅ Configure `APP_ENV=production`
- ✅ Configure `APP_DEBUG=false`
- ✅ Use variáveis de ambiente secretas
- ✅ Sempre use HTTPS
- ✅ Faça backups regulares

## 🎓 Próximos Passos

1. Escolha uma hospedagem
2. Prepare as variáveis de ambiente
3. Teste localmente com Docker
4. Faça deploy
5. Configure backups automáticos
6. Monitore logs e performance

## 🆘 Suporte

Para dúvidas sobre deploy, consulte a documentação da hospedagem escolhida.


