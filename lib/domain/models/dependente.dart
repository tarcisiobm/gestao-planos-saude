class Dependente {
  int? id;
  int? clienteId;
  String nome;
  String cpf;
  String parentesco;
  String clienteNome;

  Dependente({
    this.id,
    this.clienteId,
    this.nome = '',
    this.cpf = '',
    this.parentesco = '',
    this.clienteNome = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'cliente_id': clienteId,
    'nome': nome,
    'cpf': cpf,
    'parentesco': parentesco,
  };

  static Dependente fromMap(Map<String, dynamic> map) => Dependente(
    id: map['id'] as int?,
    clienteId: map['cliente_id'] as int?,
    nome: map['nome'] ?? '',
    cpf: map['cpf'] ?? '',
    parentesco: map['parentesco'] ?? '',
    clienteNome: map['cliente_nome'] ?? '',
  );
}
