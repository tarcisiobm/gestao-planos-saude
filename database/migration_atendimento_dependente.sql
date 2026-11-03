USE gestao_planos;

ALTER TABLE atendimento
  ADD COLUMN dependente_id INT NULL AFTER cliente_id,
  ADD FOREIGN KEY (dependente_id) REFERENCES dependente(id);
