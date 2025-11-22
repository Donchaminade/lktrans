import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/features/routes/presentation/widgets/route_card.dart';

class RouteCatalogScreen extends StatelessWidget {
  const RouteCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for now
    final routes = List.generate(
      10,
      (index) => {
        'id': '$index',
        'from': 'Abidjan',
        'to': 'Yamoussoukro',
        'price': '3500 FCFA',
        'km': '230 km'
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des Trajets'),
        // No need to set background or elevation here, already in AppTheme
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          return RouteCard(
            from: route['from']!,
            to: route['to']!,
            price: route['price']!,
            km: route['km']!,
            onTap: () {
              context.push('/route-details', extra: route['id']);
            },
          );
        },
      ),
    );
  }
}
