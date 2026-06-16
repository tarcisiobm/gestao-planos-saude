import 'package:flutter/material.dart';

import '../../../domain/models/prestador.dart';
import '../../../domain/services/prestador_service.dart';
import '../../constants/opcoes_menu_lista.dart';
import '../../../routes.dart';

class PrestadorListScreen extends StatefulWidget {
  const PrestadorListScreen({super.key});

  @override
  State<PrestadorListScreen> createState() => _PrestadorListScreenState();
}

class _PrestadorListScreenState extends State<PrestadorListScreen> {
  final _service = PrestadorService();
  List<Prestador> _prestadores = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar([String busca = '']) async {
    final prestadores = busca.isEmpty
        ? await _service.findAll()
        : await _service.buscar(busca);
    setState(() => _prestadores = prestadores);
  }

  Future<void> _abrirForm([Prestador? prestador]) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.prestadorForm,
      arguments: prestador,
    );
    _carregar();
  }

  Future<void> _confirmarExclusao(Prestador prestador) async {
    final confirmouExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text('Excluir ${prestador.nome}?'),
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
      await _service.excluir(prestador.id!);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prestadores')),
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
              itemCount: _prestadores.length,
              itemBuilder: (context, indice) {
                final prestador = _prestadores[indice];
                return ListTile(
                  title: Text(prestador.nome),
                  subtitle: Text(
                    '${prestador.tipo} — ${prestador.especialidade}',
                  ),
                  onTap: () => _abrirForm(prestador),
                  trailing: PopupMenuButton<OpcaoMenuLista>(
                    onSelected: (opcao) {
                      if (opcao == OpcaoMenuLista.editar) {
                        _abrirForm(prestador);
                      }
                      if (opcao == OpcaoMenuLista.excluir) {
                        _confirmarExclusao(prestador);
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
