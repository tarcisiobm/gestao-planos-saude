import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../domain/models/plano.dart';
import '../../../domain/services/plano_service.dart';
import '../../constants/opcoes_menu_lista.dart';
import '../../../routes.dart';

class PlanoListScreen extends StatefulWidget {
  const PlanoListScreen({super.key});

  @override
  State<PlanoListScreen> createState() => _PlanoListScreenState();
}

class _PlanoListScreenState extends State<PlanoListScreen> {
  final _service = PlanoService();
  List<Plano> _planos = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar([String busca = '']) async {
    final planos = busca.isEmpty
        ? await _service.findAll()
        : await _service.buscar(busca);
    setState(() => _planos = planos);
  }

  Future<void> _abrirForm([Plano? plano]) async {
    await Navigator.pushNamed(context, AppRoutes.planoForm, arguments: plano);
    _carregar();
  }

  Future<void> _abrirDetalhe(Plano plano) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.planoDetalhe,
      arguments: plano,
    );
    _carregar();
  }

  Future<void> _confirmarExclusao(Plano plano) async {
    final confirmouExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text('Excluir ${plano.nome}?'),
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
      await _service.excluir(plano.id!);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planos')),
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
              itemCount: _planos.length,
              itemBuilder: (context, indice) {
                final plano = _planos[indice];
                return ListTile(
                  isThreeLine: true,
                  title: Text(plano.nome),
                  subtitle: Text(
                    'Mensalidade: R\$ ${plano.valor.toStringAsFixed(AppConstants.casasDecimaisMoeda)}\n'
                    'Dependente: R\$ ${plano.valorDependente.toStringAsFixed(AppConstants.casasDecimaisMoeda)} - ${plano.tipoCobertura}',
                  ),
                  onTap: () => _abrirDetalhe(plano),
                  trailing: PopupMenuButton<OpcaoMenuLista>(
                    onSelected: (opcao) {
                      if (opcao == OpcaoMenuLista.editar) {
                        _abrirForm(plano);
                      }
                      if (opcao == OpcaoMenuLista.excluir) {
                        _confirmarExclusao(plano);
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
