class FaixaValor {
  int? id;
  int? planoId;
  int idadeMin;
  int idadeMax;
  double valor;

  FaixaValor({
    this.id,
    this.planoId,
    this.idadeMin = 0,
    this.idadeMax = 0,
    this.valor = 0,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'plano_id': planoId,
    'idade_min': idadeMin,
    'idade_max': idadeMax,
    'valor': valor,
  };

  static FaixaValor fromMap(Map<String, dynamic> map) => FaixaValor(
    id: map['id'] as int?,
    planoId: map['plano_id'] as int?,
    idadeMin: _paraInt(map['idade_min']),
    idadeMax: _paraInt(map['idade_max']),
    valor: _paraDouble(map['valor']),
  );

  static int _paraInt(Object? valor) {
    if (valor is int) return valor;
    if (valor is num) return valor.toInt();
    return int.tryParse('${valor ?? ''}') ?? 0;
  }

  static double _paraDouble(Object? valor) {
    if (valor == null) return 0;
    if (valor is double) return valor;
    if (valor is num) return valor.toDouble();
    return double.tryParse(valor.toString()) ?? 0;
  }
}
