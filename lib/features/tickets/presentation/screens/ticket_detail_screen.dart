import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/loading_button.dart';
import 'package:lktrans/features/tickets/presentation/widgets/ticket_card.dart'; // For TicketStatus enum
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math'; // Pour simuler succès/échec
import 'package:lktrans/core/widgets/app_alert_dialog.dart';

class TicketDetailScreen extends StatefulWidget {
  final Map<String, dynamic> ticketData;

  const TicketDetailScreen({super.key, required this.ticketData});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  Future<void> _downloadTicket() async {
    // Simuler un délai de téléchargement
    await Future.delayed(const Duration(seconds: 2));

    // Simuler un succès ou un échec de manière aléatoire
    final random = Random();
    final bool success = random.nextBool(); // 50% de chances de succès

    if (success) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AppAlertDialog(
              title: 'Téléchargement réussi',
              message: 'Votre ticket a été téléchargé avec succès.',
              type: AppAlertDialogType.success,
            );
          },
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AppAlertDialog(
              title: 'Échec du téléchargement',
              message: 'Une erreur est survenue lors du téléchargement de votre ticket. Veuillez réessayer.',
              type: AppAlertDialogType.error,
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final status = widget.ticketData['status'] as TicketStatus;

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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            label: Text(status.displayName, style: textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            backgroundColor: status.color,
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
                          _buildDetailRow(textTheme, 'Voyage', '${widget.ticketData['from']} → ${widget.ticketData['to']}'),
                          _buildDetailRow(textTheme, 'Date', widget.ticketData['date']!),
                          _buildDetailRow(textTheme, 'Heure', widget.ticketData['time']!),
                          _buildDetailRow(textTheme, 'Passager', widget.ticketData['passengerName']!),
                          _buildDetailRow(textTheme, 'Siège', 'A12'), // Mocked
                          _buildDetailRow(textTheme, 'Bus ID', 'LK${widget.ticketData['id'] ?? 'N/A'}'), // Mocked ID
                        ],
                      ),
                    ),
                    // Perforated Line
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          QrImageView(
                            data: widget.ticketData['reservationCode'] ?? 'No data',
                            version: QrVersions.auto,
                            size: 120.0,
                            gapless: false,
                            embeddedImage: const AssetImage('assets/images/logo_lk.png'),
                            embeddedImageStyle: const QrEmbeddedImageStyle(
                              size: Size(30, 30),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Code de réservation: ${widget.ticketData['reservationCode'] ?? 'ABCDE12345'}', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              LoadingButton(
                onPressed: _downloadTicket,
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
          Expanded(flex: 3, child: Text(value, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis, maxLines: 1)),
        ],
      ),
    );
  }
}