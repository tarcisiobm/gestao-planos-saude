class Plano {
  int? id;
  String nome;
  String tipoCobertura;
  double valor;
  double valorDependente;
  String vigencia;
  String formaPagamento;

  Plano({
    this.id,
    this.nome = '',
    this.tipoCobertura = '',
    this.valor = 0,
    this.valorDependente = 0,
    this.vigencia = '',
    this.formaPagamento = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'tipo_cobertura': tipoCobertura,
    'valor': valor,
    'valor_dependente': valorDependente,
    'vigencia': vigencia,
    'forma_pagamento': formaPagamento,
  };

  static Plano fromMap(Map<String, dynamic> map) => Plano(
    id: map['id'] as int?,
    nome: map['nome'] ?? '',
    tipoCobertura: map['tipo_cobertura'] ?? '',
    valor: _toDouble(map['valor']),
    valorDependente: _toDouble(map['valor_dependente']),
    vigencia: map['vigencia'] ?? '',
    formaPagamento: map['forma_pagamento'] ?? '',
  );

  static double _toDouble(Object? value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
