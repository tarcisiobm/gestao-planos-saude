import '../../service_locator.dart';
import '../models/plano.dart';
import '../repository/plano_repository.dart';

class PlanoService {
  final IPlanoRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.planoRepository,
  );

  Future<List<Plano>> findAll() => _repo.findAll();
  Future<List<Plano>> buscar(String texto) => _repo.buscar(texto);
  Future<void> salvar(Plano plano) => _repo.salvar(plano);
  Future<void> excluir(int id) => _repo.excluir(id);
}
