import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/loading_button.dart';
import 'package:lktrans/features/tickets/presentation/widgets/ticket_card.dart'; // For TicketStatus enum
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math'; // Pour simuler succès/échec
import 'package:lktrans/core/widgets/app_alert_dialog.dart';

// Imports pour PDF
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class TicketDetailScreen extends StatefulWidget {
  final Map<String, dynamic> ticketData;

  const TicketDetailScreen({super.key, required this.ticketData});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  Future<void> _downloadTicket() async {
    try {
      // Générer le PDF
      final pdf = await _generatePdfTicket();

      // Obtenir le répertoire des documents temporaires
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/ticket_${widget.ticketData['id']}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Ouvre le dialogue de partage
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'ticket_${widget.ticketData['id']}.pdf');

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AppAlertDialog(
              title: 'Téléchargement réussi',
              message: 'Votre ticket a été enregistré et est prèt à âtre partagé.',
              type: AppAlertDialogType.success,
            );
          },
        );
      }
    } catch (e) {
      print('Erreur lors du téléchargement du ticket: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AppAlertDialog(
              title: ' Échec du téléchargement',
              message: 'Une erreur est survenue lors de la génération ou du partage de votre ticket. Veuillez réessayer.',
              type: AppAlertDialogType.error,
            );
          },
        );
      }
    }
  }

  Future<pw.Document> _generatePdfTicket() async {
    final pdf = pw.Document();
    final qrValidationResult = QrValidator.validate(
      data: widget.ticketData['reservationCode'] ?? 'No data',
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    final qrPainter = QrPainter.withData(qrValidationResult.code!);
    final ByteData qrImageByteData = await qrPainter.toImageData(200);
    final Uint8List qrBytes = qrImageByteData.buffer.asUint8List();

    // Charger le logo de l'entreprise
    final ByteData assetBytes = await rootBundle.load('assets/images/logo_lk.png');
    final Uint8List logoBytes = assetBytes.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex(AppColors.primary.value.toRadixString(16).substring(2)),
                  borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(10)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Ticket de Bus', style: pw.TextStyle(color: PdfColors.white, fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Image(pw.MemoryImage(logoBytes), width: 50, height: 50), // Logo
                  ],
                ),
              ),
              pw.Container(
                padding: pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.vertical(bottom: pw.Radius.circular(10)),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildPdfDetailRow('Voyage', '${widget.ticketData['from']} → ${widget.ticketData['to']}'),
                    _buildPdfDetailRow('Date', widget.ticketData['date']!),
                    _buildPdfDetailRow('Heure', widget.ticketData['time']!),
                    _buildPdfDetailRow('Passager', widget.ticketData['passengerName']!),
                    _buildPdfDetailRow('Siège', 'A12'), // Mocked
                    _buildPdfDetailRow('Bus ID', 'LK${widget.ticketData['id'] ?? 'N/A'}'), // Mocked ID
                    pw.SizedBox(height: 20),
                    pw.Divider(),
                    pw.SizedBox(height: 20),
                    pw.Center(
                      child: pw.Column(
                        children: [
                          pw.Text('Présentez ce code à l\'embarquement', style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
                          pw.SizedBox(height: 10),
                          pw.Image(pw.MemoryImage(qrBytes), width: 100, height: 100), // QR Code
                          pw.SizedBox(height: 10),
                          pw.Text('Code de réservation: ${widget.ticketData['reservationCode'] ?? 'ABCDE12345'}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  pw.Widget _buildPdfDetailRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
          pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
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
