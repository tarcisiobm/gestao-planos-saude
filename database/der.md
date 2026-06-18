# DER — Modelo de Dados

Diagrama de Entidade e Relacionamento. Fonte versionável em Mermaid (renderiza no
GitHub). Para a entrega, exportar como PNG/PDF. Espelha `schema.sql`.

Relações:
- um **cliente** tem vários **dependentes**, **contratos** e **pagamentos**;
- um **cliente** também possui vários **atendimentos** no histórico;
- um **plano** aparece em vários **contratos**, **serviços** e **faixas de valor**;
- um **prestador** aparece em vários **serviços** (vínculo plano × prestador);
- um **serviço** aparece em vários **atendimentos**;
- **usuario**: tabela de login, sem relações com o domínio.

```mermaid
erDiagram
    CLIENTE ||--o{ DEPENDENTE : "tem"
    CLIENTE ||--o{ CONTRATO : "assina"
    CLIENTE ||--o{ PAGAMENTO : "deve"
    CLIENTE ||--o{ ATENDIMENTO : "realiza"
    PLANO ||--o{ CONTRATO : "contratado em"
    PLANO ||--o{ SERVICO : "oferece"
    PLANO ||--o{ FAIXA_VALOR : "tem"
    PRESTADOR ||--o{ SERVICO : "presta"
    SERVICO ||--o{ ATENDIMENTO : "usado em"

    CLIENTE {
        int id PK
        varchar nome
        varchar cpf
        varchar telefone
        varchar email
        varchar endereco
    }
    DEPENDENTE {
        int id PK
        int cliente_id FK
        varchar nome
        varchar cpf
        varchar parentesco
    }
    PLANO {
        int id PK
        varchar nome
        varchar tipo_cobertura
        decimal valor
        decimal valor_dependente
        varchar vigencia
        varchar forma_pagamento
    }
    PRESTADOR {
        int id PK
        varchar nome
        varchar tipo
        varchar especialidade
        varchar localizacao
    }
    CONTRATO {
        int id PK
        int cliente_id FK
        int plano_id FK
        varchar data_inicio
        varchar validade
        varchar status
        tinyint renovacao_automatica
    }
    PAGAMENTO {
        int id PK
        int cliente_id FK
        decimal valor
        varchar vencimento
        varchar status
    }
    SERVICO {
        int id PK
        int plano_id FK
        int prestador_id FK
        varchar nome
    }
    FAIXA_VALOR {
        int id PK
        int plano_id FK
        int idade_min
        int idade_max
        decimal valor
    }
    ATENDIMENTO {
        int id PK
        int cliente_id FK
        int servico_id FK
        varchar data
        varchar horario
        varchar descricao
    }
    USUARIO {
        int id PK
        varchar nome
        varchar email
        varchar senha
    }
```
