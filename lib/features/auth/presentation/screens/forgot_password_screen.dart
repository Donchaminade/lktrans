import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mot de passe oublié'),
        automaticallyImplyLeading: true, // Explicitly ensure back button
      ),
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 40),
                  const Icon(Icons.vpn_key_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 40),
                  Text(
                    'Réinitialisez votre mot de passe',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Entrez l'identifiant associé à votre compte et nous vous enverrons un code pour réinitialiser votre mot de passe.",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email ou N° de téléphone',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  LoadingButton(
                    onPressed: () async {
                      context.push('/otp');
                    },
                    text: 'Envoyer le code',
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
