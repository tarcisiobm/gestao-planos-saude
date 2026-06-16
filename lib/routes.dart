import 'package:flutter/material.dart';

import 'presentation/screen/cliente/cliente_form_screen.dart';
import 'presentation/screen/cliente/cliente_list_screen.dart';
import 'presentation/screen/home_screen.dart';
import 'presentation/screen/login_screen.dart';
import 'presentation/screen/placeholder_screen.dart';
import 'presentation/screen/plano/plano_form_screen.dart';
import 'presentation/screen/plano/plano_list_screen.dart';
import 'presentation/screen/prestador/prestador_form_screen.dart';
import 'presentation/screen/prestador/prestador_list_screen.dart';
import 'presentation/screen/register_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String clientes = '/clientes';
  static const String clienteForm = '/clientes/form';
  static const String planos = '/planos';
  static const String planoForm = '/planos/form';
  static const String prestadores = '/prestadores';
  static const String prestadorForm = '/prestadores/form';
  static const String dependentes = '/dependentes';
  static const String contratos = '/contratos';
  static const String pagamentos = '/pagamentos';
  static const String coberturas = '/coberturas';
  static const String relatorios = '/relatorios';
  static const String simulacao = '/simulacao';

  static final Map<String, WidgetBuilder> routes = {
    home: (_) => const HomeScreen(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    clientes: (_) => const ClienteListScreen(),
    clienteForm: (_) => const ClienteFormScreen(),
    planos: (_) => const PlanoListScreen(),
    planoForm: (_) => const PlanoFormScreen(),
    prestadores: (_) => const PrestadorListScreen(),
    prestadorForm: (_) => const PrestadorFormScreen(),
    dependentes: (_) => const PlaceholderScreen(titulo: 'Dependentes'),
    contratos: (_) => const PlaceholderScreen(titulo: 'Contratos'),
    pagamentos: (_) => const PlaceholderScreen(titulo: 'Pagamentos'),
    coberturas: (_) => const PlaceholderScreen(titulo: 'Coberturas'),
    relatorios: (_) => const PlaceholderScreen(titulo: 'Relatorios'),
    simulacao: (_) => const PlaceholderScreen(titulo: 'Simulacao'),
  };
}
