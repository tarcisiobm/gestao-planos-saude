import 'package:flutter/material.dart';

enum OpcaoMenuLista { editar, excluir }

const itensMenuLista = [
  PopupMenuItem(value: OpcaoMenuLista.editar, child: Text('Editar')),
  PopupMenuItem(value: OpcaoMenuLista.excluir, child: Text('Excluir')),
];
