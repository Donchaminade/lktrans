import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/geometric_background.dart';
import 'package:lktrans/core/widgets/loading_button.dart';
import 'package:lktrans/features/tickets/presentation/widgets/ticket_card.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

enum TicketFilter { all, upcoming, cancelled, past }

class _TicketsScreenState extends State<TicketsScreen> {
  final TextEditingController _searchController = TextEditingController();
  TicketFilter _currentFilter = TicketFilter.all;

  final List<Map<String, dynamic>> _allTickets = [
    {
      'id': 'T001',
      'from': 'Abidjan',
      'to': 'Yamoussoukro',
      'date': '25 déc. 2025',
      'time': '14:00',
      'status': TicketStatus.upcoming,
      'passengerName': 'Chami Ben',
      'reservationCode': 'ABCDE12345',
    },
    {
      'id': 'T002',
      'from': 'Yamoussoukro',
      'to': 'Bouaké',
      'date': '01 jan. 2026',
      'time': '08:30',
      'status': TicketStatus.upcoming,
      'passengerName': 'Chami Ben',
      'reservationCode': 'FGHIJ67890',
    },
    {
      'id': 'T003',
      'from': 'Abidjan',
      'to': 'Grand-Bassam',
      'date': '10 nov. 2025',
      'time': '10:00',
      'status': TicketStatus.past,
      'passengerName': 'Chami Ben',
      'reservationCode': 'KLMNO11223',
    },
    {
      'id': 'T004',
      'from': 'Abidjan',
      'to': 'Daloa',
      'date': '05 oct. 2025',
      'time': '18:00',
      'status': TicketStatus.past,
      'passengerName': 'Chami Ben',
      'reservationCode': 'PQRST44556',
    },
    {
      'id': 'T005',
      'from': 'Korhogo',
      'to': 'Abidjan',
      'date': '20 sept. 2025',
      'time': '22:00',
      'status': TicketStatus.cancelled,
      'passengerName': 'Chami Ben',
      'reservationCode': 'UVWXY77889',
    },
  ];

  List<Map<String, dynamic>> get _filteredTickets {
    return _allTickets.where((ticket) {
      final matchesSearch = _searchController.text.isEmpty ||
          (ticket['date'] as String).toLowerCase().contains(_searchController.text.toLowerCase()) ||
          (ticket['passengerName'] as String).toLowerCase().contains(_searchController.text.toLowerCase());

      final matchesFilter = _currentFilter == TicketFilter.all ||
          (_currentFilter == TicketFilter.upcoming && ticket['status'] == TicketStatus.upcoming) ||
          (_currentFilter == TicketFilter.cancelled && ticket['status'] == TicketStatus.cancelled) ||
          (_currentFilter == TicketFilter.past && ticket['status'] == TicketStatus.past);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Tickets'),
      ),
      body: Stack(
        children: [
          const GeometricBackground(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _searchController,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Rechercher par date ou passager',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildFilterChip(context, 'Tous', TicketFilter.all),
                            _buildFilterChip(context, 'À venir', TicketFilter.upcoming),
                            _buildFilterChip(context, 'Annulés', TicketFilter.cancelled),
                            _buildFilterChip(context, 'Terminés', TicketFilter.past),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _filteredTickets.isEmpty
                      ? Center(child: Text('Aucun ticket trouvé.', style: textTheme.bodyLarge))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: _filteredTickets.length,
                          itemBuilder: (context, index) {
                            final ticket = _filteredTickets[index];
                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 50 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: TicketCard(
                                from: ticket['from']!,
                                to: ticket['to']!,
                                date: ticket['date']!,
                                time: ticket['time']!,
                                status: ticket['status']!,
                                passengerName: ticket['passengerName']!,
                                onTap: () {
                                  context.push('/ticket-details', extra: ticket);
                                },
                              ),
                            );
                          },
                        ),
                ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(16.0),
                                                                      child: LoadingButton(
                                                                        onPressed: () async {
                                                                          context.push('/reservation'); // Navigates directly to ReservationScreen
                                                                        },
                                                                        text: 'Faire une réservation',
                                                                      ),
                                                                    ),              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, TicketFilter filter) {
    final isSelected = _currentFilter == filter;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _currentFilter = filter;
          });
        },
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
        showCheckmark: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), // Consistent rounded corners
      ),
    );
  }
}