import '../domain/models/atendimento.dart';
import '../domain/models/cliente.dart';
import '../domain/models/contrato.dart';
import '../domain/models/dependente.dart';
import '../domain/models/faixa_valor.dart';
import '../domain/models/pagamento.dart';
import '../domain/models/plano.dart';
import '../domain/models/prestador.dart';
import '../domain/models/servico.dart';
import '../domain/models/usuario.dart';
import '../domain/repository/atendimento_repository.dart';
import '../domain/repository/cliente_repository.dart';
import '../domain/repository/contrato_repository.dart';
import '../domain/repository/dependente_repository.dart';
import '../domain/repository/faixa_valor_repository.dart';
import '../domain/repository/pagamento_repository.dart';
import '../domain/repository/plano_repository.dart';
import '../domain/repository/prestador_repository.dart';
import '../domain/repository/servico_repository.dart';
import '../domain/repository/usuario_repository.dart';
import 'api_client.dart';

typedef MapParaEntidade<T> = T Function(Map<String, dynamic> map);
typedef EntidadeParaMap<T> = Map<String, dynamic> Function(T entidade);
typedef ObterId<T> = int? Function(T entidade);

class ApiCrudRepository<T> {
  final String path;
  final MapParaEntidade<T> criarEntidade;
  final EntidadeParaMap<T> criarMap;
  final ObterId<T> obterId;
  final _api = ApiClient.instance;

  ApiCrudRepository(this.path, this.criarEntidade, this.criarMap, this.obterId);

