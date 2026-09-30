import '../../data/api_client.dart';

class ResultadoSimulacao {
  final double valorTotal;
  final double valorFaixa;
  final double valorDependente;

  const ResultadoSimulacao({
    required this.valorTotal,
    required this.valorFaixa,
    required this.valorDependente,
  });

  factory ResultadoSimulacao.fromMap(Map<String, dynamic> map) {
    return ResultadoSimulacao(
      valorTotal: (map['valor_total'] as num).toDouble(),
      valorFaixa: (map['valor_faixa'] as num).toDouble(),
      valorDependente: (map['valor_dependente'] as num).toDouble(),
    );
  }
}

class SimulacaoService {
  Future<ResultadoSimulacao> simular({
    required int planoId,
    required int idade,
    required int quantidadeDependentes,
  }) async {
    final dados =
        await ApiClient.instance.post('/simulacoes', {
              'plano_id': planoId,
              'idade': idade,
              'quantidade_dependentes': quantidadeDependentes,
            })
            as Map<String, dynamic>;
    return ResultadoSimulacao.fromMap(dados);
  }
}
