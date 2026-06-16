import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../domain/models/pagamento.dart';
import '../../../domain/services/pagamento_service.dart';
import '../../constants/opcoes_menu_lista.dart';
import '../../../routes.dart';

class PagamentoListScreen extends StatefulWidget {
  const PagamentoListScreen({super.key});

  @override
  State<PagamentoListScreen> createState() => _PagamentoListScreenState();
}

class _PagamentoListScreenState extends State<PagamentoListScreen> {
  final _service = PagamentoService();
  List<Pagamento> _pagamentos = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar([String busca = '']) async {
    final pagamentos = busca.isEmpty
        ? await _service.findAll()
        : await _service.buscar(busca);
    setState(() => _pagamentos = pagamentos);
  }

  Future<void> _abrirForm([Pagamento? pagamento]) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.pagamentoForm,
      arguments: pagamento,
    );
    _carregar();
  }

  Future<void> _confirmarExclusao(Pagamento pagamento) async {
    final confirmouExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text('Excluir o pagamento de ${pagamento.clienteNome}?'),
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
      await _service.excluir(pagamento.id!);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamentos')),
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
              itemCount: _pagamentos.length,
              itemBuilder: (context, indice) {
                final pagamento = _pagamentos[indice];
                return ListTile(
                  title: Text(pagamento.clienteNome),
                  subtitle: Text(
                    'R\$ ${pagamento.valor.toStringAsFixed(AppConstants.casasDecimaisMoeda)} — ${pagamento.status} (vence ${pagamento.vencimento})',
                  ),
                  onTap: () => _abrirForm(pagamento),
                  trailing: PopupMenuButton<OpcaoMenuLista>(
                    onSelected: (opcao) {
                      if (opcao == OpcaoMenuLista.editar) {
                        _abrirForm(pagamento);
                      }
                      if (opcao == OpcaoMenuLista.excluir) {
                        _confirmarExclusao(pagamento);
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
