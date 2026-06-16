import '../domain/models/dependente.dart';
import '../domain/repository/dependente_repository.dart';
import 'app_database.dart';

class DependenteRepositoryMysql implements IDependenteRepository {
  final _db = AppDatabase.db;

  static const _select = '''
    SELECT dependente.*, cliente.nome AS cliente_nome
    FROM dependente
    LEFT JOIN cliente ON cliente.id = dependente.cliente_id
  ''';

  @override
  Future<List<Dependente>> findAll() async {
    final result = await _db.execute('$_select ORDER BY dependente.nome');
    return result.rows
        .map((row) => Dependente.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<List<Dependente>> buscar(String texto) async {
    final result = await _db.execute(
      '$_select WHERE dependente.nome LIKE :texto ORDER BY dependente.nome',
      {'texto': '%$texto%'},
    );
    return result.rows
        .map((row) => Dependente.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<void> salvar(Dependente dependente) async {
    if (dependente.id == null) {
      await _db.execute('''
        INSERT INTO dependente (cliente_id, nome, cpf, parentesco)
        VALUES (:cliente_id, :nome, :cpf, :parentesco)
        ''', dependente.toMap()..remove('id'));
      return;
    }

    await _db.execute('''
      UPDATE dependente
      SET cliente_id = :cliente_id,
          nome = :nome,
          cpf = :cpf,
          parentesco = :parentesco
      WHERE id = :id
      ''', dependente.toMap());
  }

  @override
  Future<void> excluir(int id) async {
    await _db.execute('DELETE FROM dependente WHERE id = :id', {'id': id});
  }
}
