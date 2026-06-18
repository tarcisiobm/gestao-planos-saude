import 'package:flutter/material.dart';

import '../../../domain/models/contrato.dart';
import '../../../domain/services/contrato_service.dart';
import '../../constants/opcoes_menu_lista.dart';
import '../../../routes.dart';

class ContratoListScreen extends StatefulWidget {
  const ContratoListScreen({super.key});

  @override
  State<ContratoListScreen> createState() => _ContratoListScreenState();
}

class _ContratoListScreenState extends State<ContratoListScreen> {
  final _service = ContratoService();
  List<Contrato> _contratos = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar([String busca = '']) async {
    final contratos = busca.isEmpty
        ? await _service.findAll()
        : await _service.buscar(busca);
    setState(() => _contratos = contratos);
  }

  Future<void> _abrirForm([Contrato? contrato]) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.contratoForm,
      arguments: contrato,
    );
    _carregar();
  }

  Future<void> _confirmarExclusao(Contrato contrato) async {
    final confirmouExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text('Excluir o contrato de ${contrato.clienteNome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmouExclusao == true) {
      await _service.excluir(contrato.id!);
      _carregar();
    }
  }

  Map<String, List<Contrato>> _agruparPorCliente() {
    final grupos = <String, List<Contrato>>{};
    for (final contrato in _contratos) {
      grupos.putIfAbsent(contrato.clienteNome, () => []).add(contrato);
    }
    return grupos;
  }

  @override
  Widget build(BuildContext context) {
    final contratosPorCliente = _agruparPorCliente();
    return Scaffold(
      appBar: AppBar(title: const Text('Contratos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por cliente',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (busca) => _carregar(busca),
            ),
          ),
          Expanded(
            child: _contratos.isEmpty
                ? const Center(child: Text('Nenhum contrato cadastrado'))
                : ListView(
                    children: [
                      for (final grupo in contratosPorCliente.entries) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                          child: Text(
                            grupo.key,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        for (final contrato in grupo.value)
                          ListTile(
                            title: Text(contrato.planoNome),
                            subtitle: Text(
                              '${contrato.status} - início ${contrato.dataInicio}',
                            ),
                            onTap: () => _abrirForm(contrato),
                            trailing: PopupMenuButton<OpcaoMenuLista>(
                              onSelected: (opcao) {
                                if (opcao == OpcaoMenuLista.editar) {
                                  _abrirForm(contrato);
                                }
                                if (opcao == OpcaoMenuLista.excluir) {
                                  _confirmarExclusao(contrato);
                                }
                              },
                              itemBuilder: (_) => itensMenuLista,
                            ),
                          ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
