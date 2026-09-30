USE gestao_planos;

-- Migração para bancos criados pela versão antiga do aplicativo Flutter.
ALTER TABLE cliente
  ADD COLUMN IF NOT EXISTS rua VARCHAR(120),
  ADD COLUMN IF NOT EXISTS numero VARCHAR(20),
  ADD COLUMN IF NOT EXISTS complemento VARCHAR(80),
  ADD COLUMN IF NOT EXISTS bairro VARCHAR(80),
  ADD COLUMN IF NOT EXISTS cidade VARCHAR(80),
  ADD COLUMN IF NOT EXISTS estado VARCHAR(2),
  ADD COLUMN IF NOT EXISTS cep VARCHAR(9);

-- Preserva o endereço antigo como rua. Revise os registros e separe os demais campos.
UPDATE cliente SET rua = endereco WHERE (rua IS NULL OR rua = '') AND endereco IS NOT NULL;

ALTER TABLE usuario
  ADD COLUMN IF NOT EXISTS senha_hash VARCHAR(255) NULL,
  MODIFY COLUMN senha VARCHAR(120) NULL;

-- No primeiro login válido, a API gera o hash BCrypt e limpa a senha legada.
