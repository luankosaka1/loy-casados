#!/bin/bash

# Script para testar a aplicação localmente antes do deploy no Railway

echo "================================"
echo "Teste Local - Lara Check-in"
echo "================================"
echo ""

# Verificar se está no diretório correto
if [ ! -f "artisan" ]; then
    echo "❌ Erro: Execute este script na raiz do projeto"
    exit 1
fi

echo "✅ Diretório correto"
echo ""

# Limpar caches
echo "🧹 Limpando caches..."
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear
echo ""

# Executar migrations
echo "🗄️  Executando migrations..."
php artisan migrate --force
echo ""

# Compilar caches
echo "⚙️  Compilando caches..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize
echo ""

# Verificar permissões
echo "🔐 Verificando permissões..."
chmod -R 775 storage bootstrap/cache
echo "✅ Permissões atualizadas"
echo ""

# Iniciar servidor de desenvolvimento
echo "🚀 Iniciando servidor de desenvolvimento..."
echo "Acesse: http://localhost:8000"
echo "Para parar: pressione Ctrl+C"
echo ""

php artisan serve --host=0.0.0.0 --port=8000

