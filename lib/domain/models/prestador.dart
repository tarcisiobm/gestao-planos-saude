class Prestador {
  int? id;
  String nome;
  String tipo;
  String especialidade;
  String localizacao;

  Prestador({
    this.id,
    this.nome = '',
    this.tipo = '',
    this.especialidade = '',
    this.localizacao = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'tipo': tipo,
    'especialidade': especialidade,
    'localizacao': localizacao,
  };

  static Prestador fromMap(Map<String, dynamic> map) => Prestador(
    id: map['id'] as int?,
    nome: map['nome'] ?? '',
    tipo: map['tipo'] ?? '',
    especialidade: map['especialidade'] ?? '',
    localizacao: map['localizacao'] ?? '',
  );
}
