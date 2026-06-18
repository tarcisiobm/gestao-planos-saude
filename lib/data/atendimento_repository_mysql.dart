import '../domain/models/atendimento.dart';
import '../domain/repository/atendimento_repository.dart';
import 'app_database.dart';

class AtendimentoRepositoryMysql implements IAtendimentoRepository {
  final _db = AppDatabase.db;

  static const _select = '''
    SELECT atendimento.*,
           cliente.nome AS cliente_nome,
           servico.nome AS servico_nome,
           plano.nome AS plano_nome,
           prestador.nome AS prestador_nome
    FROM atendimento
    LEFT JOIN cliente ON cliente.id = atendimento.cliente_id
    LEFT JOIN servico ON servico.id = atendimento.servico_id
    LEFT JOIN plano ON plano.id = servico.plano_id
    LEFT JOIN prestador ON prestador.id = servico.prestador_id
  ''';

  @override
  Future<List<Atendimento>> findAll() async {
    final result = await _db.execute('$_select ORDER BY atendimento.id DESC');
    return result.rows
        .map((row) => Atendimento.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<List<Atendimento>> buscar(String texto) async {
    final result = await _db.execute(
      '''
      $_select
      WHERE cliente.nome LIKE :texto
         OR servico.nome LIKE :texto
         OR plano.nome LIKE :texto
         OR prestador.nome LIKE :texto
         OR atendimento.descricao LIKE :texto
      ORDER BY atendimento.id DESC
      ''',
      {'texto': '%$texto%'},
    );
    return result.rows
        .map((row) => Atendimento.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<List<Atendimento>> buscarPorCliente(int clienteId) async {
    final result = await _db.execute(
      '''
      $_select
      WHERE atendimento.cliente_id = :cliente_id
      ORDER BY atendimento.id DESC
      ''',
      {'cliente_id': clienteId},
    );
    return result.rows
        .map((row) => Atendimento.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<void> salvar(Atendimento atendimento) async {
    if (atendimento.id == null) {
      await _db.execute('''
        INSERT INTO atendimento (cliente_id, servico_id, data, horario, descricao)
        VALUES (:cliente_id, :servico_id, :data, :horario, :descricao)
        ''', atendimento.toMap()..remove('id'));
      return;
    }

    await _db.execute('''
      UPDATE atendimento
      SET cliente_id = :cliente_id,
          servico_id = :servico_id,
          data = :data,
          horario = :horario,
          descricao = :descricao
      WHERE id = :id
      ''', atendimento.toMap());
  }

  @override
  Future<void> excluir(int id) async {
    await _db.execute('DELETE FROM atendimento WHERE id = :id', {'id': id});
  }
}
