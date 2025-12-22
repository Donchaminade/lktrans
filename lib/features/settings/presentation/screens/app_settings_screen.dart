import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Needed if you navigate from settings, e.g., to an about screen
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false; // This would typically come from a theme service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const GeometricBackground(),
          CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text('Paramètres'),
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
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.language, color: AppColors.textPrimary),
                              title: const Text('Langue', style: TextStyle(color: AppColors.textPrimary)),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                              onTap: () {
                                // TODO: Implement language selection
                              },
                            ),
                            SwitchListTile(
                              secondary: const Icon(Icons.notifications, color: AppColors.textPrimary),
                              title: const Text('Notifications', style: TextStyle(color: AppColors.textPrimary)),
                              value: _notificationsEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                                // TODO: Update notification settings
                              },
                              activeColor: AppColors.primary,
                            ),
                            SwitchListTile(
                              secondary: const Icon(Icons.dark_mode, color: AppColors.textPrimary),
                              title: const Text('Thème sombre', style: TextStyle(color: AppColors.textPrimary)),
                              value: _darkModeEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  _darkModeEnabled = value;
                                });
                                // TODO: Implement theme switching logic (requires provider/bloc)
                              },
                              activeColor: AppColors.primary,
                            ),
                            ListTile(
                              leading: const Icon(Icons.info_outline, color: AppColors.textPrimary),
                              title: const Text('À propos de l\'application', style: TextStyle(color: AppColors.textPrimary)),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                              onTap: () {
                                // TODO: Implement "About" screen navigation
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.code, color: AppColors.textPrimary),
                              title: const Text('Version', style: TextStyle(color: AppColors.textPrimary)),
                              trailing: const Text('1.0.0', style: TextStyle(color: AppColors.textSecondary)),
                              onTap: () {
                                // No action needed for version
                              },
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
}
