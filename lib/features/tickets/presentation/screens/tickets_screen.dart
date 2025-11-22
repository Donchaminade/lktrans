import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lktrans/features/tickets/presentation/widgets/ticket_card.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _upcomingTickets = [
    {
      'from': 'Abidjan',
      'to': 'Yamoussoukro',
      'date': '25 déc. 2025',
      'time': '14:00',
      'status': TicketStatus.upcoming,
      'passengerName': 'Chami Ben',
    },
    {
      'from': 'Yamoussoukro',
      'to': 'Bouaké',
      'date': '01 jan. 2026',
      'time': '08:30',
      'status': TicketStatus.upcoming,
      'passengerName': 'Chami Ben',
    },
  ];

  final List<Map<String, dynamic>> _pastTickets = [
    {
      'from': 'Abidjan',
      'to': 'Grand-Bassam',
      'date': '10 nov. 2025',
      'time': '10:00',
      'status': TicketStatus.past,
      'passengerName': 'Chami Ben',
    },
    {
      'from': 'Abidjan',
      'to': 'Daloa',
      'date': '05 oct. 2025',
      'time': '18:00',
      'status': TicketStatus.past,
      'passengerName': 'Chami Ben',
    },
    {
      'from': 'Korhogo',
      'to': 'Abidjan',
      'date': '20 sept. 2025',
      'time': '22:00',
      'status': TicketStatus.cancelled,
      'passengerName': 'Chami Ben',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Tickets'),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: textTheme.titleMedium,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'Tickets à venir'),
            Tab(text: 'Historique'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming Tickets Tab
          _upcomingTickets.isEmpty
              ? const Center(child: Text('Aucun ticket à venir.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _upcomingTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _upcomingTickets[index];
                    return TicketCard(
                      from: ticket['from']!,
                      to: ticket['to']!,
                      date: ticket['date']!,
                      time: ticket['time']!,
                      status: ticket['status']!,
                      passengerName: ticket['passengerName']!,
                      onTap: () {
                        context.push('/ticket-details', extra: ticket);
                      },
                    );
                  },
                ),
          // History Tab
          _pastTickets.isEmpty
              ? const Center(child: Text('Aucun historique de tickets.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _pastTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _pastTickets[index];
                    return TicketCard(
                      from: ticket['from']!,
                      to: ticket['to']!,
                      date: ticket['date']!,
                      time: ticket['time']!,
                      status: ticket['status']!,
                      passengerName: ticket['passengerName']!,
                      onTap: () {
                        context.push('/ticket-details', extra: ticket);
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}