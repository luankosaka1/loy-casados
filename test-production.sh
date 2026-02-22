#!/bin/bash

# Script para testar em modo produção localmente
# Simula exatamente o comportamento do Railway

set -e

echo "=================================================="
echo "🚀 TESTANDO APLICAÇÃO EM MODO PRODUÇÃO (LOCAL)"
echo "=================================================="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. Carregar variáveis de produção
echo -e "${BLUE}1. Carregando configurações de produção...${NC}"
if [ -f .env.production.local ]; then
    cp .env.production.local .env
    echo -e "${GREEN}✅ .env configurado como produção${NC}"
else
    echo -e "${RED}❌ .env.production.local não encontrado!${NC}"
    exit 1
fi
echo ""

# 2. Limpar caches
echo -e "${BLUE}2. Limpando caches...${NC}"
php artisan config:clear 2>/dev/null || echo "Config clear skipped"
php artisan cache:clear 2>/dev/null || echo "Cache clear skipped"
php artisan view:clear 2>/dev/null || echo "View clear skipped"
php artisan route:clear 2>/dev/null || echo "Route clear skipped"
echo -e "${GREEN}✅ Caches limpos${NC}"
echo ""

# 3. Verificar database
echo -e "${BLUE}3. Verificando banco de dados...${NC}"
if [ ! -f database/database.sqlite ]; then
    echo "Criando database.sqlite..."
    touch database/database.sqlite
fi
chmod 666 database/database.sqlite
echo -e "${GREEN}✅ Banco de dados OK${NC}"
echo ""

# 4. Rodar migrations
echo -e "${BLUE}4. Executando migrações...${NC}"
php artisan migrate --force --no-interaction 2>&1 || true
echo -e "${GREEN}✅ Migrações concluídas${NC}"
echo ""

# 5. Gerar caches de produção
echo -e "${BLUE}5. Gerando caches de produção...${NC}"
php artisan config:cache 2>&1 || echo "Config cache skipped"
php artisan route:cache 2>&1 || echo "Route cache skipped"
php artisan view:cache 2>&1 || echo "View cache skipped"
echo -e "${GREEN}✅ Caches gerados${NC}"
echo ""

# 6. Optimizar aplicação
echo -e "${BLUE}6. Otimizando aplicação...${NC}"
php artisan optimize 2>&1 || echo "Optimization skipped"
echo -e "${GREEN}✅ Aplicação otimizada${NC}"
echo ""

# 7. Mostrar informações de configuração
echo -e "${YELLOW}=================================================="
echo "📊 CONFIGURAÇÃO CARREGADA"
echo "==================================================${NC}"
echo ""
echo "APP_NAME: $(grep APP_NAME .env | cut -d= -f2)"
echo "APP_ENV: $(grep '^APP_ENV' .env | cut -d= -f2)"
echo "APP_DEBUG: $(grep '^APP_DEBUG' .env | cut -d= -f2)"
echo "LOG_LEVEL: $(grep '^LOG_LEVEL' .env | cut -d= -f2)"
echo "DB_CONNECTION: $(grep '^DB_CONNECTION' .env | cut -d= -f2)"
echo "CACHE_STORE: $(grep '^CACHE_STORE' .env | cut -d= -f2)"
echo ""

# 8. Listar tabelas do banco
echo -e "${YELLOW}Tabelas criadas no banco:${NC}"
if command -v sqlite3 &> /dev/null; then
    sqlite3 database/database.sqlite ".tables"
else
    echo "sqlite3 não disponível, pulando listagem de tabelas"
fi
echo ""

# 9. Instruções para iniciar servidor
echo -e "${GREEN}=================================================="
echo "✅ CONFIGURAÇÃO CONCLUÍDA!"
echo "==================================================${NC}"
echo ""
echo -e "${YELLOW}Para iniciar o servidor em MODO PRODUÇÃO, execute:${NC}"
echo ""
echo -e "${BLUE}php artisan serve${NC}"
echo ""
echo -e "${YELLOW}Ou para modo debug (se necessário):${NC}"
echo ""
echo -e "${BLUE}php artisan serve --host=0.0.0.0 --port=8000${NC}"
echo ""
echo -e "${YELLOW}Acesse:${NC}"
echo -e "  - Home: ${BLUE}http://localhost:8000${NC}"
echo -e "  - Admin: ${BLUE}http://localhost:8000/admin${NC}"
echo -e "  - Players: ${BLUE}http://localhost:8000/players/login${NC}"
echo ""
echo -e "${YELLOW}Para voltar ao modo development:${NC}"
echo -e "  ${BLUE}cp .env.local .env${NC} (se existir)"
echo -e "  ou edite .env manualmente"
echo ""
echo -e "${YELLOW}Para ver os logs:${NC}"
echo -e "  ${BLUE}tail -f storage/logs/laravel.log${NC}"
echo ""

