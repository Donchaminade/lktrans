import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/features/routes/presentation/widgets/route_card.dart'; // Reusing RouteCard

class RouteHighlights extends StatelessWidget {
  const RouteHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Mock data for top 3 routes
    final highlights = [
      {'id': '0', 'from': 'Abidjan', 'to': 'Yamoussoukro', 'price': '3500 FCFA', 'km': '230 km'},
      {'id': '1', 'from': 'Abidjan', 'to': 'Grand-Bassam', 'price': '1000 FCFA', 'km': '40 km'},
      {'id': '2', 'from': 'Yamoussoukro', 'to': 'Bouaké', 'price': '2500 FCFA', 'km': '150 km'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Nos Meilleurs Trajets",
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary), // Changed color
            ),
            TextButton(
              onPressed: () {
                context.push('/routes'); // Navigate to full catalog
              },
              child: const Text('Voir tout', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: highlights.map((route) {
            return RouteCard(
              from: route['from']!,
              to: route['to']!,
              price: route['price']!,
              km: route['km']!,
              onTap: () {
                context.push('/route-details', extra: route['id']);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
