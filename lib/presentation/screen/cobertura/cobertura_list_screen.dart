import 'package:flutter/material.dart';

import '../../../domain/models/cobertura.dart';
import '../../../domain/services/cobertura_service.dart';
import '../../constants/opcoes_menu_lista.dart';
import '../../../routes.dart';

class CoberturaListScreen extends StatefulWidget {
  const CoberturaListScreen({super.key});

  @override
  State<CoberturaListScreen> createState() => _CoberturaListScreenState();
}

class _CoberturaListScreenState extends State<CoberturaListScreen> {
  final _service = CoberturaService();
  List<Cobertura> _coberturas = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar([String busca = '']) async {
    final coberturas = busca.isEmpty
        ? await _service.findAll()
        : await _service.buscar(busca);
    setState(() => _coberturas = coberturas);
  }

  Future<void> _abrirForm([Cobertura? cobertura]) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.coberturaForm,
      arguments: cobertura,
    );
    _carregar();
  }

  Future<void> _confirmarExclusao(Cobertura cobertura) async {
    final confirmouExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text(
          'Excluir a cobertura ${cobertura.planoNome} / ${cobertura.prestadorNome}?',
        ),
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
      await _service.excluir(cobertura.id!);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coberturas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por plano',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (busca) => _carregar(busca),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _coberturas.length,
              itemBuilder: (context, indice) {
                final cobertura = _coberturas[indice];
                return ListTile(
                  title: Text(cobertura.planoNome),
                  subtitle: Text('Prestador: ${cobertura.prestadorNome}'),
                  onTap: () => _abrirForm(cobertura),
                  trailing: PopupMenuButton<OpcaoMenuLista>(
                    onSelected: (opcao) {
                      if (opcao == OpcaoMenuLista.editar) {
                        _abrirForm(cobertura);
                      }
                      if (opcao == OpcaoMenuLista.excluir) {
                        _confirmarExclusao(cobertura);
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
