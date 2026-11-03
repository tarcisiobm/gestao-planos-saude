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
  final List<TextEditingController> _idadesDependentes = [];
  List<Plano> _planos = [];
  int? _planoId;
  ResultadoSimulacao? _resultado;
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
    for (final controller in _idadesDependentes) {
      controller.dispose();
    }
    super.dispose();
  }

  void _adicionarDependente() {
    setState(() => _idadesDependentes.add(TextEditingController()));
  }

  void _removerDependente(int indice) {
    final controller = _idadesDependentes.removeAt(indice);
    controller.dispose();
    setState(() {});
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
    final idadesDependentes = <int>[];
    for (final controller in _idadesDependentes) {
      final idadeDependente = int.tryParse(controller.text);
      if (idadeDependente == null || idadeDependente < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informe a idade de cada dependente')),
        );
        return;
      }
      idadesDependentes.add(idadeDependente);
    }

    late final ResultadoSimulacao resultado;
    try {
      resultado = await _simulacaoService.simular(
        planoId: _planoId!,
        idadeTitular: idade,
        idadesDependentes: idadesDependentes,
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

    setState(() => _resultado = resultado);
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
          for (var indice = 0; indice < _idadesDependentes.length; indice++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: _idadesDependentes[indice],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Idade do dependente ${indice + 1}',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: 'Remover dependente',
                    icon: const Icon(Icons.close),
                    onPressed: () => _removerDependente(indice),
                  ),
                ),
              ),
            ),
          TextButton.icon(
            onPressed: _adicionarDependente,
            icon: const Icon(Icons.person_add),
            label: const Text('Adicionar dependente'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _simular, child: const Text('Simular')),
          if (_resultado != null) ...[
            const SizedBox(height: 24),
            Text(
              'Valor estimado: R\$ ${_resultado!.valorTotal.toStringAsFixed(AppConstants.casasDecimaisMoeda)} /mês',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (final pessoa in _resultado!.pessoas)
              Text(
                '${pessoa.descricao} (${pessoa.idade} anos): R\$ ${pessoa.valor.toStringAsFixed(AppConstants.casasDecimaisMoeda)}',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ],
      ),
    );
  }
}
