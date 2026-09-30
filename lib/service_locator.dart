import 'data/api_repositories.dart';

class ServiceLocator {
  ServiceLocator._interno();
  static final ServiceLocator instance = ServiceLocator._interno();

  static const String clienteRepository = 'cliente';
  static const String planoRepository = 'plano';
  static const String prestadorRepository = 'prestador';
  static const String dependenteRepository = 'dependente';
  static const String contratoRepository = 'contrato';
  static const String pagamentoRepository = 'pagamento';
  static const String servicoRepository = 'servico';
  static const String faixaValorRepository = 'faixa_valor';
  static const String atendimentoRepository = 'atendimento';
  static const String usuarioRepository = 'usuario';

  final Map<String, dynamic> _repositorios = {};

  void setup() {
    _repositorios[clienteRepository] = ClienteRepositoryApi();
    _repositorios[planoRepository] = PlanoRepositoryApi();
    _repositorios[prestadorRepository] = PrestadorRepositoryApi();
    _repositorios[dependenteRepository] = DependenteRepositoryApi();
    _repositorios[contratoRepository] = ContratoRepositoryApi();
    _repositorios[pagamentoRepository] = PagamentoRepositoryApi();
    _repositorios[servicoRepository] = ServicoRepositoryApi();
    _repositorios[faixaValorRepository] = FaixaValorRepositoryApi();
    _repositorios[atendimentoRepository] = AtendimentoRepositoryApi();
    _repositorios[usuarioRepository] = UsuarioRepositoryApi();
  }

  dynamic findRepository(String nomeRepositorio) {
    if (_repositorios.containsKey(nomeRepositorio)) {
      return _repositorios[nomeRepositorio];
    }
    throw Exception('Repositório não encontrado: $nomeRepositorio');
  }
}
