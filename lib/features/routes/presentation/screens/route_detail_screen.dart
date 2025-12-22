import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' hide RouteData;
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';
import 'package:lktrans/features/routes/data/route_data.dart'; // Import the route data

class RouteDetailScreen extends StatelessWidget {
  final String routeId; // Format: "DepartureCity - DestinationCity"

  const RouteDetailScreen({super.key, required this.routeId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Parse routeId to get departure and destination cities
    final List<String> cities = routeId.split(' - ');
    final String departureCity = cities.isNotEmpty ? cities[0] : 'Unknown';
    final String destinationCity = cities.length > 1 ? cities[1] : 'Unknown';

    // Find the matching RouteData object
    final RouteData? currentRoute = routes.firstWhere(
      (r) =>
          r.departureCity == departureCity &&
          r.destinationCity == destinationCity,
      orElse: () => RouteData(
          departureCity: departureCity,
          destinationCity: destinationCity,
          stops: []), // Fallback
    );

    // Populate routeDetails from currentRoute or provide mock values if not found
    final Map<String, dynamic> routeDetails = {
      'from': currentRoute?.departureCity ?? 'Unknown',
      'to': currentRoute?.destinationCity ?? 'Unknown',
      'price': '3500 FCFA', // Mock price
      'km': '230 km', // Mock km
      'stops': currentRoute?.stops
              .map((stop) => {'name': stop, 'duration': '15 min'})
              .toList() ??
          [
            // Mock duration for stops
            {'name': 'Arrêt standard', 'duration': '15 min'}
          ],
      'instructions':
          'Veuillez vous présenter 30 minutes avant le départ. Les bagages en soute ne doivent pas excéder 25kg. Le port du masque est recommandé.'
    };

    return Scaffold(
      backgroundColor: Colors.transparent, // Make scaffold transparent
      appBar: AppBar(
        title: Text('${routeDetails['from']} -> ${routeDetails['to']}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Détails du Trajet',
                            style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 16),
                        _buildInfoRow(textTheme, Icons.monetization_on_outlined,
                            'Prix', routeDetails['price']!,
                            iconColor: AppColors.primary,
                            valueColor: Colors.deepOrange),
                        _buildInfoRow(textTheme, Icons.map_outlined, 'Distance',
                            routeDetails['km']!,
                            iconColor: AppColors.primary,
                            valueColor: AppColors.primary),
                        _buildInfoRow(textTheme, Icons.access_time,
                            'Durée estimée', '3h 30min', // Mocked
                            iconColor: AppColors.primary,
                            valueColor: AppColors.primary),
                        const Divider(
                            height: 32, color: AppColors.textSecondary),
                        Text('Pauses et Arrêts',
                            style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        ...(routeDetails['stops'] as List<Map<String, String>>)
                            .map((stop) {
                          return ListTile(
                            leading: const Icon(
                                Icons.pause_circle_filled_outlined,
                                color: AppColors.primary),
                            title: Text(stop['name']!,
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.textPrimary)),
                            subtitle: Text('Durée: ${stop['duration']}',
                                style: textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary)),
                          );
                        }).toList(),
                        const Divider(
                            height: 32, color: AppColors.textSecondary),
                        Text('Consignes de voyage',
                            style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        Text(
                          routeDetails['instructions']!,
                          style: textTheme.bodyLarge
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 48),
                        LoadingButton(
                          onPressed: () async {
                            context.push('/reservation', extra: routeDetails);
                          },
                          text: 'Réserver ce Trajet',
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
    );
  }

  Widget _buildInfoRow(
      TextTheme textTheme, IconData icon, String label, String value,
      {Color? iconColor, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon,
              color: iconColor ?? AppColors.textPrimary.withOpacity(0.7),
              size: 20),
          const SizedBox(width: 16),
          Text('$label:',
              style:
                  textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary)),
          const Spacer(),
          Text(value,
              style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppColors.textPrimary)),
        ],
      ),
    );
  }
}
