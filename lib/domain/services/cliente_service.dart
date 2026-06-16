import '../../service_locator.dart';
import '../models/cliente.dart';
import '../repository/cliente_repository.dart';

class ClienteService {
  final IClienteRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.clienteRepository,
  );

  Future<List<Cliente>> findAll() => _repo.findAll();
  Future<List<Cliente>> buscar(String texto) => _repo.buscar(texto);
  Future<void> salvar(Cliente cliente) => _repo.salvar(cliente);
  Future<void> excluir(int id) => _repo.excluir(id);
}
