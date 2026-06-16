import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../domain/constants/status.dart';
import '../../../domain/models/cliente.dart';
import '../../../domain/models/pagamento.dart';
import '../../../domain/services/cliente_service.dart';
import '../../../domain/services/pagamento_service.dart';

class PagamentoFormScreen extends StatefulWidget {
  const PagamentoFormScreen({super.key});

  @override
  State<PagamentoFormScreen> createState() => _PagamentoFormScreenState();
}

class _PagamentoFormScreenState extends State<PagamentoFormScreen> {
  final _service = PagamentoService();
  final _clienteService = ClienteService();
  late final Pagamento _pagamento;
  late final TextEditingController _valor;
  late final TextEditingController _vencimento;
  List<Cliente> _clientes = [];
  int? _clienteId;
  String _status = StatusPagamento.pendente;
  bool _iniciado = false;
  bool _carregando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    _pagamento = argumento is Pagamento ? argumento : Pagamento();
    _valor = TextEditingController(
      text: _pagamento.id == null
          ? ''
          : _pagamento.valor.toStringAsFixed(AppConstants.casasDecimaisMoeda),
    );
    _vencimento = TextEditingController(text: _pagamento.vencimento);
    _clienteId = _pagamento.clienteId;
    _status = _pagamento.status;
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
      _valor.dispose();
      _vencimento.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_clienteId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione o cliente')));
      return;
    }
    _pagamento.clienteId = _clienteId;
    _pagamento.valor = double.tryParse(_valor.text.replaceAll(',', '.')) ?? 0;
    _pagamento.vencimento = _vencimento.text;
    _pagamento.status = _status;
    await _service.salvar(_pagamento);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final editando = _pagamento.id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar pagamento' : 'Novo pagamento'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
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
            onChanged: (clienteId) => setState(() => _clienteId = clienteId),
          ),
          const SizedBox(height: 12),
          _campo(_valor, 'Valor', numero: true),
          _campo(_vencimento, 'Vencimento'),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: StatusPagamento.todos
                .map(
                  (status) =>
                      DropdownMenuItem(value: status, child: Text(status)),
                )
                .toList(),
            onChanged: (status) =>
                setState(() => _status = status ?? StatusPagamento.pendente),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
        ],
      ),
    );
  }

  Widget _campo(
    TextEditingController controller,
    String label, {
    bool numero = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: numero ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
