import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Chami Ben');
  final _emailController = TextEditingController(text: 'chami.ben@example.com');
  final _phoneController = TextEditingController(text: '+228 90 12 34 56');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Simulate API call to save profile
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil enregistré avec succès!')),
        );
        // Optionally navigate back or update UI
      }
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
                title: Text('Détails du Profil'),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage('assets/images/bus_sample.jpg'), // Placeholder
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton.icon(
                                  onPressed: () {
                                    // TODO: Implement change profile picture
                                  },
                                  icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
                                  label: const Text('Modifier la photo', style: TextStyle(color: AppColors.primary)),
                                ),
                              ),
                              const SizedBox(height: 32),
                              TextFormField(
                                controller: _nameController,
                                decoration: _glassyInputDecoration(
                                  'Nom et Prénoms',
                                  icon: Icons.person_outline,
                                ),
                                validator: (value) => (value?.isEmpty ?? true) ? 'Champ requis' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                decoration: _glassyInputDecoration(
                                  'Email',
                                  icon: Icons.email_outlined,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) return 'Champ requis';
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) return 'Entrez un email valide';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _phoneController,
                                decoration: _glassyInputDecoration(
                                  'Numéro de téléphone',
                                  icon: Icons.phone_outlined,
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) => (value?.isEmpty ?? true) ? 'Champ requis' : null,
                              ),
                              const SizedBox(height: 32),
                              LoadingButton(
                                onPressed: _saveProfile,
                                text: 'Enregistrer les modifications',
                              ),
                            ],
                          ),
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
