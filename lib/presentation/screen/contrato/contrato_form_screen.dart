import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../domain/constants/status.dart';
import '../../../domain/models/cliente.dart';
import '../../../domain/models/contrato.dart';
import '../../../domain/models/plano.dart';
import '../../../domain/services/cliente_service.dart';
import '../../../domain/services/contrato_service.dart';
import '../../../domain/services/plano_service.dart';
import '../../widgets/campo_data.dart';

class ContratoFormScreen extends StatefulWidget {
  const ContratoFormScreen({super.key});

  @override
  State<ContratoFormScreen> createState() => _ContratoFormScreenState();
}

class _ContratoFormScreenState extends State<ContratoFormScreen> {
  final _service = ContratoService();
  final _clienteService = ClienteService();
  final _planoService = PlanoService();
  late final Contrato _contrato;
  String _dataInicio = '';
  String _validade = '';
  List<Cliente> _clientes = [];
  List<Plano> _planos = [];
  int? _clienteId;
  int? _planoId;
  String _status = StatusContrato.ativo;
  bool _renovacao = false;
  bool _iniciado = false;
  bool _carregando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    _contrato = argumento is Contrato ? argumento : Contrato();
    _dataInicio = _contrato.dataInicio;
    _validade = _contrato.validade;
    _clienteId = _contrato.clienteId;
    _planoId = _contrato.planoId;
    _status = _contrato.status;
    _renovacao = _contrato.renovacaoAutomatica;
    _carregar();
  }

  Future<void> _carregar() async {
    final clientes = await _clienteService.findAll();
    final planos = await _planoService.findAll();
    setState(() {
      _clientes = clientes;
      _planos = planos;
      _carregando = false;
    });
  }

  Future<void> _salvar() async {
    if (_clienteId == null || _planoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o cliente e o plano')),
      );
      return;
    }
    if (_dataInicio.isEmpty || _validade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a data de início e a validade')),
      );
      return;
    }
    _contrato.clienteId = _clienteId;
    _contrato.planoId = _planoId;
    _contrato.dataInicio = _dataInicio;
    _contrato.validade = _validade;
    _contrato.status = _status;
    _contrato.renovacaoAutomatica = _renovacao;
    await _service.salvar(_contrato);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final editando = _contrato.id != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar contrato' : 'Novo contrato'),
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
          CampoData(
            label: 'Data de início',
            valor: _dataInicio,
            onChanged: (data) => setState(() => _dataInicio = data),
          ),
          CampoData(
            label: 'Validade',
            valor: _validade,
            onChanged: (data) => setState(() => _validade = data),
          ),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: StatusContrato.todos
                .map(
                  (status) =>
                      DropdownMenuItem(value: status, child: Text(status)),
                )
                .toList(),
            onChanged: (status) =>
                setState(() => _status = status ?? StatusContrato.ativo),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Renovação automática'),
            value: _renovacao,
            onChanged: (renovacao) => setState(() => _renovacao = renovacao),
          ),
          if (editando)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Valor mensal: R\$ ${_contrato.valorMensal.toStringAsFixed(AppConstants.casasDecimaisMoeda)}',
              ),
            ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
        ],
      ),
    );
  }
}
