import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

class RouteDetailScreen extends StatelessWidget {
  // In a real app, this would be a route ID
  final String routeId;

  const RouteDetailScreen({super.key, required this.routeId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Mock data based on routeId
    final routeDetails = {
      'from': 'Abidjan',
      'to': 'Yamoussoukro',
      'price': '3500 FCFA',
      'km': '230 km',
      'stops': [
        {'name': 'Pause N\'Douci', 'duration': '25 min'},
        {'name': 'Péage Tiébissou', 'duration': '5 min'},
      ],
      'instructions': 'Veuillez vous présenter 30 minutes avant le départ. Les bagages en soute ne doivent pas excéder 25kg. Le port du masque est recommandé.'
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('${routeDetails['from']} -> ${routeDetails['to']}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Détails du Trajet', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow(textTheme, Icons.monetization_on_outlined, 'Prix', routeDetails['price'] as String),
            _buildInfoRow(textTheme, Icons.map_outlined, 'Distance', routeDetails['km'] as String),
            _buildInfoRow(textTheme, Icons.access_time, 'Durée estimée', '3h 30min'), // Mocked
            const Divider(height: 32),
            Text('Pauses et Arrêts', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...(routeDetails['stops'] as List<Map<String, String>>)
                .map((stop) => ListTile(
                      leading: const Icon(Icons.pause_circle_filled_outlined, color: AppColors.primary),
                      title: Text(stop['name']!),
                      subtitle: Text('Durée: ${stop['duration']}'),
                    ))
                .toList(),
            const Divider(height: 32),
            Text('Consignes de voyage', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              routeDetails['instructions'] as String,
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(TextTheme textTheme, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 16),
          Text('$label:', style: textTheme.bodyLarge),
          const Spacer(),
          Text(value, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
