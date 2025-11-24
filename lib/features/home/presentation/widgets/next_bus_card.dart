import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

class NextBusCard extends StatelessWidget {
  final Duration timeRemaining;
  final VoidCallback onDetailsPressed;

  const NextBusCard({
    super.key,
    required this.timeRemaining,
    required this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prochain départ',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.directions_bus,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${timeRemaining.inHours.toString().padLeft(2, '0')}:${(timeRemaining.inMinutes % 60).toString().padLeft(2, '0')}:${(timeRemaining.inSeconds % 60).toString().padLeft(2, '0')}',
            style: textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Destination: Douala - Terminus 2', // Placeholder
            style: textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: onDetailsPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Plus de détails'),
            ),
          ),
        ],
      ),
    );
  }
}