  Future<List<T>> listar([String? busca]) async {
    Map<String, String>? query;
    if (busca != null && busca.isNotEmpty) {
      query = {'busca': busca};
    }

    final dados = await _api.get(path, query: query) as List<dynamic>;
    return dados
        .map((item) => criarEntidade(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvar(T entidade) async {
    final id = obterId(entidade);
    final corpo = criarMap(entidade);
    corpo.remove('id');

    if (id == null) {
      await _api.post(path, corpo);
      return;
    }

    await _api.put('$path/$id', corpo);
  }

  Future<void> excluir(int id) async {
    await _api.delete('$path/$id');
  }
}

class ClienteRepositoryApi implements IClienteRepository {
  final _repository = ApiCrudRepository(
    '/clientes',
    Cliente.fromMap,
    (cliente) => cliente.toMap(),
    (cliente) => cliente.id,
  );

  @override
  Future<List<Cliente>> findAll() => _repository.listar();

  @override
  Future<List<Cliente>> buscar(String texto) => _repository.listar(texto);

  @override
  Future<void> salvar(Cliente cliente) => _repository.salvar(cliente);

  @override
  Future<void> excluir(int id) => _repository.excluir(id);
}

class PlanoRepositoryApi implements IPlanoRepository {
  final _repository = ApiCrudRepository(
    '/planos',
    Plano.fromMap,
    (plano) => plano.toMap(),
    (plano) => plano.id,
  );
  @override
  Future<List<Plano>> findAll() => _repository.listar();

  @override
  Future<List<Plano>> buscar(String texto) => _repository.listar(texto);

  @override
  Future<void> salvar(Plano plano) => _repository.salvar(plano);

  @override
  Future<void> excluir(int id) => _repository.excluir(id);
}

class PrestadorRepositoryApi implements IPrestadorRepository {
  final _repository = ApiCrudRepository(
    '/prestadores',
    Prestador.fromMap,
    (prestador) => prestador.toMap(),
    (prestador) => prestador.id,
  );
  @override
  Future<List<Prestador>> findAll() => _repository.listar();

  @override
  Future<List<Prestador>> buscar(String texto) => _repository.listar(texto);

  @override
  Future<void> salvar(Prestador prestador) => _repository.salvar(prestador);

  @override
  Future<void> excluir(int id) => _repository.excluir(id);
}

class DependenteRepositoryApi implements IDependenteRepository {
  final _repository = ApiCrudRepository(
    '/dependentes',
    Dependente.fromMap,
    (dependente) => dependente.toMap(),
    (dependente) => dependente.id,
  );
  @override
  Future<List<Dependente>> findAll() => _repository.listar();

  @override
  Future<List<Dependente>> buscar(String texto) => _repository.listar(texto);

  @override
  Future<void> salvar(Dependente dependente) => _repository.salvar(dependente);

  @override
  Future<void> excluir(int id) => _repository.excluir(id);
}

class ContratoRepositoryApi implements IContratoRepository {
  final _repository = ApiCrudRepository(
    '/contratos',
    Contrato.fromMap,
    (contrato) => contrato.toMap(),
    (contrato) => contrato.id,
  );
  @override
  Future<List<Contrato>> findAll() => _repository.listar();

  @override
  Future<List<Contrato>> buscar(String texto) => _repository.listar(texto);

  @override
  Future<void> salvar(Contrato contrato) => _repository.salvar(contrato);

  @override
  Future<void> excluir(int id) => _repository.excluir(id);
}

class PagamentoRepositoryApi implements IPagamentoRepository {
  final _repository = ApiCrudRepository(
    '/pagamentos',
    Pagamento.fromMap,
    (pagamento) => pagamento.toMap(),
    (pagamento) => pagamento.id,
  );
  @override
  Future<List<Pagamento>> findAll() => _repository.listar();

  @override
  Future<List<Pagamento>> buscar(String texto) => _repository.listar(texto);

  @override
  Future<void> salvar(Pagamento pagamento) => _repository.salvar(pagamento);

  @override
  Future<void> excluir(int id) => _repository.excluir(id);
}

class ServicoRepositoryApi implements IServicoRepository {
  final _repository = ApiCrudRepository(
    '/servicos',
    Servico.fromMap,
    (servico) => servico.toMap(),
    (servico) => servico.id,
  );
  @override
  Future<List<Servico>> findAll() => _repository.listar();

  @override
  Future<List<Servico>> buscar(String texto) => _repository.listar(texto);

  @override
  Future<void> salvar(Servico servico) => _repository.salvar(servico);

  @override
  Future<void> excluir(int id) => _repository.excluir(id);

  @override
  Future<List<Servico>> buscarPorPlano(int id) async {
    final dados =
        await ApiClient.instance.get('/servicos/por-plano/$id')
            as List<dynamic>;
    return dados
        .map((item) => Servico.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}

class FaixaValorRepositoryApi implements IFaixaValorRepository {
  final _repository = ApiCrudRepository(
    '/faixas-valor',
    FaixaValor.fromMap,
    (faixa) => faixa.toMap(),
    (faixa) => faixa.id,
  );
  @override
  Future<void> salvar(FaixaValor faixa) => _repository.salvar(faixa);

  @override
  Future<void> excluir(int id) => _repository.excluir(id);

  @override
  Future<List<FaixaValor>> buscarPorPlano(int id) async {
    final dados =
        await ApiClient.instance.get('/faixas-valor/por-plano/$id')
            as List<dynamic>;
    return dados
        .map((item) => FaixaValor.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<double?> valorPorIdade(int planoId, int idade) async {
    try {
      final value = await ApiClient.instance.get(
        '/faixas-valor/valor-por-idade',
        query: {'planoId': '$planoId', 'idade': '$idade'},
      );
      return (value as num).toDouble();
    } on ApiException catch (erro) {
      if (erro.statusCode == 404) {
        return null;
      }

      rethrow;
    }
  }
}

class AtendimentoRepositoryApi implements IAtendimentoRepository {
  final _repository = ApiCrudRepository(
    '/atendimentos',
    Atendimento.fromMap,
    (atendimento) => atendimento.toMap(),
    (atendimento) => atendimento.id,
  );
  @override
  Future<List<Atendimento>> findAll() => _repository.listar();

  @override
  Future<List<Atendimento>> buscar(String texto) => _repository.listar(texto);

  @override
  Future<void> salvar(Atendimento atendimento) =>
      _repository.salvar(atendimento);

  @override
  Future<void> excluir(int id) => _repository.excluir(id);

  @override
  Future<List<Atendimento>> buscarPorCliente(int id) async {
    final dados =
        await ApiClient.instance.get('/atendimentos/por-cliente/$id')
            as List<dynamic>;
    return dados
        .map((item) => Atendimento.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}

class UsuarioRepositoryApi implements IUsuarioRepository {
  @override
  Future<Usuario?> autenticar(String email, String senha) async {
    try {
      final dados =
          await ApiClient.instance.post('/auth/login', {
                'email': email,
                'senha': senha,
              })
              as Map<String, dynamic>;
      final token = dados['token'] as String;
      await ApiClient.instance.salvarToken(token);
      return Usuario.fromMap(dados);
    } on ApiException catch (erro) {
      if (erro.statusCode == 401) {
        return null;
      }

      rethrow;
    }
  }

  @override
  Future<void> cadastrar(Usuario usuario) async {
    final corpo = usuario.toMap();
    corpo.remove('id');
    await ApiClient.instance.post('/auth/cadastro', corpo);
  }
}
