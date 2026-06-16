import '../../service_locator.dart';
import '../models/pagamento.dart';
import '../repository/pagamento_repository.dart';

class PagamentoService {
  final IPagamentoRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.pagamentoRepository,
  );

  Future<List<Pagamento>> findAll() => _repo.findAll();
  Future<List<Pagamento>> buscar(String texto) => _repo.buscar(texto);
  Future<void> salvar(Pagamento pagamento) => _repo.salvar(pagamento);
  Future<void> excluir(int id) => _repo.excluir(id);
}
