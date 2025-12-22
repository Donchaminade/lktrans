import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';
import 'package:lktrans/features/routes/data/route_data.dart';
import 'package:lktrans/features/tickets/presentation/widgets/seat_selection_widget.dart';

class ReservationScreen extends StatefulWidget {
  final Map<String, dynamic>? routeData;

  const ReservationScreen({super.key, this.routeData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  // ---------------------------------------------------------------------------
  // CONSTANTES BUSINESS LOGIC
  // ---------------------------------------------------------------------------
  static const double basePrice = 3500;
  static const double extraBaggagePrice = 500;
  static const int minPassengers = 1;
  static const int maxPassengers = 10;
  static const int maxExtraBaggage = 5;

  static const List<String> monthLabels = [
    'janv.',
    'févr.',
    'mars',
    'avr.',
    'mai',
    'juin',
    'juil.',
    'août',
    'sept.',
    'oct.',
    'nov.',
    'déc.'
  ];

  // ---------------------------------------------------------------------------
  // FORM STATE
  // ---------------------------------------------------------------------------
  final _formKey = GlobalKey<FormState>();

  String? _selectedDepartureCity;
  String? _selectedDestinationCity;
  late final TextEditingController _passengerNameController;
  late final TextEditingController _passengerPhoneController;
  late final TextEditingController _departureDateController;

  int _passengerCount = minPassengers;
  int _extraBaggageCount = 0;
  Set<int> _selectedSeats = {};

  @override
  void initState() {
    super.initState();

    _passengerNameController = TextEditingController();
    _passengerPhoneController = TextEditingController();
    _departureDateController = TextEditingController(
      text: _formattedDate(DateTime.now()),
    );

    if (widget.routeData != null) {
      _selectedDepartureCity = widget.routeData!['from'];
      _selectedDestinationCity = widget.routeData!['to'];
    }
  }

  @override
  void dispose() {
    _passengerNameController.dispose();
    _passengerPhoneController.dispose();
    _departureDateController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // GETTERS UTILES
  // ---------------------------------------------------------------------------
  bool get needsManualRouteEntry => widget.routeData == null;

  bool get areSeatsValid => _selectedSeats.length == _passengerCount;

  double get totalPrice {
    return (basePrice * _passengerCount) +
        (extraBaggagePrice * _extraBaggageCount);
  }

  // ---------------------------------------------------------------------------
  // LOGIQUE DATES
  // ---------------------------------------------------------------------------
  String _formattedDate(DateTime date) {
    return "${date.day} ${monthLabels[date.month - 1]} ${date.year}";
  }

  Future<void> _selectDepartureDate() async {
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('fr'),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _departureDateController.text = _formattedDate(picked);
      });
    }
  }

