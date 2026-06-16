import '../models/relatorio.dart';

abstract class IRelatorioRepository {
  Future<Relatorio> gerar();
}
