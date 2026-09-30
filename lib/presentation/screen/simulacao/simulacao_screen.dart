import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../data/api_client.dart';
import '../../../domain/models/plano.dart';
import '../../../domain/services/plano_service.dart';
import '../../../domain/services/simulacao_service.dart';

class SimulacaoScreen extends StatefulWidget {
  const SimulacaoScreen({super.key});

  @override
  State<SimulacaoScreen> createState() => _SimulacaoScreenState();
}

class _SimulacaoScreenState extends State<SimulacaoScreen> {
  final _planoService = PlanoService();
  final _simulacaoService = SimulacaoService();
  final _idadeController = TextEditingController();
  final _dependentesController = TextEditingController(text: '0');
  List<Plano> _planos = [];
  int? _planoId;
  double? _resultado;
  double _valorPlanoUsado = 0;
  double _valorDependenteUsado = 0;
  int? _idadeUsada;
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
    _idadeController.dispose();
    _dependentesController.dispose();
    super.dispose();
  }

  Future<void> _simular() async {
    if (_planoId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione um plano')));
      return;
    }
    final idade = int.tryParse(_idadeController.text);
    if (idade == null || idade < 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe uma idade válida')));
      return;
    }
    final quantidadeDependentes =
        int.tryParse(_dependentesController.text) ?? 0;
    late final ResultadoSimulacao resultado;
    try {
      resultado = await _simulacaoService.simular(
        planoId: _planoId!,
        idade: idade,
        quantidadeDependentes: quantidadeDependentes,
      );
    } on ApiException catch (erro) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(erro.message)));
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _idadeUsada = idade;
      _valorPlanoUsado = resultado.valorFaixa;
      _valorDependenteUsado = resultado.valorDependente;
      _resultado = resultado.valorTotal;
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
            controller: _idadeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Idade do titular',
              border: OutlineInputBorder(),
            ),
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
              '(faixa de $_idadeUsada anos: R\$ ${_valorPlanoUsado.toStringAsFixed(AppConstants.casasDecimaisMoeda)} + R\$ ${_valorDependenteUsado.toStringAsFixed(AppConstants.casasDecimaisMoeda)} por dependente)',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
