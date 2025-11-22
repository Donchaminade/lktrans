import 'package:flutter/material.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _onRegister() {
    // TODO: API register
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            AppInput(controller: _name, hint: 'Nom complet', prefix: const Icon(Icons.person)),
            const SizedBox(height: 12),
            AppInput(controller: _phone, hint: 'Numéro de téléphone', prefix: const Icon(Icons.phone)),
            const SizedBox(height: 12),
            AppInput(controller: _pass, hint: 'Mot de passe', obscure: _obscure, prefix: const Icon(Icons.lock), suffix: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure))),
            const SizedBox(height: 20),
            AppButton(label: 'S\'inscrire', onPressed: _onRegister)
          ]),
        ),
      ),
    );
  }
}
