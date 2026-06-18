import 'package:flutter/material.dart';

import '../../../domain/models/atendimento.dart';
import '../../../domain/models/cliente.dart';
import '../../../domain/services/atendimento_service.dart';
import '../../../domain/services/cliente_service.dart';
import '../../constants/opcoes_menu_lista.dart';
import '../../../routes.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  final _service = AtendimentoService();
  final _clienteService = ClienteService();
  List<Atendimento> _atendimentos = [];
  List<Cliente> _clientes = [];
  int? _clienteFiltroId;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final clientes = await _clienteService.findAll();
    final atendimentos = _clienteFiltroId == null
        ? await _service.findAll()
        : await _service.buscarPorCliente(_clienteFiltroId!);
    if (!mounted) return;
    setState(() {
      _clientes = clientes;
      _atendimentos = atendimentos;
      _carregando = false;
    });
  }

  Future<void> _selecionarCliente(int? clienteId) async {
    setState(() {
      _clienteFiltroId = clienteId;
      _carregando = true;
    });
    await _carregar();
  }

  Future<void> _abrirForm([Atendimento? atendimento]) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.atendimentoForm,
      arguments: atendimento ?? Atendimento(clienteId: _clienteFiltroId),
    );
    _carregar();
  }

  Future<void> _confirmarExclusao(Atendimento atendimento) async {
    final confirmouExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text('Excluir o atendimento de ${atendimento.clienteNome}?'),
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
      await _service.excluir(atendimento.id!);
      _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _clienteFiltroId,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por cliente',
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
                    onChanged: _selecionarCliente,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  onPressed: _clienteFiltroId == null
                      ? null
                      : () => _selecionarCliente(null),
                  tooltip: 'Mostrar todos',
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
          ),
          Expanded(
            child: _atendimentos.isEmpty
                ? const Center(child: Text('Nenhum atendimento cadastrado'))
                : ListView.builder(
                    itemCount: _atendimentos.length,
                    itemBuilder: (context, indice) {
                      final atendimento = _atendimentos[indice];
                      return ListTile(
                        isThreeLine: true,
                        title: Text(atendimento.clienteNome),
                        subtitle: Text(
                          '${atendimento.data} ${atendimento.horario} - ${atendimento.servicoNome}\n'
                          '${atendimento.planoNome} · ${atendimento.prestadorNome}\n'
                          '${atendimento.descricao}',
                        ),
                        onTap: () => _abrirForm(atendimento),
                        trailing: PopupMenuButton<OpcaoMenuLista>(
                          onSelected: (opcao) {
                            if (opcao == OpcaoMenuLista.editar) {
                              _abrirForm(atendimento);
                            }
                            if (opcao == OpcaoMenuLista.excluir) {
                              _confirmarExclusao(atendimento);
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
