class Servico {
  int? id;
  int? planoId;
  int? prestadorId;
  String nome;
  String planoNome;
  String prestadorNome;

  Servico({
    this.id,
    this.planoId,
    this.prestadorId,
    this.nome = '',
    this.planoNome = '',
    this.prestadorNome = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'plano_id': planoId,
    'prestador_id': prestadorId,
    'nome': nome,
  };

  static Servico fromMap(Map<String, dynamic> map) => Servico(
    id: map['id'] as int?,
    planoId: map['plano_id'] as int?,
    prestadorId: map['prestador_id'] as int?,
    nome: map['nome'] ?? '',
    planoNome: map['plano_nome'] ?? '',
    prestadorNome: map['prestador_nome'] ?? '',
  );
}
