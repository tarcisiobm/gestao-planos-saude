import '../models/usuario.dart';

abstract class IUsuarioRepository {
  Future<Usuario?> autenticar(String email, String senha);
  Future<void> cadastrar(Usuario usuario);
}
