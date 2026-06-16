import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../domain/models/relatorio.dart';
import '../../../domain/services/relatorio_service.dart';

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  State<RelatorioScreen> createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  final _service = RelatorioService();
  Relatorio? _dados;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final relatorio = await _service.gerar();
    setState(() => _dados = relatorio);
  }

  @override
  Widget build(BuildContext context) {
    final relatorio = _dados;
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: relatorio == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _linha('Clientes', '${relatorio.clientes}'),
                _linha('Planos', '${relatorio.planos}'),
                _linha('Prestadores', '${relatorio.prestadores}'),
                _linha('Contratos', '${relatorio.contratos}'),
                _linha('Contratos ativos', '${relatorio.contratosAtivos}'),
                _linha(
                  'Pagamentos pendentes',
                  '${relatorio.pagamentosPendentes}',
                ),
                _linha(
                  'Pagamentos atrasados',
                  '${relatorio.pagamentosAtrasados}',
                ),
                _linha(
                  'Receita recebida',
                  'R\$ ${relatorio.receitaRecebida.toStringAsFixed(AppConstants.casasDecimaisMoeda)}',
                ),
              ],
            ),
    );
  }

  Widget _linha(String titulo, String valor) {
    return ListTile(
      title: Text(titulo),
      trailing: Text(
        valor,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
