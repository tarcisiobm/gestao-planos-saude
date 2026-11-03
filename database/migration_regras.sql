USE gestao_planos;

ALTER TABLE cliente ADD COLUMN data_nascimento DATE NULL AFTER email;
ALTER TABLE dependente ADD COLUMN data_nascimento DATE NULL;

ALTER TABLE plano DROP COLUMN valor_dependente;

UPDATE contrato SET data_inicio = COALESCE(
  STR_TO_DATE(data_inicio, '%Y-%m-%d'),
  STR_TO_DATE(data_inicio, '%d/%m/%Y'),
  CURDATE());
UPDATE contrato SET validade = COALESCE(
  STR_TO_DATE(validade, '%Y-%m-%d'),
  STR_TO_DATE(validade, '%d/%m/%Y'),
  DATE_ADD(data_inicio, INTERVAL 1 YEAR));
ALTER TABLE contrato
  MODIFY data_inicio DATE NOT NULL,
  MODIFY validade DATE NOT NULL,
  ADD COLUMN valor_mensal DECIMAL(10,2) NOT NULL DEFAULT 0;

ALTER TABLE pagamento ADD COLUMN contrato_id INT NULL AFTER id;
UPDATE pagamento SET contrato_id = (
  SELECT MIN(contrato.id) FROM contrato WHERE contrato.cliente_id = pagamento.cliente_id);
DELETE FROM pagamento WHERE contrato_id IS NULL;
UPDATE pagamento SET status = 'Pendente' WHERE status = 'Atrasado';
UPDATE pagamento SET vencimento = COALESCE(
  STR_TO_DATE(vencimento, '%Y-%m-%d'),
  STR_TO_DATE(vencimento, '%d/%m/%Y'),
  CURDATE());
ALTER TABLE pagamento DROP FOREIGN KEY pagamento_ibfk_1;
ALTER TABLE pagamento
  DROP COLUMN cliente_id,
  MODIFY contrato_id INT NOT NULL,
  MODIFY vencimento DATE NOT NULL,
  ADD FOREIGN KEY (contrato_id) REFERENCES contrato(id);

UPDATE atendimento SET data = COALESCE(
  STR_TO_DATE(data, '%Y-%m-%d'),
  STR_TO_DATE(data, '%d/%m/%Y'),
  CURDATE());
ALTER TABLE atendimento MODIFY data DATE NOT NULL;

ALTER TABLE atendimento
  ADD COLUMN dependente_id INT NULL AFTER cliente_id,
  ADD FOREIGN KEY (dependente_id) REFERENCES dependente(id);
