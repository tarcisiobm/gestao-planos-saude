# Documento de Requisitos — Sistema de Gestão de Planos de Saúde

> **Instituição:** Instituto Federal de Educação, Ciência e Tecnologia do Sudeste
> de Minas Gerais — Campus Muriaé
> **Curso:** Gestão da Tecnologia da Informação
> **Disciplina:** Dispositivos Móveis
> **Grupo:** Gabriel Castro, Mayara Aquiles, Pedro Fortini e Tarcísio Barroso
> **Local/Ano:** Muriaé-MG, 2026

Transcrição fiel e organizada do arquivo original `requisitos.txt` (a parte escrita
produzida pelo grupo).

## Sumário

1. [Introdução](#1-introdução)
   - [1.1 Público Alvo](#11-público-alvo)
2. [Descrição Geral do Produto](#2-descrição-geral-do-produto)
   - [2.1 Descrição Geral do Cliente](#21-descrição-geral-do-cliente)
   - [2.2 Descrição Geral do Produto](#22-descrição-geral-do-produto)
     - [2.2.1 Situação Atual da Empresa](#221-situação-atual-da-empresa)
     - [2.2.2 Escopo do Produto — Módulos e Funcionalidades](#222-escopo-do-produto--módulos-e-funcionalidades)
   - [2.3 Premissas](#23-premissas)
3. [Requisitos](#3-requisitos)
   - [3.1 Requisitos Funcionais (RF)](#31-requisitos-funcionais-rf)
   - [3.2 Requisitos Não Funcionais (RNF)](#32-requisitos-não-funcionais-rnf)
   - [3.3 Regras de Negócio (RN)](#33-regras-de-negócio-rn)

---

## 1. Introdução

Este documento detalha o **Sistema de Gestão de Planos de Saúde**, uma solução
desenvolvida para automatizar o ciclo de vida de contratos de saúde. O sistema
centraliza desde o cadastro de beneficiários e dependentes até a gestão de redes
credenciadas (hospitais/clínicas), controle de vendas, emissão de contratos e
gestão financeira de mensalidades.

Nas próximas seções estão a Descrição Geral do Produto, as Premissas do projeto, os
Requisitos Funcionais (RF) e Não Funcionais (RNF), as Regras de Negócio (RN) e, por
fim, o Plano de Liberações (cronograma de desenvolvimento e entregas).

### 1.1 Público Alvo

O sistema é destinado a **operadoras de planos de saúde de pequeno e médio porte** e
**corretoras de seguros** que necessitam de controle rigoroso sobre sua carteira de
clientes:

- **Gestores Administrativos:** controle de receitas, inadimplência e análise de
  sinistros.
- **Vendedores:** realização de simulações e fechamento de novos contratos.
- **Equipe de Atendimento:** consulta de rede credenciada e atualização de dados de
  clientes.
- **Clientes (Beneficiários):** uso da interface móvel para consultar coberturas e
  status de pagamento.

---

## 2. Descrição Geral do Produto

### 2.1 Descrição Geral do Cliente

Identificou-se que o cliente (operadora) possui processos fragmentados, muitas vezes
dependentes de planilhas para o controle de vigência de contratos e rede de
prestadores. Há uma necessidade crítica de centralizar essas informações para evitar
atendimentos indevidos (planos vencidos) e melhorar a cobrança de mensalidades. O
cliente busca uma solução móvel que permita agilidade na ponta da venda (simulações
em tempo real) e segurança na gestão dos dados.

Principais necessidades:

- **Registro de Clientes:** cadastro rápido de titulares e dependentes com dados
  essenciais.
- **Consulta de Médicos/Hospitais:** busca simples por prestadores e o que cada um
  cobre.
- **Venda e Contratos:** realizar simulações de preços e gerar contratos digitais na
  hora.
- **Controle de Pagamentos:** sistema que avisa quem pagou e quem está atrasado.
- **Segurança:** garantir que os dados dos pacientes estejam protegidos.

### 2.2 Descrição Geral do Produto

O sistema é uma ferramenta de gestão que organiza a venda de planos, o cadastro de
beneficiários e a rede de atendimento (clínicas e hospitais). Ele centraliza o
financeiro e os contratos em um só lugar.

Problemas que motivam o produto:

- **Processo Manual:** pedidos e contratos feitos no papel, causando perda de
  informações.
- **Dificuldade Financeira:** não há um relatório claro de quem está inadimplente.
- **Rede Desatualizada:** o cliente não sabe dizer com rapidez quais hospitais
  atendem cada plano.

#### 2.2.1 Situação Atual da Empresa

A empresa enfrenta desafios significativos em seu processo de gestão de planos de
saúde e rede credenciada devido à ausência de um sistema dedicado. Abaixo estão os
principais pontos que caracterizam a situação atual:

**Processo Manual**

- **Controle de Contratos:** realizado via pastas físicas ou Excel, dificultando a
  renovação automática.
- **Comunicação com Prestadores:** sem integração clara de quais hospitais atendem
  quais planos, gerando glosas e erros de atendimento.
- **Gestão Financeira:** dificuldade em identificar rapidamente clientes
  inadimplentes antes da autorização de procedimentos.
- **Gestão de Dados:** informações de clientes, dependentes e médicos espalhadas e
  desorganizadas, dificultando a busca de históricos e a segurança das informações
  sensíveis.

**Falta de Acompanhamento de Solicitações**

- Não existe uma plataforma para ver o status de liberação de exames em tempo real.
- O cliente não consegue saber rapidamente se um procedimento foi autorizado ou não.

**Gestão de Planos e Tabelas Manual**

- O controle de valores das mensalidades e coberturas é feito em planilhas simples.
- Dificuldade em prever custos e gerenciar o reajuste anual de planos.

**Comunicação Limitada com o Beneficiário**

- O contato é feito apenas por telefone ou presencial, sem canal digital.
- O cliente não tem onde consultar a lista de médicos e hospitais atualizada.

**Relatórios e Análises Manuais**

- Dificuldade em gerar relatórios de vendas e comissões de corretores.
- A empresa não consegue identificar rápido quais clientes estão cancelando os
  planos.

**Dificuldade em Implementar Promoções**

- O sistema atual não permite criar descontos familiares de forma rápida.
- Perda de novos clientes pela demora em enviar propostas personalizadas.

**Dados Desatualizados**

- Informações sobre médicos que saíram da rede demoram a ser atualizadas para o
  cliente.
- Falta de integração entre o cadastro do cliente e a liberação de consultas.

#### 2.2.2 Escopo do Produto — Módulos e Funcionalidades

Este escopo abrange o **aplicativo móvel** para o cliente, a **API de comunicação** e
o **painel administrativo** de gestão. O sistema visa facilitar a venda de planos, o
controle de contratos e a consulta à rede credenciada (hospitais e clínicas) através
de uma interface intuitiva.

**Aplicativo de Pedidos Web para Clientes**

O aplicativo será desenvolvido para que clientes consultem sua rede médica e
corretores realizem vendas. Oferecerá funcionalidades como **login seguro, criação
de perfis, busca de hospitais por especialidade, simulação de valores de planos e
acompanhamento de pagamentos**.

### 2.3 Premissas

- **Hospedagem em Nuvem:** o sistema será hospedado em uma plataforma de nuvem,
  garantindo acesso remoto aos dados de planos e clientes.
- **Conectividade à Internet:** indispensável que operadora, corretores e clientes
  tenham acesso à internet para validar coberturas e contratos em tempo real.
- **Dispositivos Móveis:** o sistema será focado em dispositivos móveis (smartphones
  e tablets), facilitando o uso por corretores em vendas externas e por clientes na
  consulta de rede médica.
- **Persistência de Dados:** o armazenamento será feito obrigatoriamente em banco de
  dados **MySQL ou MariaDB**, conforme exigência técnica do projeto.
- **Backup Automatizado:** cópias de segurança diárias dos dados de contratos e
  pagamentos para evitar a perda de informações sensíveis.
- **Treinamento da Equipe:** os funcionários passarão por treinamento para gerenciar
  a rede credenciada e os contratos. Para o cliente final, a interface será
  intuitiva.
- **Segurança da Informação:** o sistema seguirá padrões de segurança para proteger
  dados pessoais (CPF, histórico de saúde) contra acessos não autorizados.
- **Suporte Técnico:** haverá um canal de suporte para problemas operacionais
  relacionados ao cadastro de prestadores e liberação de planos.

---

## 3. Requisitos

### 3.1 Requisitos Funcionais (RF)

| ID | Requisito | Descrição |
|----|-----------|-----------|
| **RF01** | Cadastro de Clientes | Registrar nome, endereço, telefone, e-mail, CPF e dependentes. |
| **RF02** | Cadastro de Planos | Registrar tipos de planos com cobertura, valor, vigência e pagamento. |
| **RF03** | Vendas e Contratos | Registrar vendas e emitir contratos com prazos e termos. |
| **RF04** | Simulação de Propostas | Gerar propostas e simular valores baseados no perfil do cliente. |
| **RF05** | Gestão de Pagamentos | Registrar e controlar o status de pagamentos (pago, pendente, atrasado). |
| **RF06** | Cadastro de Prestadores | Registrar hospitais, clínicas e laboratórios (especialidades e localização). |
| **RF07** | Vínculo Rede/Plano | Associar prestadores aos planos de saúde e suas coberturas. |
| **RF08** | Relatórios Financeiros | Gerar relatórios de receitas, inadimplência e comissões. |
| **RF09** | Relatórios de Desempenho | Gerar dados sobre clientes ativos, sinistros e taxas de renovação. |

### 3.2 Requisitos Não Funcionais (RNF)

> Observação: a numeração no documento original começa em **RNF02** (não há RNF01).
> Mantida fielmente; o grupo pode ajustar depois.

| ID | Requisito | Descrição |
|----|-----------|-----------|
| **RNF02** | Plataforma | O software deve ser desenvolvido para Dispositivos Móveis (Mobile). |
| **RNF03** | Persistência | Os dados de histórico de atendimento e contratos devem ser armazenados de forma íntegra. |
| **RNF04** | Padronização | O sistema deverá ser padronizado. |

### 3.3 Regras de Negócio (RN)

| ID | Regra | Descrição |
|----|-------|-----------|
| **RN01** | Renovação de Contrato | O sistema deve prever a possibilidade de renovação automática dos contratos. |
| **RN02** | Cálculo de Proposta | As simulações de valores devem ser calculadas automaticamente com base no perfil do cliente. |
| **RN03** | Vínculo de Dependente | Cada dependente cadastrado deve obrigatoriamente estar associado a um cliente titular. |
| **RN04** | Cobertura por Prestador | Um atendimento só pode ser realizado se o prestador possuir associação ativa com o plano do cliente e oferecer a cobertura necessária. |
| **RN05** | Status de Pagamento | O sistema deve atualizar o status financeiro conforme o prazo de validade do contrato e o recebimento das parcelas. |

---

## 4. Plano de Liberação

> O sumário do documento original previa a seção **"4. Plano de Liberação"**, mas o
> conteúdo ainda **não foi redigido** no `requisitos.txt`. Usar como molde o plano de
> releases/iterações do projeto exemplo
> ([`reference/flutter_controle_enderecos/README.md`](../reference/flutter_controle_enderecos/README.md)),
> que organiza o desenvolvimento em iterações com datas, objetivos e atividades —
> exatamente o que o enunciado pede para o versionamento por branches.
