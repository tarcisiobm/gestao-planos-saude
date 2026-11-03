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
  data_nascimento DATE,
  rua         VARCHAR(120),
  numero      VARCHAR(20),
  complemento VARCHAR(80),
  bairro      VARCHAR(80),
  cidade      VARCHAR(80),
  estado      VARCHAR(2),
  cep         VARCHAR(9)
);

CREATE TABLE IF NOT EXISTS dependente (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  nome       VARCHAR(120) NOT NULL,
  cpf        VARCHAR(14),
  parentesco VARCHAR(40),
  data_nascimento DATE,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE IF NOT EXISTS plano (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  nome            VARCHAR(120) NOT NULL,
  tipo_cobertura  VARCHAR(80),
  valor            DECIMAL(10,2) NOT NULL,
  vigencia         VARCHAR(40),
  forma_pagamento VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS prestador (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(120) NOT NULL,
  tipo          VARCHAR(40),
  especialidade VARCHAR(80),
  localizacao   VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS contrato (
  id                   INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id           INT NOT NULL,
  plano_id             INT NOT NULL,
  data_inicio          DATE NOT NULL,
  validade             DATE NOT NULL,
  status               VARCHAR(20),
  renovacao_automatica TINYINT DEFAULT 0,
  valor_mensal         DECIMAL(10,2) NOT NULL DEFAULT 0,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id),
  FOREIGN KEY (plano_id) REFERENCES plano(id)
);

CREATE TABLE IF NOT EXISTS pagamento (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  contrato_id INT NOT NULL,
  valor      DECIMAL(10,2) NOT NULL,
  vencimento DATE NOT NULL,
  status     VARCHAR(20),
  FOREIGN KEY (contrato_id) REFERENCES contrato(id)
);

CREATE TABLE IF NOT EXISTS servico (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  plano_id     INT NOT NULL,
  prestador_id INT NOT NULL,
  nome         VARCHAR(80) NOT NULL,
  FOREIGN KEY (plano_id) REFERENCES plano(id),
  FOREIGN KEY (prestador_id) REFERENCES prestador(id)
);

CREATE TABLE IF NOT EXISTS faixa_valor (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  plano_id  INT NOT NULL,
  idade_min INT NOT NULL,
  idade_max INT NOT NULL,
  valor     DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (plano_id) REFERENCES plano(id)
);

CREATE TABLE IF NOT EXISTS atendimento (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id  INT NOT NULL,
  servico_id  INT NOT NULL,
  data        DATE NOT NULL,
  horario     VARCHAR(10),
  descricao   VARCHAR(255),
  FOREIGN KEY (cliente_id) REFERENCES cliente(id),
  FOREIGN KEY (servico_id) REFERENCES servico(id)
);

CREATE TABLE IF NOT EXISTS usuario (
  id    INT AUTO_INCREMENT PRIMARY KEY,
  nome  VARCHAR(120),
  email VARCHAR(120) NOT NULL,
  senha VARCHAR(120) NULL,
  senha_hash VARCHAR(255) NOT NULL
);
