import 'package:flutter/material.dart';

import '../../domain/models/usuario.dart';
import '../../domain/services/usuario_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _service = UsuarioService();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmar = TextEditingController();

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (_email.text.isEmpty || _senha.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha e-mail e senha')));
      return;
    }
    if (_senha.text != _confirmar.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('As senhas não coincidem')));
      return;
    }
    await _service.cadastrar(
      Usuario(nome: _nome.text, email: _email.text.trim(), senha: _senha.text),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Conta criada! Faça login.')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _campo(_nome, 'Nome'),
          _campo(_email, 'E-mail', email: true),
          _campo(_senha, 'Senha', senha: true),
          _campo(_confirmar, 'Confirmar senha', senha: true),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _registrar, child: const Text('Registrar')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Já tenho conta, Logar'),
          ),
        ],
      ),
    );
  }

  Widget _campo(
    TextEditingController controller,
    String label, {
    bool senha = false,
    bool email = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: senha,
        keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
