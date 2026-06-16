-- Sistema de Gestão de Planos de Saúde
-- Script DDL (MySQL / MariaDB) — estrutura do banco.
-- Tabelas: cliente, dependente, plano, prestador, contrato, pagamento, cobertura, usuario.

CREATE DATABASE IF NOT EXISTS gestao_planos
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE gestao_planos;

CREATE TABLE IF NOT EXISTS cliente (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  nome     VARCHAR(120) NOT NULL,
  cpf      VARCHAR(14)  NOT NULL,
  telefone VARCHAR(20),
  email    VARCHAR(120),
  endereco VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS dependente (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  nome       VARCHAR(120) NOT NULL,
  cpf        VARCHAR(14),
  parentesco VARCHAR(40),
  FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE IF NOT EXISTS plano (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  nome            VARCHAR(120) NOT NULL,
  tipo_cobertura  VARCHAR(80),
  valor            DECIMAL(10,2) NOT NULL,
  valor_dependente DECIMAL(10,2) NOT NULL DEFAULT 0,
  vigencia         VARCHAR(40),
  forma_pagamento VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS prestador (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(120) NOT NULL,
  tipo          VARCHAR(40),    -- hospital, clinica, laboratorio
  especialidade VARCHAR(80),
  localizacao   VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS contrato (
  id                   INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id           INT NOT NULL,
  plano_id             INT NOT NULL,
  data_inicio          VARCHAR(20),
  validade             VARCHAR(40),
  status               VARCHAR(20),   -- Ativo, Vencido
  renovacao_automatica TINYINT DEFAULT 0,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id),
  FOREIGN KEY (plano_id) REFERENCES plano(id)
);

CREATE TABLE IF NOT EXISTS pagamento (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  valor      DECIMAL(10,2) NOT NULL,
  vencimento VARCHAR(20),
  status     VARCHAR(20),   -- Pago, Pendente, Atrasado
  FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE IF NOT EXISTS cobertura (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  plano_id     INT NOT NULL,
  prestador_id INT NOT NULL,
  FOREIGN KEY (plano_id) REFERENCES plano(id),
  FOREIGN KEY (prestador_id) REFERENCES prestador(id)
);

-- Tabela de login (autenticação simples, sem relações com o domínio).
CREATE TABLE IF NOT EXISTS usuario (
  id    INT AUTO_INCREMENT PRIMARY KEY,
  nome  VARCHAR(120),
  email VARCHAR(120) NOT NULL,
  senha VARCHAR(120) NOT NULL
);
