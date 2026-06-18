import '../models/faixa_valor.dart';

abstract class IFaixaValorRepository {
  Future<List<FaixaValor>> buscarPorPlano(int planoId);

  /// Valor da faixa que cobre a idade informada (ou null se nenhuma cobre).
  Future<double?> valorPorIdade(int planoId, int idade);

  Future<void> salvar(FaixaValor faixa);
  Future<void> excluir(int id);
}
