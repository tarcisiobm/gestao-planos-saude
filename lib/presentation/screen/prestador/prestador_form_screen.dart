import 'package:flutter/material.dart';

import '../../../domain/models/prestador.dart';
import '../../../domain/services/prestador_service.dart';

class PrestadorFormScreen extends StatefulWidget {
  const PrestadorFormScreen({super.key});

  @override
  State<PrestadorFormScreen> createState() => _PrestadorFormScreenState();
}

class _PrestadorFormScreenState extends State<PrestadorFormScreen> {
  final _service = PrestadorService();
  late final Prestador _prestador;
  late final TextEditingController _nome;
  late final TextEditingController _tipo;
  late final TextEditingController _especialidade;
  late final TextEditingController _localizacao;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    _prestador = argumento is Prestador ? argumento : Prestador();
    _nome = TextEditingController(text: _prestador.nome);
    _tipo = TextEditingController(text: _prestador.tipo);
    _especialidade = TextEditingController(text: _prestador.especialidade);
    _localizacao = TextEditingController(text: _prestador.localizacao);
  }

  @override
  void dispose() {
    if (_iniciado) {
      _nome.dispose();
      _tipo.dispose();
      _especialidade.dispose();
      _localizacao.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    _prestador.nome = _nome.text;
    _prestador.tipo = _tipo.text;
    _prestador.especialidade = _especialidade.text;
    _prestador.localizacao = _localizacao.text;
    await _service.salvar(_prestador);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = _prestador.id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar prestador' : 'Novo prestador'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _campo(_nome, 'Nome'),
          _campo(_tipo, 'Tipo (hospital, clínica, laboratório)'),
          _campo(_especialidade, 'Especialidade'),
          _campo(_localizacao, 'Localização'),
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
