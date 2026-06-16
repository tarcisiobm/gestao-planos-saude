import 'package:flutter/material.dart';

import '../../../domain/models/cliente.dart';
import '../../../domain/models/dependente.dart';
import '../../../domain/services/cliente_service.dart';
import '../../../domain/services/dependente_service.dart';

class DependenteFormScreen extends StatefulWidget {
  const DependenteFormScreen({super.key});

  @override
  State<DependenteFormScreen> createState() => _DependenteFormScreenState();
}

class _DependenteFormScreenState extends State<DependenteFormScreen> {
  final _service = DependenteService();
  final _clienteService = ClienteService();
  late final Dependente _dependente;
  late final TextEditingController _nome;
  late final TextEditingController _cpf;
  late final TextEditingController _parentesco;
  List<Cliente> _clientes = [];
  int? _clienteId;
  bool _iniciado = false;
  bool _carregando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    _dependente = argumento is Dependente ? argumento : Dependente();
    _nome = TextEditingController(text: _dependente.nome);
    _cpf = TextEditingController(text: _dependente.cpf);
    _parentesco = TextEditingController(text: _dependente.parentesco);
    _clienteId = _dependente.clienteId;
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    final clientes = await _clienteService.findAll();
    setState(() {
      _clientes = clientes;
      _carregando = false;
    });
  }

  @override
  void dispose() {
    if (_iniciado) {
      _nome.dispose();
      _cpf.dispose();
      _parentesco.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_clienteId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione o titular')));
      return;
    }
    _dependente.clienteId = _clienteId;
    _dependente.nome = _nome.text;
    _dependente.cpf = _cpf.text;
    _dependente.parentesco = _parentesco.text;
    await _service.salvar(_dependente);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final editando = _dependente.id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar dependente' : 'Novo dependente'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            initialValue: _clienteId,
            decoration: const InputDecoration(
              labelText: 'Titular',
              border: OutlineInputBorder(),
            ),
            items: _clientes
                .map(
                  (cliente) => DropdownMenuItem(
                    value: cliente.id,
                    child: Text(cliente.nome),
                  ),
                )
                .toList(),
            onChanged: (clienteId) => setState(() => _clienteId = clienteId),
          ),
          const SizedBox(height: 12),
          _campo(_nome, 'Nome'),
          _campo(_cpf, 'CPF'),
          _campo(_parentesco, 'Parentesco'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
        ],
      ),
    );
  }

  Widget _campo(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
