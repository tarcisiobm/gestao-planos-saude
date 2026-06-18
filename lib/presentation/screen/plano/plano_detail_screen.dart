import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../domain/models/faixa_valor.dart';
import '../../../domain/models/plano.dart';
import '../../../domain/models/servico.dart';
import '../../../domain/services/faixa_valor_service.dart';
import '../../../domain/services/servico_service.dart';
import '../../constants/opcoes_menu_lista.dart';
import '../../../routes.dart';

class PlanoDetailScreen extends StatefulWidget {
  const PlanoDetailScreen({super.key});

  @override
  State<PlanoDetailScreen> createState() => _PlanoDetailScreenState();
}

class _PlanoDetailScreenState extends State<PlanoDetailScreen> {
  final _servicoService = ServicoService();
  final _faixaValorService = FaixaValorService();
  late final Plano _plano;
  List<Servico> _servicos = [];
  List<FaixaValor> _faixas = [];
  bool _iniciado = false;
  bool _carregando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    _plano = argumento as Plano;
    _carregar();
  }

  Future<void> _carregar() async {
    final servicos = await _servicoService.buscarPorPlano(_plano.id!);
    final faixas = await _faixaValorService.buscarPorPlano(_plano.id!);
    if (!mounted) return;
    setState(() {
      _servicos = servicos;
      _faixas = faixas;
      _carregando = false;
    });
  }

  Future<void> _editarPlano() async {
    await Navigator.pushNamed(context, AppRoutes.planoForm, arguments: _plano);
    if (!mounted) return;
    setState(() => _carregando = true);
    await _carregar();
  }

  Future<void> _abrirServico([Servico? servico]) async {
    await Navigator.pushNamed(
      context,
      AppRoutes.servicoForm,
      arguments: servico ?? Servico(planoId: _plano.id),
    );
    if (!mounted) return;
    setState(() => _carregando = true);
    await _carregar();
  }

  Future<void> _confirmarExclusaoServico(Servico servico) async {
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
      await _servicoService.excluir(servico.id!);
      await _carregar();
    }
  }

  Future<void> _abrirFaixa([FaixaValor? faixa]) async {
    final faixaEditada =
        faixa ?? FaixaValor(planoId: _plano.id, idadeMin: 0, idadeMax: 18);
    final idadeMin = TextEditingController(
      text: faixa == null ? '' : '${faixaEditada.idadeMin}',
    );
    final idadeMax = TextEditingController(
      text: faixa == null ? '' : '${faixaEditada.idadeMax}',
    );
    final valor = TextEditingController(
      text: faixa == null
          ? ''
          : faixaEditada.valor.toStringAsFixed(AppConstants.casasDecimaisMoeda),
    );

    try {
      final salvou = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(faixa == null ? 'Nova faixa' : 'Editar faixa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _campoDialog(idadeMin, 'Idade mínima', numero: true),
              _campoDialog(idadeMax, 'Idade máxima', numero: true),
              _campoDialog(valor, 'Valor', numero: true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salvar'),
            ),
          ],
        ),
      );
      if (salvou != true) return;

      faixaEditada.planoId = _plano.id;
      faixaEditada.idadeMin = int.tryParse(idadeMin.text) ?? 0;
      faixaEditada.idadeMax = int.tryParse(idadeMax.text) ?? 0;
      faixaEditada.valor =
          double.tryParse(valor.text.replaceAll(',', '.')) ?? 0;
      await _faixaValorService.salvar(faixaEditada);
      await _carregar();
    } finally {
      idadeMin.dispose();
      idadeMax.dispose();
      valor.dispose();
    }
  }

  Future<void> _confirmarExclusaoFaixa(FaixaValor faixa) async {
    final confirmouExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir?'),
        content: Text('Excluir a faixa ${_textoFaixa(faixa)}?'),
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
      await _faixaValorService.excluir(faixa.id!);
      await _carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_plano.nome),
        actions: [
          PopupMenuButton<String>(
            onSelected: (_) => _editarPlano(),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'editar', child: Text('Editar plano')),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(_plano.tipoCobertura),
            subtitle: Text(
              'Mensalidade base: R\$ ${_plano.valor.toStringAsFixed(AppConstants.casasDecimaisMoeda)}\n'
              'Dependente: R\$ ${_plano.valorDependente.toStringAsFixed(AppConstants.casasDecimaisMoeda)}\n'
              '${_plano.vigencia} · ${_plano.formaPagamento}',
            ),
          ),
          const Divider(height: 1),
          _tituloSecao('Serviços', () => _abrirServico()),
          if (_servicos.isEmpty)
            const ListTile(title: Text('Nenhum serviço cadastrado')),
          for (final servico in _servicos)
            ListTile(
              title: Text(servico.nome),
              subtitle: Text(servico.prestadorNome),
              onTap: () => _abrirServico(servico),
              trailing: PopupMenuButton<OpcaoMenuLista>(
                onSelected: (opcao) {
                  if (opcao == OpcaoMenuLista.editar) {
                    _abrirServico(servico);
                  }
                  if (opcao == OpcaoMenuLista.excluir) {
                    _confirmarExclusaoServico(servico);
                  }
                },
                itemBuilder: (_) => itensMenuLista,
              ),
            ),
          const Divider(height: 1),
          _tituloSecao('Faixas de valor', () => _abrirFaixa()),
          if (_faixas.isEmpty)
            const ListTile(title: Text('Nenhuma faixa cadastrada')),
          for (final faixa in _faixas)
            ListTile(
              title: Text(_textoFaixa(faixa)),
              subtitle: Text(
                'R\$ ${faixa.valor.toStringAsFixed(AppConstants.casasDecimaisMoeda)}',
              ),
              onTap: () => _abrirFaixa(faixa),
              trailing: PopupMenuButton<OpcaoMenuLista>(
                onSelected: (opcao) {
                  if (opcao == OpcaoMenuLista.editar) {
                    _abrirFaixa(faixa);
                  }
                  if (opcao == OpcaoMenuLista.excluir) {
                    _confirmarExclusaoFaixa(faixa);
                  }
                },
                itemBuilder: (_) => itensMenuLista,
              ),
            ),
        ],
      ),
    );
  }

  Widget _tituloSecao(String titulo, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: onAdd,
            tooltip: 'Adicionar',
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _campoDialog(
    TextEditingController controller,
    String label, {
    bool numero = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: numero ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  String _textoFaixa(FaixaValor faixa) {
    if (faixa.idadeMax >= 120) return '${faixa.idadeMin}+ anos';
    return '${faixa.idadeMin} a ${faixa.idadeMax} anos';
  }
}
