import 'package:flutter/material.dart';

import '../../../domain/models/cobertura.dart';
import '../../../domain/models/plano.dart';
import '../../../domain/models/prestador.dart';
import '../../../domain/services/cobertura_service.dart';
import '../../../domain/services/plano_service.dart';
import '../../../domain/services/prestador_service.dart';

class CoberturaFormScreen extends StatefulWidget {
  const CoberturaFormScreen({super.key});

  @override
  State<CoberturaFormScreen> createState() => _CoberturaFormScreenState();
}

class _CoberturaFormScreenState extends State<CoberturaFormScreen> {
  final _service = CoberturaService();
  final _planoService = PlanoService();
  final _prestadorService = PrestadorService();
  late final Cobertura _cobertura;
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
    _cobertura = argumento is Cobertura ? argumento : Cobertura();
    _planoId = _cobertura.planoId;
    _prestadorId = _cobertura.prestadorId;
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

  Future<void> _salvar() async {
    if (_planoId == null || _prestadorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o plano e o prestador')),
      );
      return;
    }
    _cobertura.planoId = _planoId;
    _cobertura.prestadorId = _prestadorId;
    await _service.salvar(_cobertura);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final editando = _cobertura.id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar cobertura' : 'Nova cobertura'),
      ),
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
