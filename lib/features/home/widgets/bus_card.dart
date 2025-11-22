import 'package:flutter/material.dart';

class BusCard extends StatelessWidget {
  final String title;
  final String image;
  const BusCard({required this.title, required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
      child: Align(alignment: Alignment.bottomLeft, child: Padding(padding: const EdgeInsets.all(12), child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
    );
  }
}
