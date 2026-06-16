import '../models/pagamento.dart';

abstract class IPagamentoRepository {
  Future<List<Pagamento>> findAll();
  Future<List<Pagamento>> buscar(String texto);
  Future<void> salvar(Pagamento pagamento);
  Future<void> excluir(int id);
}
