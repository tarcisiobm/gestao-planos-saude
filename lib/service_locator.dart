import 'data/cliente_repository_mysql.dart';
import 'data/cobertura_repository_mysql.dart';
import 'data/contrato_repository_mysql.dart';
import 'data/dependente_repository_mysql.dart';
import 'data/pagamento_repository_mysql.dart';
import 'data/plano_repository_mysql.dart';
import 'data/prestador_repository_mysql.dart';
import 'data/relatorio_repository_mysql.dart';
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
  static const String coberturaRepository = 'cobertura';
  static const String relatorioRepository = 'relatorio';
  static const String usuarioRepository = 'usuario';

  final Map<String, dynamic> _repositorios = {};

  void setup() {
    _repositorios[clienteRepository] = ClienteRepositoryMysql();
    _repositorios[planoRepository] = PlanoRepositoryMysql();
    _repositorios[prestadorRepository] = PrestadorRepositoryMysql();
    _repositorios[dependenteRepository] = DependenteRepositoryMysql();
    _repositorios[contratoRepository] = ContratoRepositoryMysql();
    _repositorios[pagamentoRepository] = PagamentoRepositoryMysql();
    _repositorios[coberturaRepository] = CoberturaRepositoryMysql();
    _repositorios[relatorioRepository] = RelatorioRepositoryMysql();
    _repositorios[usuarioRepository] = UsuarioRepositoryMysql();
  }

  dynamic findRepository(String nomeRepositorio) {
    if (_repositorios.containsKey(nomeRepositorio)) {
      return _repositorios[nomeRepositorio];
    }
    throw Exception('Repositório não encontrado: $nomeRepositorio');
  }
}
