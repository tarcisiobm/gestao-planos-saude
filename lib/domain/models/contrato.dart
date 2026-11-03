import '../constants/status.dart';

class Contrato {
  int? id;
  int? clienteId;
  int? planoId;
  String dataInicio;
  String validade;
  String status;
  bool renovacaoAutomatica;
  double valorMensal;
  String clienteNome;
  String planoNome;

  Contrato({
    this.id,
    this.clienteId,
    this.planoId,
    this.dataInicio = '',
    this.validade = '',
    this.status = StatusContrato.ativo,
    this.renovacaoAutomatica = false,
    this.valorMensal = 0,
    this.clienteNome = '',
    this.planoNome = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'cliente_id': clienteId,
    'plano_id': planoId,
    'data_inicio': dataInicio,
    'validade': validade,
    'status': status,
    'renovacao_automatica': renovacaoAutomatica,
  };

  static Contrato fromMap(Map<String, dynamic> map) {
    final renovacao = map['renovacao_automatica'];
    return Contrato(
      id: map['id'] as int?,
      clienteId: map['cliente_id'] as int?,
      planoId: map['plano_id'] as int?,
      dataInicio: map['data_inicio'] ?? '',
      validade: map['validade'] ?? '',
      status: map['status'] ?? StatusContrato.ativo,
      renovacaoAutomatica:
          renovacao == true || renovacao == 1 || renovacao == '1',
      valorMensal: (map['valor_mensal'] as num? ?? 0).toDouble(),
      clienteNome: map['cliente_nome'] ?? '',
      planoNome: map['plano_nome'] ?? '',
    );
  }
}
