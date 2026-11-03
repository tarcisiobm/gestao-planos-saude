import 'package:flutter/material.dart';

import '../../../domain/models/atendimento.dart';
import '../../../domain/models/cliente.dart';
import '../../../domain/models/dependente.dart';
import '../../../domain/models/servico.dart';
import '../../../domain/services/atendimento_service.dart';
import '../../../domain/services/cliente_service.dart';
import '../../../domain/services/dependente_service.dart';
import '../../../domain/services/servico_service.dart';
import '../../widgets/campo_data.dart';

class AtendimentoFormScreen extends StatefulWidget {
  const AtendimentoFormScreen({super.key});

  @override
  State<AtendimentoFormScreen> createState() => _AtendimentoFormScreenState();
}

class _AtendimentoFormScreenState extends State<AtendimentoFormScreen> {
  final _service = AtendimentoService();
  final _clienteService = ClienteService();
  final _dependenteService = DependenteService();
  final _servicoService = ServicoService();
  late final Atendimento _atendimento;
  String _data = '';
  late final TextEditingController _horario;
  late final TextEditingController _descricao;
  List<Cliente> _clientes = [];
  List<Dependente> _dependentes = [];
  List<Servico> _servicos = [];
  int? _clienteId;
  int? _dependenteId;
  int? _servicoId;
  bool _iniciado = false;
  bool _carregando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    _atendimento = argumento is Atendimento ? argumento : Atendimento();
    _data = _atendimento.data;
    _horario = TextEditingController(text: _atendimento.horario);
    _descricao = TextEditingController(text: _atendimento.descricao);
    _clienteId = _atendimento.clienteId;
    _dependenteId = _atendimento.dependenteId;
    _servicoId = _atendimento.servicoId;
    _carregar();
  }

  Future<void> _carregar() async {
    final clientes = await _clienteService.findAll();
    final dependentes = await _dependenteService.findAll();
    final servicos = await _servicoService.findAll();
    if (!mounted) return;
    setState(() {
      _clientes = clientes;
      _dependentes = dependentes;
      _servicos = servicos;
      _carregando = false;
    });
  }

  @override
  void dispose() {
    if (_iniciado) {
      _horario.dispose();
      _descricao.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_clienteId == null || _servicoId == null || _data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione o cliente, o serviço e a data'),
        ),
      );
      return;
    }
    _atendimento.clienteId = _clienteId;
    _atendimento.dependenteId = _dependenteId;
    _atendimento.servicoId = _servicoId;
    _atendimento.data = _data;
    _atendimento.horario = _horario.text;
    _atendimento.descricao = _descricao.text;
    await _service.salvar(_atendimento);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final editando = _atendimento.id != null;
    final dependentesDoCliente = _dependentes
        .where((dependente) => dependente.clienteId == _clienteId)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar atendimento' : 'Novo atendimento'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            isExpanded: true,
            initialValue: _clienteId,
            decoration: const InputDecoration(
              labelText: 'Cliente',
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
            onChanged: (clienteId) => setState(() {
              _clienteId = clienteId;
              _dependenteId = null;
            }),
          ),
          const SizedBox(height: 12),
          if (dependentesDoCliente.isNotEmpty) ...[
            DropdownButtonFormField<int?>(
              key: ValueKey(_clienteId),
              isExpanded: true,
              initialValue: _dependenteId,
              hint: const Text('Titular'),
              decoration: const InputDecoration(
                labelText: 'Paciente',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Titular')),
                for (final dependente in dependentesDoCliente)
                  DropdownMenuItem(
                    value: dependente.id,
                    child: Text(
                      '${dependente.nome} (${dependente.parentesco})',
                    ),
                  ),
              ],
              onChanged: (dependenteId) =>
                  setState(() => _dependenteId = dependenteId),
            ),
            const SizedBox(height: 12),
          ],
          DropdownButtonFormField<int>(
            isExpanded: true,
            initialValue: _servicoId,
            decoration: const InputDecoration(
              labelText: 'Serviço',
              border: OutlineInputBorder(),
            ),
            items: _servicos
                .map(
                  (servico) => DropdownMenuItem(
                    value: servico.id,
                    child: Text(
                      '${servico.nome} - ${servico.planoNome}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (servicoId) => setState(() => _servicoId = servicoId),
          ),
          const SizedBox(height: 12),
          CampoData(
            label: 'Data',
            valor: _data,
            onChanged: (data) => setState(() => _data = data),
          ),
          _campo(_horario, 'Horário'),
          TextField(
            controller: _descricao,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
            ),
          ),
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
