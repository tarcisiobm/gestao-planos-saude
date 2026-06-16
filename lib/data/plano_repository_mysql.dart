import '../domain/models/plano.dart';
import '../domain/repository/plano_repository.dart';
import 'app_database.dart';

class PlanoRepositoryMysql implements IPlanoRepository {
  final _db = AppDatabase.db;

  @override
  Future<List<Plano>> findAll() async {
    final result = await _db.execute('SELECT * FROM plano ORDER BY nome');
    return result.rows.map((row) => Plano.fromMap(row.typedAssoc())).toList();
  }

  @override
  Future<List<Plano>> buscar(String texto) async {
    final result = await _db.execute(
      'SELECT * FROM plano WHERE nome LIKE :texto ORDER BY nome',
      {'texto': '%$texto%'},
    );
    return result.rows.map((row) => Plano.fromMap(row.typedAssoc())).toList();
  }

  @override
  Future<void> salvar(Plano plano) async {
    if (plano.id == null) {
      await _db.execute('''
        INSERT INTO plano (nome, tipo_cobertura, valor, valor_dependente, vigencia, forma_pagamento)
        VALUES (:nome, :tipo_cobertura, :valor, :valor_dependente, :vigencia, :forma_pagamento)
        ''', plano.toMap()..remove('id'));
      return;
    }

    await _db.execute('''
      UPDATE plano
      SET nome = :nome,
          tipo_cobertura = :tipo_cobertura,
          valor = :valor,
          valor_dependente = :valor_dependente,
          vigencia = :vigencia,
          forma_pagamento = :forma_pagamento
      WHERE id = :id
      ''', plano.toMap());
  }

  @override
  Future<void> excluir(int id) async {
    await _db.execute('DELETE FROM plano WHERE id = :id', {'id': id});
  }
}
