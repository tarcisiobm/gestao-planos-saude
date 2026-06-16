import 'package:flutter/material.dart';

import '../../../domain/models/cliente.dart';
import '../../../domain/services/cliente_service.dart';

class ClienteFormScreen extends StatefulWidget {
  const ClienteFormScreen({super.key});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _service = ClienteService();
  late final Cliente _cliente;
  late final TextEditingController _nome;
  late final TextEditingController _cpf;
  late final TextEditingController _telefone;
  late final TextEditingController _email;
  late final TextEditingController _endereco;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    _cliente = argumento is Cliente ? argumento : Cliente();
    _nome = TextEditingController(text: _cliente.nome);
    _cpf = TextEditingController(text: _cliente.cpf);
    _telefone = TextEditingController(text: _cliente.telefone);
    _email = TextEditingController(text: _cliente.email);
    _endereco = TextEditingController(text: _cliente.endereco);
  }

  @override
  void dispose() {
    if (_iniciado) {
      _nome.dispose();
      _cpf.dispose();
      _telefone.dispose();
      _email.dispose();
      _endereco.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    _cliente.nome = _nome.text;
    _cliente.cpf = _cpf.text;
    _cliente.telefone = _telefone.text;
    _cliente.email = _email.text;
    _cliente.endereco = _endereco.text;
    await _service.salvar(_cliente);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = _cliente.id != null;
    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar cliente' : 'Novo cliente')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _campo(_nome, 'Nome'),
          _campo(_cpf, 'CPF'),
          _campo(_telefone, 'Telefone'),
          _campo(_email, 'E-mail'),
          _campo(_endereco, 'Endereço'),
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
