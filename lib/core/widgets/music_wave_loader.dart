import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

class MusicWaveLoader extends StatefulWidget {
  const MusicWaveLoader({super.key});

  @override
  State<MusicWaveLoader> createState() => _MusicWaveLoaderState();
}

class _MusicWaveLoaderState extends State<MusicWaveLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Staggered animation for each bar
              final delay = index * 0.2;
              final animationValue = (_controller.value + delay) % 1.0;
              final height = 10 + (Curves.easeInOut.transform(animationValue) * 40);
              
              return Container(
                width: 8,
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
