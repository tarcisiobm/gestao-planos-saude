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
  late final TextEditingController _rua;
  late final TextEditingController _numero;
  late final TextEditingController _complemento;
  late final TextEditingController _bairro;
  late final TextEditingController _cidade;
  late final TextEditingController _estado;
  late final TextEditingController _cep;
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
    _rua = TextEditingController(text: _cliente.rua);
    _numero = TextEditingController(text: _cliente.numero);
    _complemento = TextEditingController(text: _cliente.complemento);
    _bairro = TextEditingController(text: _cliente.bairro);
    _cidade = TextEditingController(text: _cliente.cidade);
    _estado = TextEditingController(text: _cliente.estado);
    _cep = TextEditingController(text: _cliente.cep);
  }

  @override
  void dispose() {
    if (_iniciado) {
      _nome.dispose();
      _cpf.dispose();
      _telefone.dispose();
      _email.dispose();
      _rua.dispose();
      _numero.dispose();
      _complemento.dispose();
      _bairro.dispose();
      _cidade.dispose();
      _estado.dispose();
      _cep.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    _cliente.nome = _nome.text;
    _cliente.cpf = _cpf.text;
    _cliente.telefone = _telefone.text;
    _cliente.email = _email.text;
    _cliente.rua = _rua.text;
    _cliente.numero = _numero.text;
    _cliente.complemento = _complemento.text;
    _cliente.bairro = _bairro.text;
    _cliente.cidade = _cidade.text;
    _cliente.estado = _estado.text;
    _cliente.cep = _cep.text;
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
          _campo(_rua, 'Rua'),
          _campo(_numero, 'Número'),
          _campo(_complemento, 'Complemento'),
          _campo(_bairro, 'Bairro'),
          _campo(_cidade, 'Cidade'),
          _campo(_estado, 'Estado'),
          _campo(_cep, 'CEP'),
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
