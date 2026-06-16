import '../models/prestador.dart';

abstract class IPrestadorRepository {
  Future<List<Prestador>> findAll();
  Future<List<Prestador>> buscar(String texto);
  Future<void> salvar(Prestador prestador);
  Future<void> excluir(int id);
}
