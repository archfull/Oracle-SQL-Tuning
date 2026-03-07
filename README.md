# Oracle SQL Tuning (Ambiente Oracle / ERP Hospitalar)

Repositório dedicado ao estudo, documentação e aplicação prática de **tuning de queries Oracle**, com foco em cenários reais de banco de dados utilizados em **ambientes corporativos e hospitalares**.

O objetivo é registrar **casos reais de otimização**, incluindo:

- Refatoração de queries legadas
- Melhoria de performance
- Boas práticas de SQL
- Redução de chamadas desnecessárias a funções
- Uso adequado de `JOIN`, `CTE`, `INDEX`, e filtros
- Reestruturação de lógica SQL complexa
- Padronização de código para manutenção

Cada pasta dentro do repositório representa **um caso técnico documentado**.

---

# Estrutura do Repositório


Oracle-SQL-Tuning   
|   
|-- README.md   
|   
|-- gestao-servicos-leito   
|----|  README.md   
|----|  original_query.sql   
|----|  refactored_query.sql   
|   
|-- futuros-casos...   


### Descrição dos Arquivos

**README.md (raiz)**  
Apresenta a visão geral do repositório e organização dos estudos.

**Pastas de Caso Técnico**  
Cada diretório representa um **estudo de tuning aplicado a uma query específica**.

Dentro de cada pasta existem três artefatos principais:

| Arquivo | Descrição |
|------|------|
| `README.md` | Explicação técnica do problema, análise e melhorias aplicadas |
| `original_query.sql` | Query original encontrada no ambiente |
| `refactored_query.sql` | Versão otimizada da query |

---

# Metodologia de Tuning

Cada caso documentado segue uma abordagem estruturada:

1. **Identificação do problema**
   - Query lenta
   - Uso excessivo de funções
   - Joins implícitos
   - Falta de filtros eficientes

2. **Análise da estrutura**
   - Avaliação da legibilidade
   - Dependência de funções PL/SQL
   - Estrutura de joins
   - Repetição de lógica

3. **Refatoração**
   - Conversão para `JOIN` explícito
   - Remoção de lógica redundante
   - Uso de `WITH (CTE)` quando necessário
   - Simplificação da estrutura

4. **Resultado**
   - Query mais legível
   - Melhor manutenibilidade
   - Potencial ganho de performance

---

# Boas Práticas Utilizadas

Algumas práticas aplicadas durante as refatorações:

- Preferência por **JOIN explícito**
- Uso consistente de **aliases descritivos**
- Evitar **funções em colunas filtradas**
- Separação de lógica complexa em **CTE**
- Redução de **subqueries desnecessárias**
- Padronização de identação SQL

---

# Anonimização e LGPD

Os exemplos documentados seguem boas práticas de **anonimização de dados**, evitando exposição de:

- dados pessoais
- identificadores sensíveis
- informações clínicas
- dados institucionais críticos

Os scripts representam **estruturas técnicas**, não dados reais.

---

# Objetivo do Repositório

Este repositório funciona como:

- **Portfólio técnico**
- **Base de conhecimento de tuning Oracle**
- **Registro de estudos práticos**
- **Material de consulta para otimização de SQL**

---

# Tecnologias Envolvidas

- Oracle Database
- SQL
- PL/SQL
- ERP hospitalar

---

# Exemplos de Casos Documentados

###  [Gestão de Serviços de Leito](gestao-servicos-leito/)

Refatoração de query utilizada para monitoramento operacional de serviços hospitalares, com foco em:

- melhoria de legibilidade
- redução de complexidade
- organização estrutural da consulta

---

# Evolução do Repositório

Novos casos serão adicionados conforme surgirem oportunidades de:

- refatoração
- tuning
- análise de queries complexas
- investigação de performance

---

