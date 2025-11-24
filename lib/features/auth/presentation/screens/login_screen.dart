import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(
            child: Padding(
              // Appliquer le padding directement au Column
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20), // Réduit
                  Image.asset('assets/images/logo_lk.png', height: 150),
                  const SizedBox(height: 20), // Réduit
                  Text(
                    'Bienvenue',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Connectez-vous pour continuer',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20), // Réduit
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email ou N° de téléphone',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('Mot de passe oublié ?'),
                    ),
                  ),
                  const SizedBox(height: 16), // Réduit
                  LoadingButton(
                    onPressed: () async {
                      // TODO: Implement actual login logic
                      // For now, we just navigate to home on button press after the delay.
                      context.go('/home');
                    },
                    text: 'Connexion',
                  ),
                  const SizedBox(height: 16), // Réduit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Vous n'avez pas de compte ?",
                          style: textTheme.bodyLarge),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: const Text('S\'inscrire'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
