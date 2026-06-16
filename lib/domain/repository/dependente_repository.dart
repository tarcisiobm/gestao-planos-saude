import '../models/dependente.dart';

abstract class IDependenteRepository {
  Future<List<Dependente>> findAll();
  Future<List<Dependente>> buscar(String texto);
  Future<void> salvar(Dependente dependente);
  Future<void> excluir(int id);
}
