import 'package:flutter/material.dart';

String formatarData(String dataIso) {
  final partes = dataIso.split('-');
  if (partes.length != 3) {
    return dataIso;
  }

  return '${partes[2]}/${partes[1]}/${partes[0]}';
}

class CampoData extends StatelessWidget {
  final String label;
  final String valor;
  final ValueChanged<String> onChanged;

  const CampoData({
    super.key,
    required this.label,
    required this.valor,
    required this.onChanged,
  });

  Future<void> _selecionar(BuildContext context) async {
    final dataAtual = DateTime.tryParse(valor) ?? DateTime.now();
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataAtual,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (dataSelecionada == null) {
      return;
    }

    final dataIso = dataSelecionada.toIso8601String().substring(0, 10);
    onChanged(dataIso);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        key: ValueKey(valor),
        initialValue: formatarData(valor),
        readOnly: true,
        onTap: () => _selecionar(context),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
      ),
    );
  }
}
