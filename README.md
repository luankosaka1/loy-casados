# [LoY] CASADOS - Check-in System

Sistema de gerenciamento de check-ins para jogadores com pontuação e recompensas.

## Sobre o Projeto

O [LoY] CASADOS é um sistema construído com Laravel e Filament para gerenciar check-ins de jogadores em eventos, calcular pontuações baseadas em power e pontos, e gerenciar recompensas semanais.

## Funcionalidades

### Gerenciamento de Players
- Cadastro de jogadores com nome e power
- Importação em massa via CSV (nome e power)
- Atualização automática de players existentes na importação
- Exibição do player com maior power no dashboard

### Gerenciamento de Eventos
- Cadastro de eventos com nome e pontos
- Vinculação com check-ins

### Sistema de Check-ins
- Registro de check-ins vinculando players e eventos
- Data e hora de check-in
- Interface para gerenciamento completo

### Análises e Relatórios
- **Weekly Player Power**: Soma do power do player multiplicado pela quantidade de check-ins por semana
- **Weekly Player Score**: Soma do power do player multiplicado pelos pontos dos eventos por semana
- **Rewards**: Pontuação total de cada player (soma de pontos de check-ins × power do player)
  - Filtro por período de check-in
  - Filtro padrão para a semana atual
  - Cálculo: `(player.power / 100000) × sum(event.points)` com 2 casas decimais

## Tecnologias

- **Laravel 11.x** - Framework PHP
- **Filament 3.x** - Painel administrativo
- **SQLite** - Banco de dados
- **Tailwind CSS** - Estilização

## Instalação Local

```bash
# Clone o repositório
git clone <repository-url>
cd laracheckin

# Instale as dependências
composer install
npm install

# Configure o ambiente
cp .env.example .env
php artisan key:generate

# Execute as migrações
php artisan migrate

# Compile os assets
npm run build

# Inicie o servidor
php artisan serve
```

## Deploy com Docker (Recomendado)

### Build e Run Local

```bash
# Build da imagem
docker build -t laracheckin:latest .

# Run do container
docker run -d \
  -p 8080:80 \
  --name laracheckin \
  -e APP_KEY=base64:YOUR_APP_KEY_HERE \
  -e APP_URL=http://your-domain.com \
  -v $(pwd)/database:/var/www/html/database \
  laracheckin:latest
```

### Hospedagens Recomendadas

#### 1. **Render.com**
- **Custo**: $7/mês (plan individual)
- **Vantagens**: SSL grátis, banco de dados PostgreSQL incluso
- **Deploy**: Push no GitHub e conecta

#### 2. **Fly.io**
- **Custo**: ~$3-5/mês (256MB RAM)
- **Vantagens**: Múltiplas regiões, escala automática
- **Deploy**:
```bash
# Instale o CLI
curl -L https://fly.io/install.sh | sh

# Configure o projeto
fly launch

# Deploy
fly deploy
```

#### 3. **DigitalOcean App Platform**
- **Custo**: $5/mês
- **Vantagens**: Infraestrutura confiável, fácil escalar
- **Deploy**: Conecte o GitHub ou Docker Hub

#### 4. **Heroku**
- **Custo**: $7/mês (Eco Dyno)
- **Vantagens**: Tradicional e estável

### Deployment com Docker

Para fazer deploy em qualquer plataforma de nuvem, você pode usar o Dockerfile incluído no projeto. Certifique-se de:

1. **Push do código para GitHub**
```bash
git add .
git commit -m "Add Docker configuration"
git push origin main
```

2. **Preparar Variáveis de Ambiente**
   - `APP_KEY` (gere com `php artisan key:generate --show`)
   - `APP_URL` (será fornecido pela sua hospedagem)
   - `APP_ENV=production`
   - `APP_DEBUG=false`

3. **Deploy**
   - Siga as instruções da plataforma escolhida

4. **Criar Usuário Admin**
```bash
# Execute em seu container:
php artisan make:filament-user
```

## Estrutura do Banco de Dados

### Players
- `id`, `name`, `power`, `timestamps`

### Events
- `id`, `name`, `points`, `timestamps`

### Check-ins
- `id`, `player_id`, `event_id`, `checked_in_at`, `timestamps`

## Acesso

**Local**: `http://localhost:8000/admin`  
**Docker Local**: `http://localhost:8080/admin`  
**Produção**: `https://seu-dominio/admin`

## Manutenção

### Backup do Banco de Dados
```bash
# Copiar banco do container
docker cp laracheckin:/var/www/html/database/database.sqlite ./backup-$(date +%Y%m%d).sqlite
```

### Criar Usuário Admin
```bash
# Local
php artisan make:filament-user

# Docker
docker exec -it laracheckin php artisan make:filament-user
```

## Segurança

- ✅ Banco SQLite com permissões restritas
- ✅ Sem portas expostas desnecessárias
- ✅ SSL/HTTPS habilitado (configurável pela hospedagem)
- ✅ Variáveis de ambiente protegidas
- ✅ APP_DEBUG=false em produção

## Suporte

Para dúvidas sobre deploy ou configuração, consulte a documentação das plataformas:
- Fly.io: https://fly.io/docs
- Render: https://render.com/docs

## Licença

Este projeto é de código fechado e proprietário.
