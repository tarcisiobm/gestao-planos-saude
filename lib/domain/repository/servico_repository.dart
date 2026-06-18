import '../models/servico.dart';

abstract class IServicoRepository {
  Future<List<Servico>> findAll();
  Future<List<Servico>> buscar(String texto);
  Future<List<Servico>> buscarPorPlano(int planoId);
  Future<void> salvar(Servico servico);
  Future<void> excluir(int id);
}
