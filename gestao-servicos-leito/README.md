# Refatoração e Otimização de Query Oracle (Ambiente ERP Hospitalar)

## Contexto

Durante a análise técnica de um relatório operacional utilizado em um
**ERP hospitalar baseado em Oracle Database**, foi identificado que a
consulta SQL original apresentava alguns problemas estruturais que podem
impactar desempenho, manutenção e governança de dados.

Além disso, para fins de **documentação externa e compartilhamento
técnico**, foram aplicadas práticas de **anonimização e minimização de
dados**, conforme princípios da **Lei Geral de Proteção de Dados
(LGPD)**.

### Ajustes aplicados para LGPD

-   Remoção ou generalização de possíveis **identificadores pessoais**
-   Uso de nomes **genéricos ou técnicos** para usuários e executores
-   Exclusão de qualquer dado que permita **identificação direta de
    pacientes ou profissionais**
-   Foco apenas em **estrutura técnica da query**

------------------------------------------------------------------------

## Problemas Identificados na Query Original

A análise identificou os seguintes pontos críticos:

-   Uso de **funções PL/SQL dentro do SELECT**
-   Uso de **JOIN implícito (sintaxe antiga Oracle)**
-   Aplicação de **TRUNC em coluna potencialmente indexada**
-   Dependência de **DISTINCT para eliminação de duplicidades**
-   Comparações baseadas em **strings derivadas de funções**

Esses fatores reduzem a eficiência do **Cost Based Optimizer (CBO)** do
Oracle e podem causar degradação significativa de performance em
ambientes com grande volume de dados.

### Objetivos da refatoração

-   Melhorar **legibilidade**
-   Facilitar **manutenção**
-   Permitir melhor **uso de índices**
-   Reduzir custo de execução
-   Eliminar dependência de **funções PL/SQL executadas linha-a-linha**

------------------------------------------------------------------------

# Query Original
Arquivo SQL completo:  
👉 [Query Original](./original_query.sql)


------------------------------------------------------------------------

# Principais Problemas Técnicos

## 1. Uso excessivo de funções PL/SQL

Funções executadas linha a linha:

-   `obter_nome_setor`
-   `obter_nome_pf`
-   `obter_valor_dominio`
-   `obter_descricao_padrao`

Isso gera **context switch SQL → PL/SQL**, aumentando o custo de CPU.

------------------------------------------------------------------------

## 2. JOIN implícito

Sintaxe antiga:

``` sql
FROM tabela_a, tabela_b
WHERE a.id = b.id
```

Problemas:

-   Menor legibilidade
-   Maior risco de erro de relacionamento
-   Dificulta análise do plano de execução

------------------------------------------------------------------------

## 3. TRUNC em coluna indexada

Uso:

``` sql
trunc(a.dt_prevista)
```

Isso pode impedir o uso eficiente de **índices de data**, forçando
**table full scan**.

------------------------------------------------------------------------

## 4. Uso de DISTINCT para remover duplicidade

Uso de:

``` sql
SELECT DISTINCT
```

Isso pode gerar operações como:

-   HASH UNIQUE
-   SORT UNIQUE

Impactando consumo de **CPU e memória**.

------------------------------------------------------------------------

# Query Refatorada (Versão Otimizada)
Arquivo completo da consulta:  
👉 [Query Refatorada](./refactored_query.sql)

------------------------------------------------------------------------

# Principais Melhorias

## 1. Eliminação de funções PL/SQL

Substituição por **JOIN em tabelas de domínio**.

Exemplo:

Antes:

    obter_valor_dominio(1812, a.ie_status_serv)

Depois:

    JOIN valor_dominio

------------------------------------------------------------------------

## 2. Uso de ANSI JOIN

Estrutura mais clara:

    FROM
    JOIN
    ON
    WHERE

Melhora leitura e manutenção.

------------------------------------------------------------------------

## 3. Melhor uso de índices

Substituição de:

    TRUNC(dt_prevista)

por:

    dt_prevista BETWEEN :inicio AND fim_dia(:fim)

Permitindo uso mais eficiente de índices.

------------------------------------------------------------------------

## 4. Remoção de DISTINCT

Os **relacionamentos corretos entre tabelas** eliminam duplicidade na
origem.

------------------------------------------------------------------------

## 5. Uso adequado de chaves

Comparações passam a ser feitas por **chaves numéricas**, evitando
dependência de transformações por função.

------------------------------------------------------------------------

# Resultados Observados

  Métrica                  Query Original   Query Refatorada
  ------------------------ ---------------- ------------------
  Tempo no Explain Plan    \~0.174s         \~0.335s
  Tempo real de execução   Base             \~90% menor

### Observação

O tempo exibido no plano de execução nem sempre reflete o tempo real,
pois depende de:

-   Cache de dados
-   Estatísticas do otimizador
-   Execução adaptativa
-   Chamadas de funções PL/SQL

Ao eliminar chamadas linha-a-linha e permitir melhor atuação do **CBO**,
a query refatorada apresentou redução significativa no tempo real de
execução.

------------------------------------------------------------------------

# Benefícios da Refatoração

-   Melhor **manutenibilidade**
-   Maior **legibilidade**
-   Melhor **uso de índices**
-   Menor **custo de CPU**
-   Melhor **escalabilidade** para grandes volumes de dados

------------------------------------------------------------------------

# Aplicação

Esse tipo de refatoração é especialmente relevante em ambientes:

-   **Oracle Database**
-   **ERP hospitalar**
-   **Relatórios operacionais**
-   **Dashboards e BI**
-   **Ambientes com grande volume transacional**
