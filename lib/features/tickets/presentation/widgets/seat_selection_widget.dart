import 'package:flutter/material.dart';
import 'package:lktrans/core/constants/app_colors.dart';

class SeatWidget extends StatelessWidget {
  final int seatNumber;
  final bool isSelected;
  final bool isAvailable;
  final ValueChanged<int> onSeatTap;

  const SeatWidget({
    super.key,
    required this.seatNumber,
    required this.isSelected,
    required this.isAvailable,
    required this.onSeatTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (!isAvailable) {
        return Colors.grey.shade400;
      }
      if (isSelected) {
        return AppColors.primary;
      }
      return Colors.white;
    }

    return GestureDetector(
      onTap: isAvailable ? () => onSeatTap(seatNumber) : null,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: getColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isAvailable ? AppColors.primary : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            '$seatNumber',
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SeatSelectionWidget extends StatefulWidget {
  final int seatsToSelect;
  final Set<int> initialSelectedSeats;
  final Set<int> unavailableSeats;

  const SeatSelectionWidget({
    super.key,
    required this.seatsToSelect,
    required this.initialSelectedSeats,
    required this.unavailableSeats,
  });

  @override
  State<SeatSelectionWidget> createState() => _SeatSelectionWidgetState();
}

class _SeatSelectionWidgetState extends State<SeatSelectionWidget> {
  late Set<int> _selectedSeats;

  @override
  void initState() {
    super.initState();
    _selectedSeats = Set.from(widget.initialSelectedSeats);
  }

  void _handleSeatTap(int seatNumber) {
    setState(() {
      if (_selectedSeats.contains(seatNumber)) {
        _selectedSeats.remove(seatNumber);
      } else {
        if (_selectedSeats.length < widget.seatsToSelect) {
          _selectedSeats.add(seatNumber);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vous ne pouvez sélectionner que ${widget.seatsToSelect} siège(s).'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Choisissez vos sièges',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: 50, // Total seats
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // 4 seats + 1 aisle
              ),
              itemBuilder: (context, index) {
                final seatNumber = index + 1;
                // Simple aisle logic
                if ((index + 1) % 5 == 3) {
                  return const SizedBox.shrink(); // Aisle
                }
                return SeatWidget(
                  seatNumber: seatNumber,
                  isSelected: _selectedSeats.contains(seatNumber),
                  isAvailable: !widget.unavailableSeats.contains(seatNumber),
                  onSeatTap: _handleSeatTap,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedSeats);
            },
            child: const Text('Confirmer la sélection'),
          ),
        ],
      ),
    );
  }
}
