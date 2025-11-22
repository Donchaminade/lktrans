import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/features/home/presentation/widgets/next_bus_card.dart';
import 'package:lktrans/features/home/presentation/widgets/promo_carousel.dart';
import 'package:lktrans/features/home/presentation/widgets/route_highlights.dart';
import 'package:lktrans/features/home/presentation/widgets/upcoming_bus_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  Duration _timeRemaining = const Duration(hours: 1, minutes: 23, seconds: 45);
  bool _isBusListVisible = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _timeRemaining.inSeconds > 0) {
        setState(() {
          _timeRemaining = _timeRemaining - const Duration(seconds: 1);
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Bonjour, Chami', // Placeholder name
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 28),
          ),
          const SizedBox(width: 8),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/bus_sample.jpg'), // Placeholder image
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NextBusCard(
                timeRemaining: _timeRemaining,
                onDetailsPressed: () {
                  setState(() {
                    _isBusListVisible = !_isBusListVisible;
                  });
                },
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.vertical,
                      child: child,
                    ),
                  );
                },
                child: _isBusListVisible
                    ? const UpcomingBusList()
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              // Quick Action Buttons Section
              Text(
                'Actions Rapides',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionButton(
                    context,
                    icon: Icons.confirmation_num_outlined,
                    label: 'Réserver',
                    onTap: () => context.push('/reservation-entry'),
                  ),
                  _buildQuickActionButton(
                    context,
                    icon: Icons.airplane_ticket_outlined,
                    label: 'Mes Tickets',
                    onTap: () => context.go('/tickets'),
                  ),
                //   _buildQuickActionButton(
                //     context,
                //     icon: Icons.search,
                //     label: 'Rechercher',
                //     onTap: () => context.go('/routes'),
                //   ),
                 ],
              ),
              const SizedBox(height: 32), // Spacing before RouteHighlights
              const RouteHighlights(),
              const SizedBox(height: 24),
              const PromoCarousel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: IconButton(
            icon: Icon(icon, color: AppColors.primary, size: 24),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textPrimary)),
      ],
    );
  }
}
