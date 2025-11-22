import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget buildPinPutField(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              decoration: const InputDecoration(
                counterText: "",
              ),
              style: textTheme.headlineMedium,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification OTP'),
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
                  const Icon(Icons.dialpad, size: 80, color: Colors.grey),
                  const SizedBox(height: 40),
                  Text(
                    'Entrez le code de vérification',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Un code à 4 chiffres a été envoyé à votre identifiant.",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  buildPinPutField(context),
                  const SizedBox(height: 30),
                  LoadingButton(
                    onPressed: () async {
                      // TODO: Implement OTP verification logic
                    },
                    text: 'Vérifier',
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () { /* TODO: Implement resend OTP logic */ },
                    child: const Text("Renvoyer le code"),
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
