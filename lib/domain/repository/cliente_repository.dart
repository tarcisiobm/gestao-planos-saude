import '../models/cliente.dart';

abstract class IClienteRepository {
  Future<List<Cliente>> findAll();
  Future<List<Cliente>> buscar(String texto);
  Future<void> salvar(Cliente cliente);
  Future<void> excluir(int id);
}
