import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

class NextBusCard extends StatelessWidget {
  final VoidCallback onDetailsPressed;
  final Duration timeRemaining;

  const NextBusCard({
    super.key,
    required this.onDetailsPressed,
    required this.timeRemaining,
  });

  String _formatDuration(Duration d) {
    // Format to HH:MM:SS
    return d.toString().split('.').first.padLeft(8, "0");
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PROCHAIN DÉPART',
                style: textTheme.bodyMedium
                    ?.copyWith(color: Colors.white.withOpacity(0.8)),
              ),
              const SizedBox(height: 8),
              Text(
                'BUS 12 - ${_formatDuration(timeRemaining)}',
                style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.person_pin_circle_outlined,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Chauffeur: John Doe',
                      style:
                          textTheme.bodyLarge?.copyWith(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.numbers, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Plaque: AB-123-CD',
                      style:
                          textTheme.bodyLarge?.copyWith(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: OutlinedButton(
                  onPressed: onDetailsPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Voir ➕'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
