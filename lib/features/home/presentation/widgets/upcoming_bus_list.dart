import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

class UpcomingBusList extends StatelessWidget {
  const UpcomingBusList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final List<Map<String, String>> upcomingBuses = [
      {'id': 'B13', 'time': '12:30', 'driver': 'Jane Smith'},
      {'id': 'B07', 'time': '12:45', 'driver': 'Mike Ross'},
      {'id': 'A02', 'time': '13:00', 'driver': 'Harvey Specter'}, // This is the user's bus
      {'id': 'C05', 'time': '13:15', 'driver': 'Louis Litt'},
      {'id': 'D11', 'time': '13:30', 'driver': 'Donna Paulsen'},
    ];
    const userReservedBusId = 'A02';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Prochains départs",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...upcomingBuses.map((bus) {
          final isUserBus = bus['id'] == userReservedBusId;
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isUserBus ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
            ),
            child: ListTile(
              leading: const Icon(Icons.directions_bus, color: AppColors.primary),
              title: Text('Bus ${bus['id']} - Départ à ${bus['time']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Chauffeur: ${bus['driver']}'),
              trailing: isUserBus
                  ? const Chip(
                      label: Text('Votre bus'),
                      backgroundColor: AppColors.accent,
                      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    )
                  : null,
            ),
          );
        }).toList(),
      ],
    );
  }
}
