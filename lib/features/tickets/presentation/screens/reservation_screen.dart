import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isForSomeoneElse = false;

  // Controllers for form fields
  final TextEditingController _passengerNameController = TextEditingController();
  final TextEditingController _passengerPhoneController = TextEditingController();
  final TextEditingController _passengerEmailController = TextEditingController();
  final TextEditingController _otherPassengerNameController = TextEditingController();
  final TextEditingController _otherPassengerPhoneController = TextEditingController();
  final TextEditingController _otherPassengerEmailController = TextEditingController();

  @override
  void dispose() {
    _passengerNameController.dispose();
    _passengerPhoneController.dispose();
    _passengerEmailController.dispose();
    _otherPassengerNameController.dispose();
    _otherPassengerPhoneController.dispose();
    _otherPassengerEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver un Trajet'),
      ),
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Détails du Trajet Sélectionné', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Abidjan → Yamoussoukro', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                            Text('Date: 25 déc. 2025 - Heure: 14:00', style: textTheme.bodyLarge),
                            Text('Prix: 3500 FCFA - Sièges disponibles: 15', style: textTheme.bodyLarge),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text('Informations du Passager', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passengerNameController,
                      decoration: const InputDecoration(labelText: 'Nom et Prénoms', prefixIcon: Icon(Icons.person_outline)),
                      validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passengerPhoneController,
                      decoration: const InputDecoration(labelText: 'Numéro de Téléphone', prefixIcon: Icon(Icons.phone_outlined)),
                      keyboardType: TextInputType.phone,
                      validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passengerEmailController,
                      decoration: const InputDecoration(labelText: 'Email (Optionnel)', prefixIcon: Icon(Icons.email_outlined)),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Checkbox(
                          value: _isForSomeoneElse,
                          onChanged: (bool? value) {
                            setState(() {
                              _isForSomeoneElse = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                        Text('Réserver pour quelqu\'un d\'autre ?', style: textTheme.bodyLarge),
                      ],
                    ),
                    if (_isForSomeoneElse) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _otherPassengerNameController,
                        decoration: const InputDecoration(labelText: 'Nom et Prénoms (Autre passager)', prefixIcon: Icon(Icons.person_outline)),
                        validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _otherPassengerPhoneController,
                        decoration: const InputDecoration(labelText: 'Numéro de Téléphone (Autre passager)', prefixIcon: Icon(Icons.phone_outlined)),
                        keyboardType: TextInputType.phone,
                        validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _otherPassengerEmailController,
                        decoration: const InputDecoration(labelText: 'Email (Autre passager - Optionnel)', prefixIcon: Icon(Icons.email_outlined)),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                    const SizedBox(height: 32),
                    LoadingButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.push('/payment');
                        }
                      },
                      text: 'Procéder au Paiement',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
