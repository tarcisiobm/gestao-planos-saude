import '../../service_locator.dart';
import '../models/faixa_valor.dart';
import '../repository/faixa_valor_repository.dart';

class FaixaValorService {
  final IFaixaValorRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.faixaValorRepository,
  );

  Future<List<FaixaValor>> buscarPorPlano(int planoId) =>
      _repo.buscarPorPlano(planoId);
  Future<double?> valorPorIdade(int planoId, int idade) =>
      _repo.valorPorIdade(planoId, idade);
  Future<void> salvar(FaixaValor faixa) => _repo.salvar(faixa);
  Future<void> excluir(int id) => _repo.excluir(id);
}
