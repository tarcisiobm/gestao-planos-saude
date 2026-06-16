import '../domain/models/prestador.dart';
import '../domain/repository/prestador_repository.dart';
import 'app_database.dart';

class PrestadorRepositoryMysql implements IPrestadorRepository {
  final _db = AppDatabase.db;

  @override
  Future<List<Prestador>> findAll() async {
    final result = await _db.execute('SELECT * FROM prestador ORDER BY nome');
    return result.rows
        .map((row) => Prestador.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<List<Prestador>> buscar(String texto) async {
    final result = await _db.execute(
      'SELECT * FROM prestador WHERE nome LIKE :texto ORDER BY nome',
      {'texto': '%$texto%'},
    );
    return result.rows
        .map((row) => Prestador.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<void> salvar(Prestador prestador) async {
    if (prestador.id == null) {
      await _db.execute('''
        INSERT INTO prestador (nome, tipo, especialidade, localizacao)
        VALUES (:nome, :tipo, :especialidade, :localizacao)
        ''', prestador.toMap()..remove('id'));
      return;
    }

    await _db.execute('''
      UPDATE prestador
      SET nome = :nome,
          tipo = :tipo,
          especialidade = :especialidade,
          localizacao = :localizacao
      WHERE id = :id
      ''', prestador.toMap());
  }

  @override
  Future<void> excluir(int id) async {
    await _db.execute('DELETE FROM prestador WHERE id = :id', {'id': id});
  }
}
