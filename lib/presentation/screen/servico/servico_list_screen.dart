import 'package:flutter/material.dart';

import '../../../domain/models/servico.dart';
import '../../../domain/services/servico_service.dart';
import '../../constants/opcoes_menu_lista.dart';
import '../../../routes.dart';

class ServicoListScreen extends StatefulWidget {
  const ServicoListScreen({super.key});

  @override
  State<ServicoListScreen> createState() => _ServicoListScreenState();
}

class _ServicoListScreenState extends State<ServicoListScreen> {
  final _service = ServicoService();
  List<Servico> _servicos = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar([String busca = '']) async {
    final servicos = busca.isEmpty
        ? await _service.findAll()
        : await _service.buscar(busca);
    setState(() => _servicos = servicos);
  }

  Future<void> _abrirForm([Servico? servico]) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.servicoForm,
      arguments: servico,
    );
    _carregar();
  }

  Future<void> _confirmarExclusao(Servico servico) async {
    final confirmouExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text('Excluir o serviço ${servico.nome}?'),
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
      await _service.excluir(servico.id!);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Serviços')),
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
              itemCount: _servicos.length,
              itemBuilder: (context, indice) {
                final servico = _servicos[indice];
                return ListTile(
                  title: Text(servico.nome),
                  subtitle: Text(
                    '${servico.planoNome} · ${servico.prestadorNome}',
                  ),
                  onTap: () => _abrirForm(servico),
                  trailing: PopupMenuButton<OpcaoMenuLista>(
                    onSelected: (opcao) {
                      if (opcao == OpcaoMenuLista.editar) {
                        _abrirForm(servico);
                      }
                      if (opcao == OpcaoMenuLista.excluir) {
                        _confirmarExclusao(servico);
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
