# Otimização de Performance SQL – Oracle

## 1. Visão Geral

Este documento descreve a refatoração de uma query responsável por extrair informações de altas hospitalares.

Comparação de performance considerando um período de **2 meses**:

Tempo de execução da query original:
~8 segundos

Tempo de execução da query refatorada:
~1,7 segundos

Ganho de performance:
~78% mais rápida.

A otimização teve como foco melhorar a arquitetura da consulta, reduzir operações redundantes e permitir que o otimizador do Oracle gere um plano de execução mais eficiente.

## Queries

- [Query original](./original_query.sql)
- [Query refatorada](./refactored_query.sql)

---

## 2. Problemas na Query Original

A consulta original apresentava alguns gargalos importantes de performance.

### Uso de View Complexa

A query utilizava:

atendimento_paciente_v

Essa view encapsula múltiplos joins e lógica interna, aumentando o custo de execução e a complexidade do plano.

### DISTINCT + GROUP BY

Ambas as operações eram executadas simultaneamente:

SELECT DISTINCT
GROUP BY

Isso força operações adicionais de ordenação:

SORT GROUP BY
SORT UNIQUE

### Subqueries Correlacionadas

Subconsultas utilizando MAX() eram executadas repetidamente para identificar a última unidade do paciente, gerando múltiplos acessos a índice.

### Função PL/SQL no SELECT

A função:

obter_nome_pf()

introduzia troca de contexto entre SQL e PL/SQL (SQL → PL/SQL context switch), dificultando otimizações pelo Oracle.

---

## 3. Estratégia de Refatoração

A nova query foi estruturada de forma modular utilizando **Common Table Expressions (CTEs)**.

Principais melhorias aplicadas:

• Remoção da dependência da view complexa  
• Substituição de subqueries correlacionadas por funções analíticas  
• Substituição de funções PL/SQL por joins diretos  
• Redução de operações de ordenação desnecessárias

Estrutura lógica da consulta:

base_atendimento   → filtra atendimentos relevantes  
ultima_unidade     → identifica a última unidade do atendimento  
alta_enfermagem    → agrega informações da alta de enfermagem

Essa abordagem reduz o volume de dados logo no início e simplifica os joins posteriores.

---

## 4. Melhorias no Plano de Execução

Características do plano da query original:

• Múltiplos NESTED LOOPS  
• SORT GROUP BY  
• SORT UNIQUE  
• Repetidos acessos a índice

Plan Hash:

3692542349

Características do plano da query refatorada:

• Operações HASH JOIN  
• WINDOW SORT (função analítica)  
• TEMP TABLE TRANSFORMATION

Plan Hash:

2293819784

Essas mudanças permitem que o Oracle processe conjuntos maiores de dados de forma mais eficiente, reduzindo a dependência de nested loops.

---

## 5. Resultados

| Cenário | Tempo de Execução |
|--------|------------------|
| Query original | ~8 segundos |
| Query refatorada | ~1.7 segundos |

Melhoria de performance:

~78% mais rápida.

Benefícios adicionais:

• Melhor legibilidade da query  
• Facilidade de manutenção  
• Maior escalabilidade para períodos maiores e volumes maiores de dados

---

Conclusão:

A refatoração eliminou gargalos críticos da arquitetura da query original e permitiu que o otimizador do Oracle gerasse um plano de execução significativamente mais eficiente.
