import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:lktrans/core/constants/app_colors.dart';

enum TicketStatus { upcoming, past, cancelled }

class TicketCard extends StatelessWidget {
  final String from;
  final String to;
  final String date;
  final String time;
  final TicketStatus status;
  final String passengerName;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.status,
    required this.passengerName,
    required this.onTap,
  });

  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.upcoming:
        return AppColors.accent;
      case TicketStatus.past:
        return Colors.grey;
      case TicketStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(TicketStatus status) {
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

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(from.toUpperCase(), style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Départ', style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.directions_bus, color: AppColors.primary, size: 28),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(to.toUpperCase(), style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                        Text('Arrivée', style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.end),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DottedLine(
                dashColor: Colors.grey.withOpacity(0.5),
                dashGapLength: 4,
                dashLength: 8,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn('Date', date),
                  _buildInfoColumn('Heure', time),
                  _buildInfoColumn('Passager', passengerName,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end),
                ],
              ),
            ),
             Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              color: _getStatusColor(status).withOpacity(0.15),
              child: Text(
                _getStatusText(status).toUpperCase(),
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: _getStatusColor(status),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value,
      {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start, MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}