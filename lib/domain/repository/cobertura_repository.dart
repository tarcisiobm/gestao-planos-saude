import '../models/cobertura.dart';

abstract class ICoberturaRepository {
  Future<List<Cobertura>> findAll();
  Future<List<Cobertura>> buscar(String texto);
  Future<void> salvar(Cobertura cobertura);
  Future<void> excluir(int id);
}
