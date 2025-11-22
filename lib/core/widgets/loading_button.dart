import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';
import 'package:lktrans/core/widgets/music_wave_loader.dart';

class LoadingButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final String text;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isProcessing = false;

  void _showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.card.withOpacity(0.4), // Fond vert transparent
          elevation: 0,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: MusicWaveLoader(),
          ),
        );
      },
    );
  }

  void _handlePress() async {
    if (widget.onPressed == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    _showLoader(context);

    // Simulate network request for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    
    // Execute the actual function
    if (widget.onPressed != null) {
      await widget.onPressed!();
    }

    // Hide loader
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handlePress,
      child: Text(widget.text),
    );
  }
}
