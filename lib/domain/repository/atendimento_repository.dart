import '../models/atendimento.dart';

abstract class IAtendimentoRepository {
  Future<List<Atendimento>> findAll();
  Future<List<Atendimento>> buscar(String texto);
  Future<List<Atendimento>> buscarPorCliente(int clienteId);
  Future<void> salvar(Atendimento atendimento);
  Future<void> excluir(int id);
}
