# DER — Modelo de Dados

Diagrama de Entidade e Relacionamento. Fonte versionável em Mermaid (renderiza no
GitHub). Para a entrega, exportar como PNG/PDF. Espelha `schema.sql`.

Relações:
- um **cliente** tem vários **dependentes**, **contratos** e **pagamentos**;
- um **plano** aparece em vários **contratos** e em várias **coberturas**;
- um **prestador** aparece em várias **coberturas** (vínculo plano × prestador);
- **usuario**: tabela de login, sem relações com o domínio.

```mermaid
erDiagram
    CLIENTE ||--o{ DEPENDENTE : "tem"
    CLIENTE ||--o{ CONTRATO : "assina"
    CLIENTE ||--o{ PAGAMENTO : "deve"
    PLANO ||--o{ CONTRATO : "contratado em"
    PLANO ||--o{ COBERTURA : "coberto por"
    PRESTADOR ||--o{ COBERTURA : "atende em"

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
    COBERTURA {
        int id PK
        int plano_id FK
        int prestador_id FK
    }
    USUARIO {
        int id PK
        varchar nome
        varchar email
        varchar senha
    }
```
