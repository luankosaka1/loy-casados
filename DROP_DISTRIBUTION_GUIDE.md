# Drop Distribution System - Guia Completo

## 📦 Visão Geral

O sistema de distribuição de drops foi projetado para distribuir itens de forma justa e automática aos jogadores com base em seu **reward score** e **preferências de drops**.

## 🎯 Conceitos Principais

### Reward Score
O reward score é calculado para cada jogador baseado em:
- **Power do jogador**: valor configurado no perfil
- **Pontos de check-in**: soma de pontos dos eventos em que o jogador fez check-in

**Fórmula:**
```
Reward Score = (Power ÷ 100000) × Total Check-in Points
```

**Exemplo:**
- Jogador A: Power 50000, Pontos totais 1000 → Score = (50000/100000) × 1000 = 500
- Jogador B: Power 100000, Pontos totais 500 → Score = (100000/100000) × 500 = 500

### Player Drop Preferences
Cada jogador pode definir até 10 drops que deseja receber, ordenados por prioridade:
1. Priority 1 (preferência máxima)
2. Priority 2
3. ... até Priority 10 (preferência mínima)

## 🔄 Algoritmo de Distribuição

### Passo 1: Preparação
1. Carregar todos os jogadores com suas preferências
2. Calcular reward score de cada jogador
3. Ordenar jogadores por reward score (maior primeiro)
4. Criar inventário com quantidade disponível de cada drop

### Passo 2: Loop de Redistribuição
O sistema executa múltiplas rodadas até que **todos os drops sejam distribuídos**:

#### **Rodada N:**

Para cada jogador (em ordem de reward score):
1. Verificar preferências do jogador em ordem de prioridade
2. Para cada preferência:
   - Se o drop tem quantidade disponível → **Enviar drop ao jogador**
   - Decrementar quantidade disponível do drop
   - Passar para o próximo jogador
   - *(O jogador recebe apenas 1 drop por rodada)*

#### **Redistribuição de Drops Restantes:**

Se houver drops restantes após todos os jogadores serem processados:
1. Iniciar nova rodada
2. Tentar enviar drops novamente seguindo as preferências
3. Se ainda houver drops sem preferências correspondentes, distribuir aleatoriamente
4. Continuar até que **não haja mais drops ou alcançar limite de rodadas**

### Passo 3: Finalização
- Total de drops distribuídos é reportado
- Drops restantes (se houver) são listados
- Sistema registra a data/hora da distribuição

## 💡 Exemplo Prático

### Cenário:
- **Jogadores:** A (score 500), B (score 400), C (score 300)
- **Drops disponíveis:**
  - Sword: 2 unidades
  - Shield: 2 unidades
  - Potion: 1 unidade
- **Preferências:**
  - A: Sword (1), Shield (2)
  - B: Shield (1), Sword (2)
  - C: Potion (1), Sword (2)

### Execução:

**Rodada 1:**
- Jogador A → recebe Sword (Rodada 1: Sword = 1 restante)
- Jogador B → recebe Shield (Rodada 1: Shield = 1 restante)
- Jogador C → recebe Potion (Rodada 1: Potion = 0 restante)

**Rodada 2:**
- Jogador A → recebe Shield (Rodada 2: Shield = 0 restante)
- Jogador B → não tem Shield disponível, recebe Sword (Rodada 2: Sword = 0 restante)
- Jogador C → nenhum drop disponível (Potion acabou, Sword acabou)

**Resultado:**
- A: Sword, Shield
- B: Shield, Sword
- C: Potion
- Drops restantes: 0 ✓

## 🚀 Como Usar

### Via Interface Filament

1. Acesse **Admin → Rewards → Send Drops**
2. Visualize a tabela com todos os jogadores e suas preferências
3. Clique no botão **"Confirm Send"** (canto superior direito)
4. Confirme a distribuição no modal
5. O sistema distribuirá automaticamente todos os drops

### Via Command Line

```bash
php artisan app:distribute-drops
```

Este comando:
- Exibe cada rodada de distribuição
- Mostra quais drops foram dados a cada jogador
- Reporta o total distribuído e restante

## 📊 Monitoramento

Para verificar drops distribuídos:

```sql
-- Ver todos os drops recebidos por um jogador
SELECT p.name, d.name, COUNT(*) as count, MAX(pdr.sent_at) as last_sent
FROM player_drop_rewards pdr
JOIN players p ON p.id = pdr.player_id
JOIN drops d ON d.id = pdr.drop_id
GROUP BY p.id, d.id;

-- Ver drops não distribuídos (quantidade restante)
SELECT d.name, d.quantity - COUNT(pdr.id) as remaining
FROM drops d
LEFT JOIN player_drop_rewards pdr ON pdr.drop_id = d.id
GROUP BY d.id
HAVING remaining > 0;
```

## ⚙️ Configurações Avançadas

### Limite de Rodadas
Por padrão, o sistema executa até `count(players) + 1` rodadas para evitar loops infinitos.
Isso garante que todos os drops sejam distribuídos com segurança.

### Redistribuição Automática
Se depois de processar todas as preferências ainda houver drops:
- Sistema inicia redistribuição automática
- Drops são enviados em ordem de priority dos jogadores restantes
- Garante que nenhum drop fica sem distribuição desnecessariamente

## 🔐 Constraints e Validações

- ❌ **Removido:** Constraint única em `(player_id, drop_id)` para permitir múltiplas cópias do mesmo drop
- ✅ **Adicionado:** Rastreamento de `sent_at` para auditoria
- ✅ **Validado:** Quantidade disponível de drops antes de distribuir

## 📝 Migrações

A migration `remove_unique_constraint_from_player_drop_rewards_table` remove a constraint que impedia jogadores de receberem o mesmo drop múltiplas vezes.

Para aplicar:
```bash
php artisan migrate
```

## 🎮 Experiência do Usuário

A partir da perspectiva do jogador:
1. Define suas 10 preferências de drops (max)
2. Suas preferências são ordenadas por prioridade
3. Sistema distribui drops seguindo as preferências
4. Se preferências se esgotarem, recebe drops disponíveis
5. Pode receber múltiplas cópias do mesmo drop se necessário

## ❓ FAQ

**P: Um jogador pode receber o mesmo drop múltiplas vezes?**
R: Sim! Se houver drops restantes após a primeira distribuição, jogadores podem receber cópias adicionais.

**P: Qual é a ordem de prioridade?**
R: Os jogadores com maior reward score têm prioridade. Dentro de cada rodada, seguem a ordem de preferences.

**P: O que acontece se houver mais drops que jogadores?**
R: O sistema redistribui, começando novamente com o jogador de maior score.

**P: Posso cancelar uma distribuição em andamento?**
R: A distribuição é instantânea. Se precisar reverter, você pode deletar registros da tabela `player_drop_rewards`.

---

**Última atualização:** 17 de Fevereiro de 2026

