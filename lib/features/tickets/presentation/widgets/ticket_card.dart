import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

enum TicketStatus { upcoming, past, cancelled }

class TicketCard extends StatelessWidget {
  final String from;
  final String to;
  final String date;
  final String time;
  final TicketStatus status;
  final String passengerName;
  final VoidCallback? onTap;

  const TicketCard({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.status,
    required this.passengerName,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (status) {
      case TicketStatus.upcoming:
        return AppColors.primary;
      case TicketStatus.past:
        return Colors.grey;
      case TicketStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusText() {
    switch (status) {
      case TicketStatus.upcoming:
        return 'À venir';
      case TicketStatus.past:
        return 'Terminé';
      case TicketStatus.cancelled:
        return 'Annulé';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
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
              // Top green border/indicator
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Départ: $from', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Arrivée: $to', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date: $date', style: textTheme.bodyMedium),
                        Text('Heure: $time', style: textTheme.bodyMedium),
                      ],
                    ),
                    const Divider(height: 24, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Passager:', style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                            Text(passengerName, style: textTheme.titleMedium),
                          ],
                        ),
                        Chip(
                          label: Text(_getStatusText(), style: textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                          backgroundColor: _getStatusColor(),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
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
}
