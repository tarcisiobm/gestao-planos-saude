import '../domain/models/faixa_valor.dart';
import '../domain/repository/faixa_valor_repository.dart';
import 'app_database.dart';

class FaixaValorRepositoryMysql implements IFaixaValorRepository {
  final _db = AppDatabase.db;

  @override
  Future<List<FaixaValor>> buscarPorPlano(int planoId) async {
    final result = await _db.execute(
      'SELECT * FROM faixa_valor WHERE plano_id = :plano_id ORDER BY idade_min',
      {'plano_id': planoId},
    );
    return result.rows
        .map((row) => FaixaValor.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<double?> valorPorIdade(int planoId, int idade) async {
    final result = await _db.execute(
      '''
      SELECT valor FROM faixa_valor
      WHERE plano_id = :plano_id AND idade_min <= :idade AND idade_max >= :idade
      ORDER BY idade_min
      LIMIT 1
      ''',
      {'plano_id': planoId, 'idade': idade},
    );
    if (result.rows.isEmpty) return null;
    return FaixaValor.fromMap(result.rows.first.typedAssoc()).valor;
  }

  @override
  Future<void> salvar(FaixaValor faixa) async {
    if (faixa.id == null) {
      await _db.execute('''
        INSERT INTO faixa_valor (plano_id, idade_min, idade_max, valor)
        VALUES (:plano_id, :idade_min, :idade_max, :valor)
        ''', faixa.toMap()..remove('id'));
      return;
    }

    await _db.execute('''
      UPDATE faixa_valor
      SET plano_id = :plano_id,
          idade_min = :idade_min,
          idade_max = :idade_max,
          valor = :valor
      WHERE id = :id
      ''', faixa.toMap());
  }

  @override
  Future<void> excluir(int id) async {
    await _db.execute('DELETE FROM faixa_valor WHERE id = :id', {'id': id});
  }
}
