import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

class UpcomingBusList extends StatelessWidget {
  const UpcomingBusList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Départs à venir',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const BusInfoTile(
            time: '14:30',
            destination: 'Douala - Terminus 2',
            busNumber: 'VIP-102',
            platform: 'Quai 3',
          ),
          const Divider(height: 24, thickness: 1),
          const BusInfoTile(
            time: '15:15',
            destination: 'Yaoundé - Mvan',
            busNumber: 'CLA-056',
            platform: 'Quai 1',
          ),
           const Divider(height: 24, thickness: 1),
           const BusInfoTile(
            time: '16:00',
            destination: 'Bafoussam - Marché B',
            busNumber: 'PRE-007',
            platform: 'Quai 4',
          ),
        ],
      ),
    );
  }
}

class BusInfoTile extends StatelessWidget {
  final String time;
  final String destination;
  final String busNumber;
  final String platform;

  const BusInfoTile({
    super.key,
    required this.time,
    required this.destination,
    required this.busNumber,
    required this.platform,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            time,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                destination,
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Bus: $busNumber',
                style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             Text(
              'Départ',
              style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              platform,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}