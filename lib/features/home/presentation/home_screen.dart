import 'package:flutter/material.dart';
import '../widgets/reservation_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LK Transport')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: const [
          ReservationCard(),
          SizedBox(height: 18),
          Text('Nos Bus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 10),
          _BusCarouselPlaceholder(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historique'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètre'),
        ],
      ),
    );
  }
}

class _BusCarouselPlaceholder extends StatelessWidget {
  const _BusCarouselPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => Container(
          width: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: const DecorationImage(image: AssetImage('assets/images/bus_sample.jpg'), fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
