import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/app_alert_dialog.dart'; // Import AppAlertDialog

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 32),
          _buildProfileOption(
            context,
            icon: Icons.person_outline,
            title: 'Détails du Profil',
            onTap: () {
              context.push('/profile-details');
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.settings_outlined,
            title: 'Paramètres',
            onTap: () {
              context.push('/app-settings');
            },
          ),
          _buildProfileOption(
            context,
            icon: Icons.help_outline,
            title: 'Aide et Support',
            onTap: () {
              // TODO: Implement help/support screen
            },
          ),
          const Divider(height: 32),
          _buildProfileOption(
            context,
            icon: Icons.logout,
            title: 'Déconnexion',
            color: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AppAlertDialog(
                    title: 'Déconnexion',
                    message: 'Êtes-vous sûr de vouloir vous déconnecter ?',
                    type: AppAlertDialogType.warning,
                    buttonText: 'Oui',
                    onButtonPressed: () {
                      Navigator.of(dialogContext).pop(); // Close dialog
                      context.go('/login'); // Navigate to login screen
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/bus_sample.jpg'), // Placeholder
        ),
        const SizedBox(height: 16),
        Text(
          'Chami Ben', // Placeholder name
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
        Text(
          'chami.ben@example.com', // Placeholder email
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey.shade800),
      title: Text(title, style: TextStyle(color: color ?? Colors.grey.shade800)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
