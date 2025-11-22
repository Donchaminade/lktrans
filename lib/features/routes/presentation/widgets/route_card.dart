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
    return Container( // Use Container for the main card structure to control border directly
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material( // Use Material to enable InkWell splash effect
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // Top vert air border/indicator
              Container(
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.greenAir, // Top border color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0), // Reverted padding to 20 for better look in card
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
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(from, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.arrow_right_alt_rounded, color: AppColors.primary, size: 32),
                        ),
                        Expanded(child: Text(to, textAlign: TextAlign.right, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary))), 
                      ],
                    ),
                    const Divider(height: 32, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoChip(context, Icons.monetization_on_outlined, price, color: AppColors.orangeLight), // Price in orange
                        _buildInfoChip(context, Icons.map_outlined, km),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label, {Color? color}) {
    return Row(
      children: [
        Icon(icon, color: color ?? AppColors.primary, size: 20),
        const SizedBox(width: 10),
        Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: color ?? AppColors.textPrimary)),
      ],
    );
  }
}
