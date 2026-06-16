import '../models/contrato.dart';

abstract class IContratoRepository {
  Future<List<Contrato>> findAll();
  Future<List<Contrato>> buscar(String texto);
  Future<void> salvar(Contrato contrato);
  Future<void> excluir(int id);
}
