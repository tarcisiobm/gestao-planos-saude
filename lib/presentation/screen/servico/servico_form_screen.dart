import 'package:flutter/material.dart';

import '../../../domain/models/plano.dart';
import '../../../domain/models/prestador.dart';
import '../../../domain/models/servico.dart';
import '../../../domain/services/plano_service.dart';
import '../../../domain/services/prestador_service.dart';
import '../../../domain/services/servico_service.dart';

class ServicoFormScreen extends StatefulWidget {
  const ServicoFormScreen({super.key});

  @override
  State<ServicoFormScreen> createState() => _ServicoFormScreenState();
}

class _ServicoFormScreenState extends State<ServicoFormScreen> {
  final _service = ServicoService();
  final _planoService = PlanoService();
  final _prestadorService = PrestadorService();
  late final Servico _servico;
  late final TextEditingController _nome;
  List<Plano> _planos = [];
  List<Prestador> _prestadores = [];
  int? _planoId;
  int? _prestadorId;
  bool _iniciado = false;
  bool _carregando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    _servico = argumento is Servico ? argumento : Servico();
    _nome = TextEditingController(text: _servico.nome);
    _planoId = _servico.planoId;
    _prestadorId = _servico.prestadorId;
    _carregar();
  }

  Future<void> _carregar() async {
    final planos = await _planoService.findAll();
    final prestadores = await _prestadorService.findAll();
    setState(() {
      _planos = planos;
      _prestadores = prestadores;
      _carregando = false;
    });
  }

  @override
  void dispose() {
    if (_iniciado) _nome.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_planoId == null || _prestadorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o plano e o prestador')),
      );
      return;
    }
    _servico.nome = _nome.text;
    _servico.planoId = _planoId;
    _servico.prestadorId = _prestadorId;
    await _service.salvar(_servico);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final editando = _servico.id != null;
    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar serviço' : 'Novo serviço')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nome,
            decoration: const InputDecoration(
              labelText: 'Nome do serviço',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
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
                    child: Text(plano.nome),
                  ),
                )
                .toList(),
            onChanged: (planoId) => setState(() => _planoId = planoId),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _prestadorId,
            decoration: const InputDecoration(
              labelText: 'Prestador',
              border: OutlineInputBorder(),
            ),
            items: _prestadores
                .map(
                  (prestador) => DropdownMenuItem(
                    value: prestador.id,
                    child: Text(prestador.nome),
                  ),
                )
                .toList(),
            onChanged: (prestadorId) =>
                setState(() => _prestadorId = prestadorId),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
        ],
      ),
    );
  }
}
