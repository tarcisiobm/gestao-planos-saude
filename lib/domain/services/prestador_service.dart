import '../../service_locator.dart';
import '../models/prestador.dart';
import '../repository/prestador_repository.dart';

class PrestadorService {
  final IPrestadorRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.prestadorRepository,
  );

  Future<List<Prestador>> findAll() => _repo.findAll();
  Future<List<Prestador>> buscar(String texto) => _repo.buscar(texto);
  Future<void> salvar(Prestador prestador) => _repo.salvar(prestador);
  Future<void> excluir(int id) => _repo.excluir(id);
}
