class Atendimento {
  int? id;
  int? clienteId;
  int? servicoId;
  String data;
  String horario;
  String descricao;
  String clienteNome;
  String servicoNome;
  String planoNome;
  String prestadorNome;

  Atendimento({
    this.id,
    this.clienteId,
    this.servicoId,
    this.data = '',
    this.horario = '',
    this.descricao = '',
    this.clienteNome = '',
    this.servicoNome = '',
    this.planoNome = '',
    this.prestadorNome = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'cliente_id': clienteId,
    'servico_id': servicoId,
    'data': data,
    'horario': horario,
    'descricao': descricao,
  };

  static Atendimento fromMap(Map<String, dynamic> map) => Atendimento(
    id: map['id'] as int?,
    clienteId: map['cliente_id'] as int?,
    servicoId: map['servico_id'] as int?,
    data: map['data'] ?? '',
    horario: map['horario'] ?? '',
    descricao: map['descricao'] ?? '',
    clienteNome: map['cliente_nome'] ?? '',
    servicoNome: map['servico_nome'] ?? '',
    planoNome: map['plano_nome'] ?? '',
    prestadorNome: map['prestador_nome'] ?? '',
  );
}
