import '../domain/models/cobertura.dart';
import '../domain/repository/cobertura_repository.dart';
import 'app_database.dart';

class CoberturaRepositoryMysql implements ICoberturaRepository {
  final _db = AppDatabase.db;

  static const _select = '''
    SELECT cobertura.*, plano.nome AS plano_nome, prestador.nome AS prestador_nome
    FROM cobertura
    LEFT JOIN plano ON plano.id = cobertura.plano_id
    LEFT JOIN prestador ON prestador.id = cobertura.prestador_id
  ''';

  @override
  Future<List<Cobertura>> findAll() async {
    final result = await _db.execute('$_select ORDER BY plano.nome');
    return result.rows
        .map((row) => Cobertura.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<List<Cobertura>> buscar(String texto) async {
    final result = await _db.execute(
      '$_select WHERE plano.nome LIKE :texto ORDER BY plano.nome',
      {'texto': '%$texto%'},
    );
    return result.rows
        .map((row) => Cobertura.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<void> salvar(Cobertura cobertura) async {
    if (cobertura.id == null) {
      await _db.execute('''
        INSERT INTO cobertura (plano_id, prestador_id)
        VALUES (:plano_id, :prestador_id)
        ''', cobertura.toMap()..remove('id'));
      return;
    }

    await _db.execute('''
      UPDATE cobertura
      SET plano_id = :plano_id,
          prestador_id = :prestador_id
      WHERE id = :id
      ''', cobertura.toMap());
  }

  @override
  Future<void> excluir(int id) async {
    await _db.execute('DELETE FROM cobertura WHERE id = :id', {'id': id});
  }
}
