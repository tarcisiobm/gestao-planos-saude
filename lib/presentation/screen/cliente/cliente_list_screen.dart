import 'package:flutter/material.dart';

import '../../../domain/models/cliente.dart';
import '../../../domain/services/cliente_service.dart';
import '../../constants/opcoes_menu_lista.dart';
import '../../../routes.dart';

class ClienteListScreen extends StatefulWidget {
  const ClienteListScreen({super.key});

  @override
  State<ClienteListScreen> createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  final _service = ClienteService();
  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar([String busca = '']) async {
    final clientes = busca.isEmpty
        ? await _service.findAll()
        : await _service.buscar(busca);
    setState(() => _clientes = clientes);
  }

  Future<void> _abrirForm([Cliente? cliente]) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.clienteForm,
      arguments: cliente,
    );
    _carregar();
  }

  Future<void> _confirmarExclusao(Cliente cliente) async {
    final confirmouExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text('Excluir ${cliente.nome}?'),
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
      await _service.excluir(cliente.id!);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (busca) => _carregar(busca),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _clientes.length,
              itemBuilder: (context, indice) {
                final cliente = _clientes[indice];
                return ListTile(
                  title: Text(cliente.nome),
                  subtitle: Text(cliente.cpf),
                  onTap: () => _abrirForm(cliente),
                  trailing: PopupMenuButton<OpcaoMenuLista>(
                    onSelected: (opcao) {
                      if (opcao == OpcaoMenuLista.editar) {
                        _abrirForm(cliente);
                      }
                      if (opcao == OpcaoMenuLista.excluir) {
                        _confirmarExclusao(cliente);
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
