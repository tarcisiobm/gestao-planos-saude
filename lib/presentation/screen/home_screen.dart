import 'package:flutter/material.dart';

import '../../app_constants.dart';
import '../../routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itens = <_ItemMenu>[
      _ItemMenu('Clientes', Icons.people, AppRoutes.clientes),
      _ItemMenu('Dependentes', Icons.family_restroom, AppRoutes.dependentes),
      _ItemMenu('Planos', Icons.assignment, AppRoutes.planos),
      _ItemMenu('Prestadores', Icons.local_hospital, AppRoutes.prestadores),
      _ItemMenu('Coberturas', Icons.link, AppRoutes.coberturas),
      _ItemMenu('Contratos', Icons.description, AppRoutes.contratos),
      _ItemMenu('Pagamentos', Icons.payments, AppRoutes.pagamentos),
      _ItemMenu('Simulacao', Icons.calculate, AppRoutes.simulacao),
      _ItemMenu('Relatorios', Icons.bar_chart, AppRoutes.relatorios),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.nomeApp),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.teal,
                child: Icon(Icons.health_and_safety, color: Colors.white),
              ),
              title: Text(
                'Menu principal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Protótipo de navegacao dos modulos do sistema'),
            ),
          ),
          const SizedBox(height: 4),
          for (final item in itens)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade50,
                  child: Icon(item.icone, color: Colors.teal),
                ),
                title: Text(item.titulo),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, item.rota),
              ),
            ),
        ],
      ),
    );
  }
}

class _ItemMenu {
  final String titulo;
  final IconData icone;
  final String rota;

  const _ItemMenu(this.titulo, this.icone, this.rota);
}
