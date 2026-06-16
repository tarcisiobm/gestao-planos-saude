import '../../service_locator.dart';
import '../models/relatorio.dart';
import '../repository/relatorio_repository.dart';

class RelatorioService {
  final IRelatorioRepository _repo = ServiceLocator.instance.findRepository(
    ServiceLocator.relatorioRepository,
  );

  Future<Relatorio> gerar() => _repo.gerar();
}
