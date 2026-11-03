import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../domain/constants/status.dart';
import '../../../domain/models/contrato.dart';
import '../../../domain/models/pagamento.dart';
import '../../../domain/services/contrato_service.dart';
import '../../../domain/services/pagamento_service.dart';
import '../../widgets/campo_data.dart';

class PagamentoFormScreen extends StatefulWidget {
  const PagamentoFormScreen({super.key});

  @override
  State<PagamentoFormScreen> createState() => _PagamentoFormScreenState();
}

class _PagamentoFormScreenState extends State<PagamentoFormScreen> {
  final _service = PagamentoService();
  final _contratoService = ContratoService();
  late final Pagamento _pagamento;
  late final TextEditingController _valor;
  String _vencimento = '';
  List<Contrato> _contratos = [];
  int? _contratoId;
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
    _vencimento = _pagamento.vencimento;
    _contratoId = _pagamento.contratoId;
    if (_pagamento.status == StatusPagamento.pago) {
      _status = StatusPagamento.pago;
    }
    _carregarContratos();
  }

  Future<void> _carregarContratos() async {
    final contratos = await _contratoService.findAll();
    setState(() {
      _contratos = contratos;
      _carregando = false;
    });
  }

  @override
  void dispose() {
    if (_iniciado) {
      _valor.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_contratoId == null || _vencimento.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o contrato e o vencimento')),
      );
      return;
    }
    _pagamento.contratoId = _contratoId;
    _pagamento.valor = double.tryParse(_valor.text.replaceAll(',', '.')) ?? 0;
    _pagamento.vencimento = _vencimento;
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
            initialValue: _contratoId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Contrato',
              border: OutlineInputBorder(),
            ),
            items: _contratos
                .map(
                  (contrato) => DropdownMenuItem(
                    value: contrato.id,
                    child: Text(
                      '${contrato.clienteNome} - ${contrato.planoNome}',
                    ),
                  ),
                )
                .toList(),
            onChanged: (contratoId) => setState(() => _contratoId = contratoId),
          ),
          const SizedBox(height: 12),
          _campo(
            _valor,
            'Valor (vazio usa a mensalidade do contrato)',
            numero: true,
          ),
          CampoData(
            label: 'Vencimento',
            valor: _vencimento,
            onChanged: (data) => setState(() => _vencimento = data),
          ),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: StatusPagamento.selecionaveis
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
