import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';

enum PaymentMethod { moovFlooz, mtnMoMo, wave, other }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _selectedPaymentMethod = PaymentMethod.moovFlooz;
  final _phoneNumberController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement Mobile Money'),
      ),
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Montant à payer: 3500 FCFA', // Placeholder amount
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 1, 10, 3)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text('Choisissez votre méthode de paiement', style: textTheme.titleMedium),
                  const SizedBox(height: 16),
                  _buildPaymentMethodOption(
                    title: 'Moov Africa Flooz',
                    value: PaymentMethod.moovFlooz,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  _buildPaymentMethodOption(
                    title: 'MTN Mobile Money',
                    value: PaymentMethod.mtnMoMo,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  _buildPaymentMethodOption(
                    title: 'Wave Ci',
                    value: PaymentMethod.wave,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  _buildPaymentMethodOption(
                    title: 'Autre',
                    value: PaymentMethod.other,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Numéro Mobile Money',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pinController,
                    decoration: const InputDecoration(
                      labelText: 'Code PIN / OTP (si nécessaire)',
                      prefixIcon: Icon(Icons.password),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),
                  LoadingButton(
                    onPressed: () async {
                      // Simulate payment success and navigate to confirmation
                      context.go('/confirmation');
                    },
                    text: 'Confirmer le Paiement',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption({
    required String title,
    required PaymentMethod value,
    required PaymentMethod? groupValue,
    required ValueChanged<PaymentMethod?> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: RadioListTile<PaymentMethod>(
        title: Text(title),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
