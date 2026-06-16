import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  void _registrar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conta registrada no prototipo')),
    );
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
            child: const Text('Ja tenho conta, logar'),
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
