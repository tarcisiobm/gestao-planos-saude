import '../constants/status.dart';

class Pagamento {
  int? id;
  int? contratoId;
  double valor;
  String vencimento;
  String status;
  int diasAtraso;
  String clienteNome;
  String planoNome;

  Pagamento({
    this.id,
    this.contratoId,
    this.valor = 0,
    this.vencimento = '',
    this.status = StatusPagamento.pendente,
    this.diasAtraso = 0,
    this.clienteNome = '',
    this.planoNome = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'contrato_id': contratoId,
    'valor': valor,
    'vencimento': vencimento,
    'status': status,
  };

  static Pagamento fromMap(Map<String, dynamic> map) => Pagamento(
    id: map['id'] as int?,
    contratoId: map['contrato_id'] as int?,
    valor: _toDouble(map['valor']),
    vencimento: map['vencimento'] ?? '',
    status: map['status'] ?? StatusPagamento.pendente,
    diasAtraso: map['dias_atraso'] as int? ?? 0,
    clienteNome: map['cliente_nome'] ?? '',
    planoNome: map['plano_nome'] ?? '',
  );

  static double _toDouble(Object? value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
