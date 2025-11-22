import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';

class ReservationScreen extends StatefulWidget {
  final Map<String, dynamic>? routeData; // Optional route data

  const ReservationScreen({super.key, this.routeData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form Keys for each step
  final _formKeyStep1Manual = GlobalKey<FormState>(); // For manual route entry
  final _formKeyStep2Passengers = GlobalKey<FormState>(); // For passenger details
  final _formKeyStep3DateBaggage = GlobalKey<FormState>(); // For date, seats, baggage

  bool _isForSomeoneElse = false;

  // Controllers for Passenger Form fields
  final TextEditingController _passengerNameController = TextEditingController();
  final TextEditingController _passengerPhoneController = TextEditingController();
  final TextEditingController _passengerEmailController = TextEditingController();
  final TextEditingController _otherPassengerNameController = TextEditingController();
  final TextEditingController _otherPassengerPhoneController = TextEditingController();
  final TextEditingController _otherPassengerEmailController = TextEditingController();

  // Controllers for Manual Route Form fields
  final TextEditingController _departureCityController = TextEditingController();
  final TextEditingController _destinationCityController = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();
  final TextEditingController _numberOfSeatsController = TextEditingController();

  // Baggage Photo Simulation
  final List<String> _baggagePhotos = []; // Store placeholder image paths

  // Pre-fill from routeData if provided
  @override
  void initState() {
    super.initState();
    if (widget.routeData != null) {
      // If routeData is provided, skip manual route entry step
      // and pre-fill if applicable, or just adjust initial page logic
      // For now, assume if routeData is present, we start at passenger info
      // _currentPage = 0; // This will be the passenger step if manual route entry is first
    }
    // Mock data for initial date
    _departureDateController.text = '25 déc. 2025';
    _numberOfSeatsController.text = '1';
  }

  @override
  void dispose() {
    _passengerNameController.dispose();
    _passengerPhoneController.dispose();
    _passengerEmailController.dispose();
    _otherPassengerNameController.dispose();
    _otherPassengerPhoneController.dispose();
    _otherPassengerEmailController.dispose();
    _departureCityController.dispose();
    _destinationCityController.dispose();
    _departureDateController.dispose();
    _numberOfSeatsController.dispose();
    super.dispose();
  }

  // Determine if manual route entry step is needed
  bool get _needsManualRouteEntry => widget.routeData == null;

  int get _totalSteps => _needsManualRouteEntry ? 3 : 2;

  void _nextPage() {
    bool isValid = false;
    if (_needsManualRouteEntry && _currentPage == 0) {
      isValid = _formKeyStep1Manual.currentState?.validate() ?? false;
    } else if ((_needsManualRouteEntry && _currentPage == 1) || (!_needsManualRouteEntry && _currentPage == 0)) {
      isValid = _formKeyStep2Passengers.currentState?.validate() ?? false;
    }

    if (isValid) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _selectDepartureDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: AppColors.textPrimary, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _departureDateController.text = "${picked.day} ${_getMonthAbbreviation(picked.month)}. ${picked.year}";
      });
    }
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1: return 'janv.';
      case 2: return 'févr.';
      case 3: return 'mars';
      case 4: return 'avr.';
      case 5: return 'mai';
      case 6: return 'juin';
      case 7: return 'juil.';
      case 8: return 'août';
      case 9: return 'sept.';
      case 10: return 'oct.';
      case 11: return 'nov.';
      case 12: return 'déc.';
      default: return '';
    }
  }

  void _addBaggagePhoto() {
    if (_baggagePhotos.length < 8) {
      setState(() {
        _baggagePhotos.add('assets/images/bus_sample.jpg'); // Simulate image added
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 8 photos de bagages.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Réservation - Étape ${_currentPage + 1} sur $_totalSteps'),
      ),
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: _needsManualRouteEntry
                        ? [
                            _buildStep1ManualRoute(textTheme),
                            _buildStep2Passengers(textTheme),
                            _buildStep3DateBaggage(textTheme),
                          ]
                        : [
                            _buildStep1Passengers(textTheme), // Original passenger step
                            _buildStep2DateBaggage(textTheme), // Original date/baggage step
                          ],
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Building Steps ---
  Widget _buildStep1ManualRoute(TextTheme textTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeyStep1Manual,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Trajet de Voyage', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Entrez les détails de votre trajet.', style: textTheme.bodyLarge),
            const SizedBox(height: 24),
            TextFormField(
              controller: _departureCityController,
              decoration: const InputDecoration(labelText: 'Ville de Départ', prefixIcon: Icon(Icons.location_on_outlined)),
              validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _destinationCityController,
              decoration: const InputDecoration(labelText: 'Ville de Destination', prefixIcon: Icon(Icons.location_on)),
              validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1Passengers(TextTheme textTheme) {
    // This is the first step if routeData is pre-filled
    return _buildPassengerDetailsForm(textTheme);
  }

  Widget _buildStep2Passengers(TextTheme textTheme) {
    // This is the second step if manual route entry is first
    return _buildPassengerDetailsForm(textTheme);
  }

  Widget _buildPassengerDetailsForm(TextTheme textTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeyStep2Passengers,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Informations du Passager', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Qui voyagera ?', style: textTheme.bodyLarge),
            const SizedBox(height: 24),
            TextFormField(
              controller: _passengerNameController,
              decoration: const InputDecoration(labelText: 'Nom et Prénoms', prefixIcon: Icon(Icons.person_outline)),
              validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passengerPhoneController,
              decoration: const InputDecoration(labelText: 'Numéro de Téléphone', prefixIcon: Icon(Icons.phone_outlined)),
              keyboardType: TextInputType.phone,
              validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passengerEmailController,
              decoration: const InputDecoration(labelText: 'Email (Optionnel)', prefixIcon: Icon(Icons.email_outlined)),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Checkbox(
                  value: _isForSomeoneElse,
                  onChanged: (bool? value) {
                    setState(() {
                      _isForSomeoneElse = value ?? false;
                    });
                  },
                  activeColor: AppColors.primary,
                ),
                Text('Réserver pour quelqu\'un d\'autre ?', style: textTheme.bodyLarge),
              ],
            ),
            if (_isForSomeoneElse) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _otherPassengerNameController,
                decoration: const InputDecoration(labelText: 'Nom et Prénoms (Autre passager)', prefixIcon: Icon(Icons.person_outline)),
                validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _otherPassengerPhoneController,
                decoration: const InputDecoration(labelText: 'Numéro de Téléphone (Autre passager)', prefixIcon: Icon(Icons.phone_outlined)),
                keyboardType: TextInputType.phone,
                validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _otherPassengerEmailController,
                decoration: const InputDecoration(labelText: 'Email (Autre passager - Optionnel)', prefixIcon: Icon(Icons.email_outlined)),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStep2DateBaggage(TextTheme textTheme) {
    // This is the second step if routeData is pre-filled
    return _buildDateBaggageForm(textTheme);
  }

  Widget _buildStep3DateBaggage(TextTheme textTheme) {
    // This is the third step if manual route entry is first
    return _buildDateBaggageForm(textTheme);
  }

  Widget _buildDateBaggageForm(TextTheme textTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeyStep3DateBaggage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Date & Bagages', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Choisissez la date et ajoutez les photos de vos bagages.', style: textTheme.bodyLarge),
            const SizedBox(height: 24),
            TextFormField(
              controller: _departureDateController,
              readOnly: true,
              onTap: _selectDepartureDate,
              decoration: const InputDecoration(
                labelText: 'Date de Départ',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _numberOfSeatsController,
              decoration: const InputDecoration(
                labelText: 'Nombre de personnes',
                prefixIcon: Icon(Icons.people),
              ),
              keyboardType: TextInputType.number,
              validator: (value) => (value?.isEmpty ?? true) ? 'Ce champ est requis' : null,
            ),
            const SizedBox(height: 24),
            Text('Photos des Bagages (Max 8)', style: textTheme.titleMedium),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _baggagePhotos.length + 1, // +1 for add button
              itemBuilder: (context, index) {
                if (index == _baggagePhotos.length) {
                  return InkWell(
                    onTap: _addBaggagePhoto,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: const Icon(Icons.add_a_photo, color: Colors.grey),
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(_baggagePhotos[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Précédent'),
            ),
          const Spacer(),
          SizedBox(
            width: 150,
            child: LoadingButton(
              onPressed: () async {
                bool isValid = false;
                if (_needsManualRouteEntry && _currentPage == 0) {
                  isValid = _formKeyStep1Manual.currentState?.validate() ?? false;
                } else if ((_needsManualRouteEntry && _currentPage == 1) || (!_needsManualRouteEntry && _currentPage == 0)) {
                  isValid = _formKeyStep2Passengers.currentState?.validate() ?? false;
                } else if ((_needsManualRouteEntry && _currentPage == 2) || (!_needsManualRouteEntry && _currentPage == 1)) {
                  isValid = _formKeyStep3DateBaggage.currentState?.validate() ?? false;
                }

                if (isValid) {
                  if (_currentPage < (_totalSteps - 1)) {
                    _nextPage();
                  } else {
                    // Last step: Validate and submit
                    // Final validation for the last step
                    if (_formKeyStep3DateBaggage.currentState?.validate() ?? false) {
                       context.push('/payment');
                    }
                  }
                }
              },
              text: _currentPage < (_totalSteps - 1) ? 'Suivant' : 'Procéder au Paiement',
            ),
          ),
        ],
      ),
    );
  }
}
