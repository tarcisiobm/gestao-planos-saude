import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../domain/models/plano.dart';
import '../../../domain/services/plano_service.dart';

class PlanoFormScreen extends StatefulWidget {
  const PlanoFormScreen({super.key});

  @override
  State<PlanoFormScreen> createState() => _PlanoFormScreenState();
}

class _PlanoFormScreenState extends State<PlanoFormScreen> {
  final _service = PlanoService();
  late final Plano _plano;
  late final TextEditingController _nome;
  late final TextEditingController _tipoCobertura;
  late final TextEditingController _valor;
  late final TextEditingController _valorDependente;
  late final TextEditingController _vigencia;
  late final TextEditingController _formaPagamento;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    _plano = argumento is Plano ? argumento : Plano();
    _nome = TextEditingController(text: _plano.nome);
    _tipoCobertura = TextEditingController(text: _plano.tipoCobertura);
    _valor = TextEditingController(
      text: _plano.id == null
          ? ''
          : _plano.valor.toStringAsFixed(AppConstants.casasDecimaisMoeda),
    );
    _valorDependente = TextEditingController(
      text: _plano.id == null
          ? ''
          : _plano.valorDependente.toStringAsFixed(
              AppConstants.casasDecimaisMoeda,
            ),
    );
    _vigencia = TextEditingController(text: _plano.vigencia);
    _formaPagamento = TextEditingController(text: _plano.formaPagamento);
  }

  @override
  void dispose() {
    if (_iniciado) {
      _nome.dispose();
      _tipoCobertura.dispose();
      _valor.dispose();
      _valorDependente.dispose();
      _vigencia.dispose();
      _formaPagamento.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    _plano.nome = _nome.text;
    _plano.tipoCobertura = _tipoCobertura.text;
    _plano.valor = double.tryParse(_valor.text.replaceAll(',', '.')) ?? 0;
    _plano.valorDependente =
        double.tryParse(_valorDependente.text.replaceAll(',', '.')) ?? 0;
    _plano.vigencia = _vigencia.text;
    _plano.formaPagamento = _formaPagamento.text;
    await _service.salvar(_plano);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = _plano.id != null;
    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar plano' : 'Novo plano')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _campo(_nome, 'Nome'),
          _campo(_tipoCobertura, 'Tipo de cobertura'),
          _campo(_valor, 'Valor', numero: true),
          _campo(_valorDependente, 'Valor por dependente', numero: true),
          _campo(_vigencia, 'Vigência'),
          _campo(_formaPagamento, 'Forma de pagamento'),
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
