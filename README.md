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

## Instalação

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

## Acesso

Acesse o painel administrativo em: `http://localhost:8000/admin`

## Estrutura do Banco de Dados

### Players
- `id`, `name`, `power`, `timestamps`

### Events
- `id`, `name`, `points`, `timestamps`

### Check-ins
- `id`, `player_id`, `event_id`, `checked_in_at`, `timestamps`

## Licença

Este projeto é de código fechado e proprietário.
