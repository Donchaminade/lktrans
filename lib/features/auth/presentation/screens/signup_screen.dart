import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isProfilePicSelected = false; // Simulation de la sélection d'image

  // Clés de formulaire pour chaque étape
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  void _nextPage() {
    bool isValid = _formKeyStep1.currentState?.validate() ?? false;
    if (isValid) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Étape ${_currentPage + 1} sur 2'),
      ),
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    children: [
                      _buildStep1(textTheme),
                      _buildStep2(textTheme),
                    ],
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1(TextTheme textTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKeyStep1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _isProfilePicSelected ? const AssetImage('assets/images/bus_sample.jpg') : null,
                    child: !_isProfilePicSelected
                        ? Icon(Icons.person, size: 70, color: Colors.grey.shade400)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () => setState(() => _isProfilePicSelected = true),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: const Icon(Icons.add_a_photo, color: Colors.white, size: 23),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nom et prénoms', prefixIcon: Icon(Icons.person_outline)),
              validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Ce champ est requis';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) return 'Entrez un email valide';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Numéro de téléphone', prefixIcon: Icon(Icons.phone_outlined)),
              keyboardType: TextInputType.phone,
              validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2(TextTheme textTheme) {
    final passwordController = TextEditingController();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKeyStep2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Sécurité et Extras', style: textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Finalisez la création de votre compte.', style: textTheme.bodyLarge),
            const SizedBox(height: 40),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe', prefixIcon: Icon(Icons.lock_outline)),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Ce champ est requis';
                if (value!.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmez le mot de passe', prefixIcon: Icon(Icons.lock_outline)),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Ce champ est requis';
                if (value != passwordController.text) return 'Les mots de passe ne correspondent pas';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Code de parrainage (Optionnel)', prefixIcon: Icon(Icons.card_giftcard_outlined)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
              child: const Text('Précédent'),
            ),
          const Spacer(),
          SizedBox(
            width: 150,
            child: LoadingButton(
              onPressed: () async {
                if (_currentPage < 1) {
                  _nextPage();
                } else {
                  if (_formKeyStep2.currentState?.validate() ?? false) {
                    // TODO: Implémenter la logique d'inscription finale
                    print('Inscription terminée !');
                  }
                }
              },
              text: _currentPage < 1 ? 'Suivant' : 'Terminer',
            ),
          ),
        ],
      ),
    );
  }
}
