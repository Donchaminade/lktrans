import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

enum HomeBannerType { normal, warning, success } // Type renommé

class HomeBanner extends StatefulWidget {
  final String message;
  final HomeBannerType type;
  final VoidCallback? onDismissed;

  const HomeBanner({
    super.key,
    required this.message,
    this.type = HomeBannerType.normal, // Type par défaut mis à jour
    this.onDismissed,
  });

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    Color overlayColor; // Couleur pour le dégradé et le texte
    Color textColor;
    
    // Déterminer les couleurs en fonction du type de bannière
    switch (widget.type) {
      case HomeBannerType.normal:
        overlayColor = Colors.black.withOpacity(0.5); // Ombre noire pour le texte
        textColor = Colors.white;
        break;
      case HomeBannerType.warning:
        overlayColor = Colors.orange.withOpacity(0.6);
        textColor = Colors.white;
        break;
      case HomeBannerType.success:
        overlayColor = Colors.green.withOpacity(0.6);
        textColor = Colors.white;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.card, // Couleur de fond par défaut si l'image ne charge pas
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/image.png', // Image en arrière-plan
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      overlayColor,
                      overlayColor.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Padding augmenté pour la hauteur
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.message,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (widget.onDismissed != null)
                    IconButton(
                      icon: Icon(Icons.close, color: textColor.withOpacity(0.7)),
                      onPressed: () {
                        setState(() {
                          _isVisible = false;
                        });
                        widget.onDismissed?.call();
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
