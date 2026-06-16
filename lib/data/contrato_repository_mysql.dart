import '../domain/models/contrato.dart';
import '../domain/repository/contrato_repository.dart';
import 'app_database.dart';

class ContratoRepositoryMysql implements IContratoRepository {
  final _db = AppDatabase.db;

  static const _select = '''
    SELECT contrato.*, cliente.nome AS cliente_nome, plano.nome AS plano_nome
    FROM contrato
    LEFT JOIN cliente ON cliente.id = contrato.cliente_id
    LEFT JOIN plano ON plano.id = contrato.plano_id
  ''';

  @override
  Future<List<Contrato>> findAll() async {
    final result = await _db.execute('$_select ORDER BY cliente.nome');
    return result.rows
        .map((row) => Contrato.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<List<Contrato>> buscar(String texto) async {
    final result = await _db.execute(
      '$_select WHERE cliente.nome LIKE :texto ORDER BY cliente.nome',
      {'texto': '%$texto%'},
    );
    return result.rows
        .map((row) => Contrato.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<void> salvar(Contrato contrato) async {
    if (contrato.id == null) {
      await _db.execute('''
        INSERT INTO contrato (
          cliente_id, plano_id, data_inicio, validade, status, renovacao_automatica
        )
        VALUES (
          :cliente_id, :plano_id, :data_inicio, :validade, :status, :renovacao_automatica
        )
        ''', contrato.toMap()..remove('id'));
      return;
    }

    await _db.execute('''
      UPDATE contrato
      SET cliente_id = :cliente_id,
          plano_id = :plano_id,
          data_inicio = :data_inicio,
          validade = :validade,
          status = :status,
          renovacao_automatica = :renovacao_automatica
      WHERE id = :id
      ''', contrato.toMap());
  }

  @override
  Future<void> excluir(int id) async {
    await _db.execute('DELETE FROM contrato WHERE id = :id', {'id': id});
  }
}
