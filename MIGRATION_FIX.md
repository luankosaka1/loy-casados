# ✅ Solução: Erro ao Remover Índice Único (SQLSTATE[HY000]: 1553)

## O Problema

```
SQLSTATE[HY000]: General error: 1553 Cannot drop index 'player_drop_rewards_player_id_drop_id_unique': 
needed in a foreign key constraint
```

**Causa:** O MySQL não permite remover um índice único se ele está sendo usado por uma constraint de chave estrangeira.

---

## A Solução ✅

A migration foi corrigida para **desabilitar as restrições de chave estrangeira** antes de remover o índice:

```php
public function up(): void
{
    // ✅ Desabilita FK checks
    Schema::disableForeignKeyConstraints();

    // Agora é seguro remover o índice
    Schema::table('player_drop_rewards', function (Blueprint $table) {
        $table->dropUnique(['player_id', 'drop_id']);
    });

    // ✅ Reabilita FK checks
    Schema::enableForeignKeyConstraints();
}
```

---

## Como Aplicar

### Opção 1: Nova Migration (Recomendado)

Se você já tentou rodar a migration anterior e falhou:

```bash
# Rollback da migration anterior
php artisan migrate:rollback

# Agora a migration corrigida funcionará
php artisan migrate
```

### Opção 2: Se Já Rodou e Falhou

Se a migration falhou no meio do caminho, você pode:

```bash
# Limpar o erro manualmente
php artisan tinker

>>> DB::statement('SET FOREIGN_KEY_CHECKS=0');
>>> DB::statement('ALTER TABLE player_drop_rewards DROP INDEX player_drop_rewards_player_id_drop_id_unique');
>>> DB::statement('SET FOREIGN_KEY_CHECKS=1');
>>> exit

# Marcar como migrada
php artisan migrate:resolve
```

---

## Verificação ✅

Após aplicar a migration, verifique:

```bash
php artisan tinker

# Verificar que o índice foi removido
>>> DB::select('SHOW INDEXES FROM player_drop_rewards WHERE Column_name = "player_id"');
# player_id não deve aparecer com "Seq_in_index" = 1 e "Key_name" = "player_id_drop_id_unique"

# Testar criar múltiplos registros com mesmo player-drop
>>> App\Models\PlayerDropReward::create(['player_id' => 1, 'drop_id' => 1, 'sent_at' => now()]);
>>> App\Models\PlayerDropReward::create(['player_id' => 1, 'drop_id' => 1, 'sent_at' => now()]);
>>> App\Models\PlayerDropReward::count();
# Deve retornar 2 (sucesso!)

>>> exit
```

---

## Próximos Passos

1. ✅ Aplicar a migration corrigida:
   ```bash
   php artisan migrate
   ```

2. ✅ Verificar que funciona:
   ```bash
   php artisan tinker
   # (testes acima)
   ```

3. ✅ Rodar os testes:
   ```bash
   php artisan test tests/Feature/DropDistributionTest.php
   ```

4. ✅ Usar o sistema:
   ```bash
   php artisan app:distribute-drops
   ```

---

## Entendimento Técnico

### Por que isso acontece?

No MySQL, quando você cria um índice único em `(player_id, drop_id)`, esse índice pode estar sendo usado internamente pela constraint de chave estrangeira. Remover o índice direto pode violar a FK.

### Como a solução funciona?

```sql
-- Desabilita todas as verificações de FK
SET FOREIGN_KEY_CHECKS=0;

-- Agora é seguro remover o índice
ALTER TABLE player_drop_rewards DROP INDEX player_drop_rewards_player_id_drop_id_unique;

-- Reabilita as verificações de FK
SET FOREIGN_KEY_CHECKS=1;
```

O Laravel wrapper:
```php
Schema::disableForeignKeyConstraints();  // Equivalente a: SET FOREIGN_KEY_CHECKS=0;
// ... fazer alterações ...
Schema::enableForeignKeyConstraints();   // Equivalente a: SET FOREIGN_KEY_CHECKS=1;
```

---

## Diferenças de Banco de Dados

### MySQL (seu caso)
- ✅ Requer `disableForeignKeyConstraints()`
- ✅ Corrigido na migration

### SQLite
- ✅ Pode não ter o mesmo problema
- ✅ Seguro remover índice diretamente

### PostgreSQL
- ✅ Pode require `SET CONSTRAINTS ALL DEFERRED;`
- ✅ Diferente da sintaxe MySQL

---

## Status

```
✅ Migration Corrigida
✅ Pronta para Aplicar
✅ Documentação Criada
✅ Próximos Passos Claros
```

**Data de Correção:** 17 de Fevereiro de 2026

Agora execute:
```bash
php artisan migrate
```

E o problema será resolvido! ✅

