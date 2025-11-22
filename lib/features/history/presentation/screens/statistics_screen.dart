import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<double> _animation1;

  late AnimationController _controller2;
  late Animation<Offset> _animation2;

  late AnimationController _controller3;
  late Animation<double> _animation3;

  late AnimationController _controllerMonthlyStats;
  late Animation<double> _animationMonthlyStats;

  String _selectedYear = '2025';
  final List<String> _availableYears = ['2024', '2025', '2026']; // Mock years

  // Mock data for monthly stats (e.g., number of trips)
  final Map<String, List<int>> _monthlyTrips = {
    '2024': [5, 8, 10, 7, 12, 15, 11, 9, 14, 13, 16, 18],
    '2025': [7, 9, 12, 10, 15, 18, 14, 12, 17, 16, 19, 22],
    '2026': [8, 10, 13, 11, 16, 19, 15, 13, 18, 17, 20, 23],
  };

  @override
  void initState() {
    super.initState();

    // Animation 1 for 'Voyages Terminés'
    _controller1 = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );

    // Animation 2 for 'Distance Totale'
    _controller2 = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation2 = Tween<Offset>(begin: const Offset(-0.5, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeOut),
    );

    // Animation 3 for 'Pauses Moyennes'
    _controller3 = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.fastOutSlowIn),
    );

    // Animation for monthly stats
    _controllerMonthlyStats = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationMonthlyStats = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controllerMonthlyStats, curve: Curves.elasticOut),
    );

    _controller1.forward();
    _controller2.forward();
    _controller3.forward();
    _controllerMonthlyStats.forward();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controllerMonthlyStats.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final List<int> currentMonthlyTrips = _monthlyTrips[_selectedYear] ?? [];
    final double maxTrips = currentMonthlyTrips.reduce((a, b) => a > b ? a : b).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques de Voyage'),
      ),
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Votre Tableau de Bord de Voyages',
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Animated Card 1 - Voyages Terminés
                  AnimatedBuilder(
                    animation: _animation1,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animation1.value,
                        child: Transform.scale(
                          scale: 0.8 + (_animation1.value * 0.2), // Scale from 0.8 to 1.0
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                                                        Text('Voyages Terminés', style: textTheme.titleMedium),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            Text('${(12 * _animation1.value).toInt()}', style: textTheme.headlineLarge?.copyWith(color: AppColors.primary)),
                                                                            Text('2 villes', style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)), // Added info
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),                                  const SizedBox(height: 16),
                                  LinearProgressIndicator(
                                    value: 0.75 * _animation1.value,
                                    backgroundColor: Colors.grey.shade300,
                                    color: AppColors.primary,
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Animated Card 2 - Distance Totale
                  AnimatedBuilder(
                    animation: _animation2,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _animation2,
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Distance Totale', style: textTheme.titleMedium),
                                    Text('${(2500 * _animation1.value).toInt()} km', style: textTheme.headlineLarge?.copyWith(color: AppColors.accent)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(5, (index) => _buildAnimatedBar(index, _animation1.value)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Animated Card 3 - Pauses Moyennes
                  AnimatedBuilder(
                    animation: _animation3,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animation3.value,
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - _animation3.value)), // Slide up
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Pauses Moyennes par Trajet', style: textTheme.titleMedium),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.coffee, color: AppColors.orangeLight, size: 36),
                                      Text('${(2.5 * _animation3.value).toStringAsFixed(1)}', style: textTheme.headlineLarge?.copyWith(color: AppColors.orangeLight)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Monthly Statistics Card
                  AnimatedBuilder(
                    animation: _animationMonthlyStats,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animationMonthlyStats.value,
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - _animationMonthlyStats.value)),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Voyages par Mois', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                      DropdownButton<String>(
                                        value: _selectedYear,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        elevation: 16,
                                        style: textTheme.titleMedium?.copyWith(color: AppColors.primary),
                                        underline: Container(height: 2, color: AppColors.primary),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedYear = newValue!;
                                            _controllerMonthlyStats.reset();
                                            _controllerMonthlyStats.forward();
                                          });
                                        },
                                        items: _availableYears.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    height: 150,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: List.generate(12, (index) {
                                        final month = index + 1;
                                        final trips = currentMonthlyTrips.length > index ? currentMonthlyTrips[index] : 0;
                                        final barHeight = (trips / maxTrips) * 120 * _animationMonthlyStats.value; // Max height 120
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text('$trips', style: textTheme.bodySmall),
                                            const SizedBox(height: 4),
                                            Container(
                                              width: 12,
                                              height: barHeight,
                                              decoration: BoxDecoration(
                                                color: AppColors.accent,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _getMonthAbbreviation(month),
                                              style: textTheme.bodySmall,
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBar(int index, double animationValue) {
    final heights = [50, 70, 40, 60, 80];
    final animatedHeight = heights[index] * animationValue;
    return Column( // Wrap bar with Column to add label if needed
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: animatedHeight,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.8 - (index * 0.1)),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Fév';
      case 3: return 'Mar';
      case 4: return 'Avr';
      case 5: return 'Mai';
      case 6: return 'Juin';
      case 7: return 'Juil';
      case 8: return 'Aoû';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Déc';
      default: return '';
    }
  }
}
