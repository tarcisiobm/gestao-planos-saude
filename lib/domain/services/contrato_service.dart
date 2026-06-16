import '../../service_locator.dart';
import '../models/contrato.dart';
import '../repository/contrato_repository.dart';

class ContratoService {
  final IContratoRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.contratoRepository,
  );

  Future<List<Contrato>> findAll() => _repo.findAll();
  Future<List<Contrato>> buscar(String texto) => _repo.buscar(texto);
  Future<void> salvar(Contrato contrato) => _repo.salvar(contrato);
  Future<void> excluir(int id) => _repo.excluir(id);
}
