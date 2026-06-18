import '../../service_locator.dart';
import '../models/servico.dart';
import '../repository/servico_repository.dart';

class ServicoService {
  final IServicoRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.servicoRepository,
  );

  Future<List<Servico>> findAll() => _repo.findAll();
  Future<List<Servico>> buscar(String texto) => _repo.buscar(texto);
  Future<List<Servico>> buscarPorPlano(int planoId) =>
      _repo.buscarPorPlano(planoId);
  Future<void> salvar(Servico servico) => _repo.salvar(servico);
  Future<void> excluir(int id) => _repo.excluir(id);
}
