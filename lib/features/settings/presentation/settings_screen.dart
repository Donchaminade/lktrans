import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètre')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        ListTile(leading: const Icon(Icons.person), title: const Text('Profil')),
        ListTile(leading: const Icon(Icons.lock), title: const Text('Sécurité')),
        ListTile(leading: const Icon(Icons.info), title: const Text('À propos')),
      ]),
    );
  }
}
