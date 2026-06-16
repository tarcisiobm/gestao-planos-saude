import '../domain/models/cliente.dart';
import '../domain/repository/cliente_repository.dart';
import 'app_database.dart';

class ClienteRepositoryMysql implements IClienteRepository {
  final _db = AppDatabase.db;

  @override
  Future<List<Cliente>> findAll() async {
    final result = await _db.execute('SELECT * FROM cliente ORDER BY nome');
    return result.rows.map((row) => Cliente.fromMap(row.typedAssoc())).toList();
  }

  @override
  Future<List<Cliente>> buscar(String texto) async {
    final result = await _db.execute(
      'SELECT * FROM cliente WHERE nome LIKE :texto ORDER BY nome',
      {'texto': '%$texto%'},
    );
    return result.rows.map((row) => Cliente.fromMap(row.typedAssoc())).toList();
  }

  @override
  Future<void> salvar(Cliente cliente) async {
    if (cliente.id == null) {
      await _db.execute('''
        INSERT INTO cliente (nome, cpf, telefone, email, endereco)
        VALUES (:nome, :cpf, :telefone, :email, :endereco)
        ''', cliente.toMap()..remove('id'));
      return;
    }

    await _db.execute('''
      UPDATE cliente
      SET nome = :nome,
          cpf = :cpf,
          telefone = :telefone,
          email = :email,
          endereco = :endereco
      WHERE id = :id
      ''', cliente.toMap());
  }

  @override
  Future<void> excluir(int id) async {
    await _db.execute('DELETE FROM cliente WHERE id = :id', {'id': id});
  }
}
