import '../../service_locator.dart';
import '../models/dependente.dart';
import '../repository/dependente_repository.dart';

class DependenteService {
  final IDependenteRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.dependenteRepository,
  );

  Future<List<Dependente>> findAll() => _repo.findAll();
  Future<List<Dependente>> buscar(String texto) => _repo.buscar(texto);
  Future<void> salvar(Dependente dependente) => _repo.salvar(dependente);
  Future<void> excluir(int id) => _repo.excluir(id);
}
