# Drops CSV Import

## Formato do Arquivo CSV

O arquivo CSV para importar drops deve ter o seguinte formato:

### Estrutura
- **Primeira linha**: Cabeçalho (será ignorado durante a importação)
- **Colunas**: quantity, name, place (nessa ordem)

### Exemplo

```csv
quantity,name,place
5,Sword of Fire,Dragon Cave
10,Magic Potion,Mystic Forest
100,Gold Coin,Treasure Chest
```

### Regras de Importação

1. A primeira linha (cabeçalho) é sempre ignorada
2. Cada linha após o cabeçalho cria um novo registro
3. As colunas devem estar na ordem: **quantity, name, place**
4. O campo `quantity` deve ser um número inteiro
5. Registros sempre são criados como novos (não atualiza existentes)
6. Espaços em branco no início e fim são removidos automaticamente

### Como Importar

1. Acesse **Rewards > Drops** no menu lateral
2. Clique no botão **Import CSV** na barra de ações
3. Selecione seu arquivo CSV
4. Clique em confirmar
5. Uma notificação mostrará quantos registros foram importados com sucesso

### Arquivo de Exemplo

Um arquivo de exemplo está disponível em: `storage/app/drops_example.csv`

### Ordem das Colunas

⚠️ **IMPORTANTE**: A ordem das colunas é QUANTIDADE, NOME, LOCAL

```
quantity | name            | place
---------|-----------------|------------------
5        | Sword of Fire   | Dragon Cave
10       | Magic Potion    | Mystic Forest
100      | Gold Coin       | Treasure Chest
```

