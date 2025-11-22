import 'dart:async';
import 'package:flutter/material.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  final List<Widget> _promoPages = [
    _buildPromoPage(
        imagePath: 'assets/images/bus_sample.jpg',
        text: 'Voyagez en toute sécurité'),
    _buildPromoPage(
        imagePath: 'assets/images/logo_lk.png',
        text: 'LKTrans, votre partenaire mobilité'),
    _buildPromoPage(
        color: Colors.cyan, text: 'Promotions exclusives à venir !'),
    _buildPromoPage(
        imagePath: 'assets/images/logo_lk.png',
        text: 'LKTrans, votre partenaire mobilité'),
    _buildPromoPage(
        color: Colors.cyan, text: 'Promotions exclusives à venir !'),
    _buildPromoPage(
        imagePath: 'assets/images/logo_lk.png',
        text: 'LKTrans, votre partenaire mobilité'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _promoPages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150, // Taille réduite
          child: PageView.builder(
            controller: _pageController,
            itemCount: _promoPages.length,
            itemBuilder: (context, index) {
              return _promoPages[index];
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promoPages.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

Widget _buildPromoPage(
    {String? imagePath, Color? color, required String text}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: color,
      image: imagePath != null
          ? DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover)
          : null,
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.6), Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}
