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

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              itemCount: _contratos.length,
              itemBuilder: (context, indice) {
                final contrato = _contratos[indice];
                return ListTile(
                  title: Text(contrato.clienteNome),
                  subtitle: Text(
                    'Plano ${contrato.planoNome} — ${contrato.status}',
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
                );
              },
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
