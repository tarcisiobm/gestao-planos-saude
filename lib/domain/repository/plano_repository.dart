import '../models/plano.dart';

abstract class IPlanoRepository {
  Future<List<Plano>> findAll();
  Future<List<Plano>> buscar(String texto);
  Future<void> salvar(Plano plano);
  Future<void> excluir(int id);
}
