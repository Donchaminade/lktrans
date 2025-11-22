import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

class RouteCard extends StatelessWidget {
  final String from;
  final String to;
  final String price;
  final String km;
  final VoidCallback onTap;

  const RouteCard({
    super.key,
    required this.from,
    required this.to,
    required this.price,
    required this.km,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 5, // Slightly more pronounced elevation
      shadowColor: Colors.black.withOpacity(0.15),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // More rounded corners
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, AppColors.background.withOpacity(0.5)], // Subtle gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Départ', style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  Text('Arrivée', style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 8), // Increased spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(from, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_right_alt_rounded, color: AppColors.primary, size: 32), // Larger icon
                  ),
                  Expanded(child: Text(to, textAlign: TextAlign.right, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                ],
              ),
              const Divider(height: 32, thickness: 1), // Thicker divider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(context, Icons.monetization_on_outlined, price),
                  _buildInfoChip(context, Icons.map_outlined, km),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20), // Slightly larger icon
        const SizedBox(width: 10), // Increased spacing
        Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)), // Use bodyLarge
      ],
    );
  }
}
