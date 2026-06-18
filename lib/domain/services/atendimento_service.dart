import '../../service_locator.dart';
import '../models/atendimento.dart';
import '../repository/atendimento_repository.dart';

class AtendimentoService {
  final IAtendimentoRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.atendimentoRepository,
  );

  Future<List<Atendimento>> findAll() => _repo.findAll();
  Future<List<Atendimento>> buscar(String texto) => _repo.buscar(texto);
  Future<List<Atendimento>> buscarPorCliente(int clienteId) =>
      _repo.buscarPorCliente(clienteId);
  Future<void> salvar(Atendimento atendimento) => _repo.salvar(atendimento);
  Future<void> excluir(int id) => _repo.excluir(id);
}
