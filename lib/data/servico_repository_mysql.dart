import '../domain/models/servico.dart';
import '../domain/repository/servico_repository.dart';
import 'app_database.dart';

class ServicoRepositoryMysql implements IServicoRepository {
  final _db = AppDatabase.db;

  static const _select = '''
    SELECT servico.*, plano.nome AS plano_nome, prestador.nome AS prestador_nome
    FROM servico
    LEFT JOIN plano ON plano.id = servico.plano_id
    LEFT JOIN prestador ON prestador.id = servico.prestador_id
  ''';

  @override
  Future<List<Servico>> findAll() async {
    final result = await _db.execute('$_select ORDER BY servico.nome');
    return result.rows.map((row) => Servico.fromMap(row.typedAssoc())).toList();
  }

  @override
  Future<List<Servico>> buscar(String texto) async {
    final result = await _db.execute(
      '$_select WHERE servico.nome LIKE :texto ORDER BY servico.nome',
      {'texto': '%$texto%'},
    );
    return result.rows.map((row) => Servico.fromMap(row.typedAssoc())).toList();
  }

  @override
  Future<List<Servico>> buscarPorPlano(int planoId) async {
    final result = await _db.execute(
      '$_select WHERE servico.plano_id = :plano_id ORDER BY servico.nome',
      {'plano_id': planoId},
    );
    return result.rows.map((row) => Servico.fromMap(row.typedAssoc())).toList();
  }

  @override
  Future<void> salvar(Servico servico) async {
    if (servico.id == null) {
      await _db.execute('''
        INSERT INTO servico (plano_id, prestador_id, nome)
        VALUES (:plano_id, :prestador_id, :nome)
        ''', servico.toMap()..remove('id'));
      return;
    }

    await _db.execute('''
      UPDATE servico
      SET plano_id = :plano_id,
          prestador_id = :prestador_id,
          nome = :nome
      WHERE id = :id
      ''', servico.toMap());
  }

  @override
  Future<void> excluir(int id) async {
    await _db.execute('DELETE FROM servico WHERE id = :id', {'id': id});
  }
}
