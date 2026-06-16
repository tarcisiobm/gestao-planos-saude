import '../../service_locator.dart';
import '../models/cobertura.dart';
import '../repository/cobertura_repository.dart';

class CoberturaService {
  final ICoberturaRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.coberturaRepository,
  );

  Future<List<Cobertura>> findAll() => _repo.findAll();
  Future<List<Cobertura>> buscar(String texto) => _repo.buscar(texto);
  Future<void> salvar(Cobertura cobertura) => _repo.salvar(cobertura);
  Future<void> excluir(int id) => _repo.excluir(id);
}
