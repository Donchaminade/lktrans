import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final bool elevated;

  const AppButton({required this.label, this.onPressed, this.width, this.elevated = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: width ?? double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
      ),
    );

    return elevated
        ? ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(padding: EdgeInsets.zero), child: child)
        : TextButton(onPressed: onPressed, child: child);
  }
}
