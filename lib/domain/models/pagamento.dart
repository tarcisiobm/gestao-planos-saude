import '../constants/status.dart';

class Pagamento {
  int? id;
  int? clienteId;
  double valor;
  String vencimento;
  String status;
  String clienteNome;

  Pagamento({
    this.id,
    this.clienteId,
    this.valor = 0,
    this.vencimento = '',
    this.status = StatusPagamento.pendente,
    this.clienteNome = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'cliente_id': clienteId,
    'valor': valor,
    'vencimento': vencimento,
    'status': status,
  };

  static Pagamento fromMap(Map<String, dynamic> map) => Pagamento(
    id: map['id'] as int?,
    clienteId: map['cliente_id'] as int?,
    valor: _toDouble(map['valor']),
    vencimento: map['vencimento'] ?? '',
    status: map['status'] ?? StatusPagamento.pendente,
    clienteNome: map['cliente_nome'] ?? '',
  );

  static double _toDouble(Object? value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
