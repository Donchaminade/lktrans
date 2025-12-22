import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' hide RouteData;
import 'package:lktrans/features/routes/data/route_data.dart'; // Import du modèle de données de route
import 'package:lktrans/features/routes/presentation/widgets/route_card.dart';

class RouteCatalogScreen extends StatelessWidget {
  const RouteCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Utiliser les données de routes réelles
    final List<RouteData> availableRoutes = routes; // 'routes' importé de route_data.dart

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des Trajets'),
        // No need to set background or elevation here, already in AppTheme
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: availableRoutes.length,
        itemBuilder: (context, index) {
          final route = availableRoutes[index];
          // Mock some price and km for now, as RouteData doesn't contain them
          final String price = '3500 FCFA'; // Exemple
          final String km = '230 km'; // Exemple

          return RouteCard(
            from: route.departureCity,
            to: route.destinationCity,
            price: price, // Utilise le prix mocké
            km: km,     // Utilise les km mockés
            onTap: () {
              // Passer l'ID de la route ou l'objet route complet si nécessaire pour les détails
              context.push('/route-details', extra: route.departureCity + "-" + route.destinationCity);
            },
          );
        },
      ),
    );
  }
}
