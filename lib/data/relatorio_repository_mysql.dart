import '../domain/constants/status.dart';
import '../domain/models/relatorio.dart';
import '../domain/repository/relatorio_repository.dart';
import 'app_database.dart';

class RelatorioRepositoryMysql implements IRelatorioRepository {
  final _db = AppDatabase.db;

  Future<int> _contar(String sql) async {
    final result = await _db.execute(sql);
    return _toInt(result.rows.first.colAt(0));
  }

  Future<double> _somar(String sql) async {
    final result = await _db.execute(sql);
    return _toDouble(result.rows.first.colAt(0));
  }

  int _toInt(Object? value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  double _toDouble(Object? value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  Future<Relatorio> gerar() async {
    return Relatorio(
      clientes: await _contar('SELECT COUNT(*) FROM cliente'),
      planos: await _contar('SELECT COUNT(*) FROM plano'),
      prestadores: await _contar('SELECT COUNT(*) FROM prestador'),
      contratos: await _contar('SELECT COUNT(*) FROM contrato'),
      contratosAtivos: await _contar(
        "SELECT COUNT(*) FROM contrato WHERE status = '${StatusContrato.ativo}'",
      ),
      pagamentosPendentes: await _contar(
        "SELECT COUNT(*) FROM pagamento WHERE status = '${StatusPagamento.pendente}'",
      ),
      pagamentosAtrasados: await _contar(
        "SELECT COUNT(*) FROM pagamento WHERE status = '${StatusPagamento.atrasado}'",
      ),
      receitaRecebida: await _somar(
        "SELECT SUM(valor) FROM pagamento WHERE status = '${StatusPagamento.pago}'",
      ),
    );
  }
}
