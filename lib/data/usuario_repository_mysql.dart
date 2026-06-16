import '../domain/models/usuario.dart';
import '../domain/repository/usuario_repository.dart';
import 'app_database.dart';

class UsuarioRepositoryMysql implements IUsuarioRepository {
  final _db = AppDatabase.db;

  @override
  Future<Usuario?> autenticar(String email, String senha) async {
    final result = await _db.execute(
      '''
      SELECT *
      FROM usuario
      WHERE email = :email AND senha = :senha
      LIMIT 1
      ''',
      {'email': email, 'senha': senha},
    );
    if (result.rows.isEmpty) return null;
    return Usuario.fromMap(result.rows.first.typedAssoc());
  }

  @override
  Future<void> cadastrar(Usuario usuario) async {
    await _db.execute('''
      INSERT INTO usuario (nome, email, senha)
      VALUES (:nome, :email, :senha)
      ''', usuario.toMap()..remove('id'));
  }
}
