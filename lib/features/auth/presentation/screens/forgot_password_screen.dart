import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  Future<void> _sendCode(BuildContext context) async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      context.push('/otp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const GeometricBackground(),
          CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text('Mot de passe oublié'),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverToBoxAdapter(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(height: 16),
                            const Icon(Icons.vpn_key_outlined, size: 60, color: AppColors.textPrimary),
                            const SizedBox(height: 24),
                            Text(
                              'Réinitialisez votre mot de passe',
                              textAlign: TextAlign.center,
                              style: textTheme.headlineSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Entrez l'identifiant associé à votre compte et nous vous enverrons un code pour réinitialiser votre mot de passe.",
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              decoration: _glassyInputDecoration(
                                'Email ou N° de téléphone',
                                icon: Icons.alternate_email,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => (value?.isEmpty ?? true) ? 'Champ requis' : null,
                            ),
                            const SizedBox(height: 32),
                            LoadingButton(
                              onPressed: () => _sendCode(context),
                              text: 'Envoyer le code',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _glassyInputDecoration(String label, {required IconData icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.textPrimary.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.3),
      labelStyle: TextStyle(color: AppColors.textPrimary.withOpacity(0.7)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}