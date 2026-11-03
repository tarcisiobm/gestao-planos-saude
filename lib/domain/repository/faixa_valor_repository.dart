import '../models/faixa_valor.dart';

abstract class IFaixaValorRepository {
  Future<List<FaixaValor>> buscarPorPlano(int planoId);

  Future<double?> valorPorIdade(int planoId, int idade);

  Future<void> salvar(FaixaValor faixa);
  Future<void> excluir(int id);
}
