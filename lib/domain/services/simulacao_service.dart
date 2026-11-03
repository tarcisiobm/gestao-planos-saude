import '../../data/api_client.dart';

class ValorPessoaSimulacao {
  final String descricao;
  final int idade;
  final double valor;

  const ValorPessoaSimulacao({
    required this.descricao,
    required this.idade,
    required this.valor,
  });

  factory ValorPessoaSimulacao.fromMap(Map<String, dynamic> map) {
    return ValorPessoaSimulacao(
      descricao: map['descricao'] as String,
      idade: map['idade'] as int,
      valor: (map['valor'] as num).toDouble(),
    );
  }
}

class ResultadoSimulacao {
  final double valorTotal;
  final List<ValorPessoaSimulacao> pessoas;

  const ResultadoSimulacao({required this.valorTotal, required this.pessoas});

  factory ResultadoSimulacao.fromMap(Map<String, dynamic> map) {
    final pessoas = (map['pessoas'] as List<dynamic>)
        .map((pessoa) => ValorPessoaSimulacao.fromMap(pessoa))
        .toList();
    return ResultadoSimulacao(
      valorTotal: (map['valor_total'] as num).toDouble(),
      pessoas: pessoas,
    );
  }
}

class SimulacaoService {
  Future<ResultadoSimulacao> simular({
    required int planoId,
    required int idadeTitular,
    required List<int> idadesDependentes,
  }) async {
    final dados =
        await ApiClient.instance.post('/simulacoes', {
              'plano_id': planoId,
              'idade_titular': idadeTitular,
              'idades_dependentes': idadesDependentes,
            })
            as Map<String, dynamic>;
    return ResultadoSimulacao.fromMap(dados);
  }
}
