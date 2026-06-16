import 'package:flutter/material.dart';

import 'presentation/screen/cliente/cliente_form_screen.dart';
import 'presentation/screen/cliente/cliente_list_screen.dart';
import 'presentation/screen/cobertura/cobertura_form_screen.dart';
import 'presentation/screen/cobertura/cobertura_list_screen.dart';
import 'presentation/screen/contrato/contrato_form_screen.dart';
import 'presentation/screen/contrato/contrato_list_screen.dart';
import 'presentation/screen/dependente/dependente_form_screen.dart';
import 'presentation/screen/dependente/dependente_list_screen.dart';
import 'presentation/screen/home_screen.dart';
import 'presentation/screen/login_screen.dart';
import 'presentation/screen/register_screen.dart';
import 'presentation/screen/pagamento/pagamento_form_screen.dart';
import 'presentation/screen/pagamento/pagamento_list_screen.dart';
import 'presentation/screen/plano/plano_form_screen.dart';
import 'presentation/screen/plano/plano_list_screen.dart';
import 'presentation/screen/prestador/prestador_form_screen.dart';
import 'presentation/screen/prestador/prestador_list_screen.dart';
import 'presentation/screen/relatorio/relatorio_screen.dart';
import 'presentation/screen/simulacao/simulacao_screen.dart';

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
  static const String dependenteForm = '/dependentes/form';
  static const String contratos = '/contratos';
  static const String contratoForm = '/contratos/form';
  static const String pagamentos = '/pagamentos';
  static const String pagamentoForm = '/pagamentos/form';
  static const String coberturas = '/coberturas';
  static const String coberturaForm = '/coberturas/form';
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
    dependentes: (_) => const DependenteListScreen(),
    dependenteForm: (_) => const DependenteFormScreen(),
    contratos: (_) => const ContratoListScreen(),
    contratoForm: (_) => const ContratoFormScreen(),
    pagamentos: (_) => const PagamentoListScreen(),
    pagamentoForm: (_) => const PagamentoFormScreen(),
    coberturas: (_) => const CoberturaListScreen(),
    coberturaForm: (_) => const CoberturaFormScreen(),
    relatorios: (_) => const RelatorioScreen(),
    simulacao: (_) => const SimulacaoScreen(),
  };
}
