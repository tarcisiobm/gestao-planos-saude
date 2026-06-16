import '../domain/models/pagamento.dart';
import '../domain/repository/pagamento_repository.dart';
import 'app_database.dart';

class PagamentoRepositoryMysql implements IPagamentoRepository {
  final _db = AppDatabase.db;

  static const _select = '''
    SELECT pagamento.*, cliente.nome AS cliente_nome
    FROM pagamento
    LEFT JOIN cliente ON cliente.id = pagamento.cliente_id
  ''';

  @override
  Future<List<Pagamento>> findAll() async {
    final result = await _db.execute('$_select ORDER BY cliente.nome');
    return result.rows
        .map((row) => Pagamento.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<List<Pagamento>> buscar(String texto) async {
    final result = await _db.execute(
      '$_select WHERE cliente.nome LIKE :texto ORDER BY cliente.nome',
      {'texto': '%$texto%'},
    );
    return result.rows
        .map((row) => Pagamento.fromMap(row.typedAssoc()))
        .toList();
  }

  @override
  Future<void> salvar(Pagamento pagamento) async {
    if (pagamento.id == null) {
      await _db.execute('''
        INSERT INTO pagamento (cliente_id, valor, vencimento, status)
        VALUES (:cliente_id, :valor, :vencimento, :status)
        ''', pagamento.toMap()..remove('id'));
      return;
    }

    await _db.execute('''
      UPDATE pagamento
      SET cliente_id = :cliente_id,
          valor = :valor,
          vencimento = :vencimento,
          status = :status
      WHERE id = :id
      ''', pagamento.toMap());
  }

  @override
  Future<void> excluir(int id) async {
    await _db.execute('DELETE FROM pagamento WHERE id = :id', {'id': id});
  }
}
