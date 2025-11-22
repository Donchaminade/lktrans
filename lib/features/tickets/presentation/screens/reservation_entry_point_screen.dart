import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';
import 'package:lktrans/core/constants/app_colors.dart';

class ReservationEntryPointScreen extends StatelessWidget {
  const ReservationEntryPointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Réservation'),
      ),
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Comment souhaitez-vous réserver ?',
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  LoadingButton(
                    onPressed: () async {
                      // Navigate to Route Catalog
                      context.push('/routes');
                    },
                    text: 'Sélectionner mon trajet',
                  ),
                  const SizedBox(height: 24),
                  LoadingButton(
                    onPressed: () async {
                      // Navigate to manual reservation form
                      context.push('/reservation'); // Without route data
                    },
                    text: 'Saisir par moi-même',
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
