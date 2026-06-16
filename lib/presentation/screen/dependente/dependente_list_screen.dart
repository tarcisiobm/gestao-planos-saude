import 'package:flutter/material.dart';

import '../../../domain/models/dependente.dart';
import '../../../domain/services/dependente_service.dart';
import '../../constants/opcoes_menu_lista.dart';
import '../../../routes.dart';

class DependenteListScreen extends StatefulWidget {
  const DependenteListScreen({super.key});

  @override
  State<DependenteListScreen> createState() => _DependenteListScreenState();
}

class _DependenteListScreenState extends State<DependenteListScreen> {
  final _service = DependenteService();
  List<Dependente> _dependentes = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar([String busca = '']) async {
    final dependentes = busca.isEmpty
        ? await _service.findAll()
        : await _service.buscar(busca);
    setState(() => _dependentes = dependentes);
  }

  Future<void> _abrirForm([Dependente? dependente]) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.dependenteForm,
      arguments: dependente,
    );
    _carregar();
  }

  Future<void> _confirmarExclusao(Dependente dependente) async {
    final confirmouExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text('Excluir ${dependente.nome}?'),
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
      await _service.excluir(dependente.id!);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dependentes')),
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
              itemCount: _dependentes.length,
              itemBuilder: (context, indice) {
                final dependente = _dependentes[indice];
                return ListTile(
                  title: Text(dependente.nome),
                  subtitle: Text(
                    '${dependente.parentesco} — titular: ${dependente.clienteNome}',
                  ),
                  onTap: () => _abrirForm(dependente),
                  trailing: PopupMenuButton<OpcaoMenuLista>(
                    onSelected: (opcao) {
                      if (opcao == OpcaoMenuLista.editar) {
                        _abrirForm(dependente);
                      }
                      if (opcao == OpcaoMenuLista.excluir) {
                        _confirmarExclusao(dependente);
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
