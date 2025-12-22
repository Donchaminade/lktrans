import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  Future<void> _verifyOtp() async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    // In a real app, you would navigate to the password reset screen or home
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
                title: Text('Vérification OTP'),
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
                            const Icon(Icons.dialpad_outlined, size: 60, color: AppColors.textPrimary),
                            const SizedBox(height: 24),
                            Text(
                              'Entrez le code de vérification',
                              textAlign: TextAlign.center,
                              style: textTheme.headlineSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Un code à 4 chiffres a été envoyé à votre identifiant.",
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 32),
                            _buildPinPutField(context),
                            const SizedBox(height: 32),
                            LoadingButton(
                              onPressed: _verifyOtp,
                              text: 'Vérifier',
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () { /* TODO: Implement resend OTP logic */ },
                              child: const Text("Renvoyer le code"),
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

  Widget _buildPinPutField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 64,
          height: 68,
          child: TextFormField(
            onChanged: (value) {
              if (value.length == 1 && index < 3) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
            decoration: _glassyInputDecoration(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        );
      }),
    );
  }

  InputDecoration _glassyInputDecoration() {
    return InputDecoration(
      counterText: "",
      filled: true,
      fillColor: Colors.white.withOpacity(0.3),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}