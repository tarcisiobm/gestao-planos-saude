import 'data/atendimento_repository_mysql.dart';
import 'data/cliente_repository_mysql.dart';
import 'data/contrato_repository_mysql.dart';
import 'data/dependente_repository_mysql.dart';
import 'data/faixa_valor_repository_mysql.dart';
import 'data/pagamento_repository_mysql.dart';
import 'data/plano_repository_mysql.dart';
import 'data/prestador_repository_mysql.dart';
import 'data/servico_repository_mysql.dart';
import 'data/usuario_repository_mysql.dart';

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
    _repositorios[clienteRepository] = ClienteRepositoryMysql();
    _repositorios[planoRepository] = PlanoRepositoryMysql();
    _repositorios[prestadorRepository] = PrestadorRepositoryMysql();
    _repositorios[dependenteRepository] = DependenteRepositoryMysql();
    _repositorios[contratoRepository] = ContratoRepositoryMysql();
    _repositorios[pagamentoRepository] = PagamentoRepositoryMysql();
    _repositorios[servicoRepository] = ServicoRepositoryMysql();
    _repositorios[faixaValorRepository] = FaixaValorRepositoryMysql();
    _repositorios[atendimentoRepository] = AtendimentoRepositoryMysql();
    _repositorios[usuarioRepository] = UsuarioRepositoryMysql();
  }

  dynamic findRepository(String nomeRepositorio) {
    if (_repositorios.containsKey(nomeRepositorio)) {
      return _repositorios[nomeRepositorio];
    }
    throw Exception('Repositório não encontrado: $nomeRepositorio');
  }
}
