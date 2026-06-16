import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../domain/models/plano.dart';
import '../../../domain/services/plano_service.dart';

class SimulacaoScreen extends StatefulWidget {
  const SimulacaoScreen({super.key});

  @override
  State<SimulacaoScreen> createState() => _SimulacaoScreenState();
}

class _SimulacaoScreenState extends State<SimulacaoScreen> {
  final _planoService = PlanoService();
  final _dependentesController = TextEditingController(text: '0');
  List<Plano> _planos = [];
  int? _planoId;
  double? _resultado;
  double _valorDependenteUsado = 0;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final planos = await _planoService.findAll();
    setState(() {
      _planos = planos;
      _carregando = false;
    });
  }

  @override
  void dispose() {
    _dependentesController.dispose();
    super.dispose();
  }

  void _simular() {
    if (_planoId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione um plano')));
      return;
    }
    final plano = _planos.firstWhere((plano) => plano.id == _planoId);
    final quantidadeDependentes =
        int.tryParse(_dependentesController.text) ?? 0;
    setState(() {
      _valorDependenteUsado = plano.valorDependente;
      _resultado = plano.valor + quantidadeDependentes * plano.valorDependente;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Simulação de proposta')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            initialValue: _planoId,
            decoration: const InputDecoration(
              labelText: 'Plano',
              border: OutlineInputBorder(),
            ),
            items: _planos
                .map(
                  (plano) => DropdownMenuItem(
                    value: plano.id,
                    child: Text(
                      '${plano.nome} (R\$ ${plano.valor.toStringAsFixed(AppConstants.casasDecimaisMoeda)})',
                    ),
                  ),
                )
                .toList(),
            onChanged: (planoId) => setState(() => _planoId = planoId),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dependentesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Número de dependentes',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _simular, child: const Text('Simular')),
          if (_resultado != null) ...[
            const SizedBox(height: 24),
            Text(
              'Valor estimado: R\$ ${_resultado!.toStringAsFixed(AppConstants.casasDecimaisMoeda)} /mês',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '(plano + R\$ ${_valorDependenteUsado.toStringAsFixed(AppConstants.casasDecimaisMoeda)} por dependente)',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
