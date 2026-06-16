import '../../service_locator.dart';
import '../models/usuario.dart';
import '../repository/usuario_repository.dart';

class UsuarioService {
  final IUsuarioRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.usuarioRepository,
  );

  Future<Usuario?> autenticar(String email, String senha) =>
      _repo.autenticar(email, senha);
  Future<void> cadastrar(Usuario usuario) => _repo.cadastrar(usuario);
}
