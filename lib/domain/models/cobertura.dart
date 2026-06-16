class Cobertura {
  int? id;
  int? planoId;
  int? prestadorId;
  String planoNome;
  String prestadorNome;

  Cobertura({
    this.id,
    this.planoId,
    this.prestadorId,
    this.planoNome = '',
    this.prestadorNome = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'plano_id': planoId,
    'prestador_id': prestadorId,
  };

  static Cobertura fromMap(Map<String, dynamic> map) => Cobertura(
    id: map['id'] as int?,
    planoId: map['plano_id'] as int?,
    prestadorId: map['prestador_id'] as int?,
    planoNome: map['plano_nome'] ?? '',
    prestadorNome: map['prestador_nome'] ?? '',
  );
}
