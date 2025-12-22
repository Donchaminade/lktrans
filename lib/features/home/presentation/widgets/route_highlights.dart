import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/features/routes/data/route_data.dart'; // Import the route data

class RouteHighlights extends StatelessWidget {
  const RouteHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trajets Populaires',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.go('/routes'),
              child: const Text('Voir tout'),
            )
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: routes.take(3).map((route) { // Display first 3 routes
              return Padding(
                padding: const EdgeInsets.only(right: 16), // Spacing between cards
                child: RouteHighlightCard(
                  imagePath: 'assets/images/bus_sample.jpg', // Placeholder
                  routeName: '${route.departureCity} - ${route.destinationCity}',
                  price: '3500 FCFA', // Mock price for now
                  duration: '4h 30min', // Mock duration for now
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class RouteHighlightCard extends StatelessWidget {
  final String imagePath;
  final String routeName;
  final String price;
  final String duration;

  const RouteHighlightCard({
    super.key,
    required this.imagePath,
    required this.routeName,
    required this.price,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 3,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: InkWell(
          onTap: () {
            // Navigate to route details, passing a dummy ID for now
            context.push('/route-details', extra: routeName); // Passing routeName as extra
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routeName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, color: AppColors.textSecondary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        price,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
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
}