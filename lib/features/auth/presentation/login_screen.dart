import 'package:flutter/material.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_button.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _phone.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _onLogin() {
    // TODO: validation + API auth
    
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 6),
              CircleAvatar(
                radius: 56,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: ClipOval(child: Image.asset('assets/images/logo_lk.png', width: 96, height: 96, fit: BoxFit.cover)),
              ),
              const SizedBox(height: 20),
              const Text('Bienvenue chez LK Transport !', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Connectez-vous à LK Transport pour voyager plus facilement et en toute simplicité!', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 22),

              AppInput(controller: _phone, hint: 'Numéro de téléphone', prefix: const Icon(Icons.phone)),
              const SizedBox(height: 14),
              AppInput(controller: _pass, hint: 'Mot de passe', obscure: _obscure, prefix: const Icon(Icons.lock), suffix: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure))),

              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot'), child: const Text('Mot de passe oublié ?'))),
              const SizedBox(height: 6),

              SizedBox(width: w * 0.6, child: AppButton(label: 'Se connecter', onPressed: _onLogin)),
              const SizedBox(height: 14),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Vous n'avez pas encore un compte ? "),
                TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('S\'inscrire'))
              ])
            ],
          ),
        ),
      ),
    );
  }
}
