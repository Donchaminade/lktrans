import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/loading_button.dart';
import 'package:lktrans/features/tickets/presentation/widgets/ticket_card.dart'; // For TicketStatus enum

class TicketDetailScreen extends StatelessWidget {
  final Map<String, dynamic> ticketData;

  const TicketDetailScreen({super.key, required this.ticketData});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Color statusColor = AppColors.primary;
    String statusText = 'À venir';
    if (ticketData['status'] == TicketStatus.past) {
      statusColor = Colors.grey;
      statusText = 'Terminé';
    } else if (ticketData['status'] == TicketStatus.cancelled) {
      statusColor = AppColors.error;
      statusText = 'Annulé';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Ticket'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Section - Green Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ticket de Bus', style: textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                          Chip(
                            label: Text(statusText, style: textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            backgroundColor: statusColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      ),
                    ),
                    // Main Ticket Details
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(textTheme, 'Voyage', '${ticketData['from']} → ${ticketData['to']}'),
                          _buildDetailRow(textTheme, 'Date', ticketData['date']!),
                          _buildDetailRow(textTheme, 'Heure', ticketData['time']!),
                          _buildDetailRow(textTheme, 'Passager', ticketData['passengerName']!),
                          _buildDetailRow(textTheme, 'Siège', 'A12'), // Mocked
                          _buildDetailRow(textTheme, 'Bus ID', 'LK${ticketData['id'] ?? 'N/A'}'), // Mocked ID
                        ],
                      ),
                    ),
                    // Perforated Line
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: DottedLine(
                        dashLength: 8.0,
                        dashGapLength: 4.0,
                        lineThickness: 1.0,
                        dashColor: Colors.grey,
                      ),
                    ),
                    // Bottom Section - QR Code / Barcode
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('Présentez ce code à l\'embarquement', style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 16),
                          // Placeholder for QR code or barcode image
                          Container(
                            height: 100,
                            width: 200,
                            color: Colors.grey.shade200,
                            child: const Center(child: Text('QR Code/Barcode')),
                          ),
                          const SizedBox(height: 16),
                          Text('Code de réservation: ${ticketData['reservationCode'] ?? 'ABCDE12345'}', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              LoadingButton(
                onPressed: () async {
                  // TODO: Implement download logic
                  print('Télécharger le ticket ${ticketData['id']}');
                },
                text: 'Télécharger le Ticket',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(TextTheme textTheme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(label, style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary))),
          Expanded(flex: 3, child: Text(value, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