  // ---------------------------------------------------------------------------
  // SEAT SELECTION
  // ---------------------------------------------------------------------------
  Future<void> _showSeatSelector() async {
    final Set<int>? result = await showModalBottomSheet<Set<int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return SeatSelectionWidget(
            seatsToSelect: _passengerCount,
            initialSelectedSeats: _selectedSeats,
            unavailableSeats: const {1, 5, 10, 15, 22, 23},
          );
        },
      ),
    );

    if (result != null) {
      setState(() {
        _selectedSeats = result;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // VALIDATION GLOBALE
  // ---------------------------------------------------------------------------
  Future<void> _finalizeReservation() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!areSeatsValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner les sièges.")),
      );
      return;
    }

    context.push('/payment', extra: {
      'from': _selectedDepartureCity,
      'to': _selectedDestinationCity,
      'date': _departureDateController.text,
      'passengers': _passengerCount,
      'extraBaggage': _extraBaggageCount,
      'seats': _selectedSeats.toList(),
      'name': _passengerNameController.text,
      'phone': _passengerPhoneController.text,
      'totalAmount': totalPrice,
    });
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Réservation'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(bottom: false, child: _buildBody(textTheme)),
          _buildStickyFooter(textTheme),
        ],
      ),
    );
  }

  Widget _buildBody(TextTheme textTheme) {
    return Form(
      key: _formKey,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24).copyWith(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (needsManualRouteEntry) ...[
                    _buildSectionTitle(textTheme, 'Trajet', Icons.map),
                    _buildRouteSelection(),
                    const SizedBox(height: 24),
                  ],
                  _buildSectionTitle(textTheme, 'Options de Voyage', Icons.event_seat),
                  _buildTravelOptions(textTheme),
                  const SizedBox(height: 24),
                  _buildSectionTitle(textTheme, 'Passager Principal', Icons.person),
                  _buildPassengerInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(TextTheme textTheme, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSelection() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedDepartureCity,
          items: cities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          decoration: _glassyInputDecoration('Ville de Départ'),
          onChanged: (v) => setState(() => _selectedDepartureCity = v),
          validator: (v) => v == null ? 'Champ requis' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedDestinationCity,
          items: cities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          decoration: _glassyInputDecoration('Ville de Destination'),
          onChanged: (v) => setState(() => _selectedDestinationCity = v),
          validator: (v) => v == null ? 'Champ requis' : null,
        ),
      ],
    );
  }

  Widget _buildTravelOptions(TextTheme textTheme) {
    return Column(
      children: [
        TextFormField(
          controller: _departureDateController,
          readOnly: true,
          onTap: _selectDepartureDate,
          validator: (v) => v?.isEmpty ?? true ? 'Champ requis' : null,
          decoration: _glassyInputDecoration('Date de Départ', hasIcon: false),
        ),
        const SizedBox(height: 16),
        _buildStepper(textTheme, 'Passagers', _passengerCount, minPassengers, maxPassengers,
            (v) => setState(() => _passengerCount = v)),
        const SizedBox(height: 16),
        _buildStepper(textTheme, 'Bagages Supplémentaires', _extraBaggageCount, 0, maxExtraBaggage,
            (v) => setState(() => _extraBaggageCount = v)),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _showSeatSelector,
          icon: const Icon(Icons.chair_outlined, color: AppColors.textPrimary),
          label: Text(
            'Choisir les sièges (${_selectedSeats.length}/$_passengerCount sélectionnés)',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            side: BorderSide(color: AppColors.textPrimary.withOpacity(0.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _passengerNameController,
          decoration: _glassyInputDecoration('Nom et Prénoms', hasIcon: false),
          validator: (v) => v?.isEmpty ?? true ? 'Champ requis' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passengerPhoneController,
          decoration: _glassyInputDecoration('Numéro de Téléphone', hasIcon: false),
          keyboardType: TextInputType.phone,
          validator: (v) => v?.isEmpty ?? true ? 'Champ requis' : null,
        ),
      ],
    );
  }

  Widget _buildStepper(
    TextTheme textTheme,
    String label,
    int value,
    int min,
    int max,
    ValueChanged<int> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary)),
        Row(
          children: [
            IconButton(
              onPressed: value > min ? () => onChanged(value - 1) : null,
              color: AppColors.textPrimary.withOpacity(value > min ? 1 : 0.4),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '$value',
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: value < max ? () => onChanged(value + 1) : null,
              color: AppColors.textPrimary.withOpacity(value < max ? 1 : 0.4),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STICKY FOOTER
  // ---------------------------------------------------------------------------
  Widget _buildStickyFooter(TextTheme textTheme) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total', style: textTheme.bodyMedium),
                Text(
                  '${totalPrice.toStringAsFixed(0)} FCFA',
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 150,
              child: LoadingButton(
                onPressed: _finalizeReservation,
                text: 'Finaliser',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMMON INPUT STYLE
  // ---------------------------------------------------------------------------
  InputDecoration _glassyInputDecoration(String label, {bool hasIcon = true}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: hasIcon
          ? Icon(Icons.trip_origin, color: AppColors.textPrimary.withOpacity(0.7))
          : null,
      filled: true,
      fillColor: Colors.white.withOpacity(0.3),
      labelStyle: TextStyle(color: AppColors.textPrimary.withOpacity(0.7)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
