// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RouteData {
  final String departureCity;
  final String destinationCity;
  final List<String> stops;

  RouteData({
    required this.departureCity,
    required this.destinationCity,
    required this.stops,
  });
}

class BusType {
  final String name;
  final int totalSeats;
  final double priceMultiplier;
  final IconData icon;

  BusType({
    required this.name,
    required this.totalSeats,
    this.priceMultiplier = 1.0,
    required this.icon,
  });

  factory BusType.fromJson(Map<String, dynamic> json) {
    return BusType(
      name: json['name'] as String,
      totalSeats: json['totalSeats'] as int,
      priceMultiplier: (json['priceMultiplier'] as num).toDouble(),
      icon: IconData(json['iconCodePoint'] as int, fontFamily: json['iconFontFamily'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalSeats': totalSeats,
      'priceMultiplier': priceMultiplier,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
    };
  }
}

class BusInstance {
  final String id;
  final String licensePlate;
  final BusType type;
  final List<int> availableSeats;
  final TimeOfDay departureTime;

  BusInstance({
    required this.id,
    required this.licensePlate,
    required this.type,
    required this.availableSeats,
    required this.departureTime,
  });

  factory BusInstance.fromJson(Map<String, dynamic> json) {
    return BusInstance(
      id: json['id'] as String,
      licensePlate: json['licensePlate'] as String,
      type: BusType.fromJson(json['type'] as Map<String, dynamic>), // Désérialiser BusType
      availableSeats: (json['availableSeats'] as List<dynamic>).map((e) => e as int).toList(),
      departureTime: _timeOfDayFromString(json['departureTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'licensePlate': licensePlate,
      'type': type.toJson(), // Sérialiser BusType
      'availableSeats': availableSeats,
      'departureTime': '${departureTime.hour.toString().padLeft(2, '0')}:${departureTime.minute.toString().padLeft(2, '0')}',
    };
  }
}

TimeOfDay _timeOfDayFromString(String timeString) {
  final parts = timeString.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

final List<String> cities = [
  'Paris',
  'Marseille',
  'Lyon',
  'Toulouse',
  'Nice',
  'Nantes',
  'Strasbourg',
  'Montpellier',
  'Bordeaux',
  'Lille',
];

final List<RouteData> routes = [
  RouteData(
    departureCity: 'Paris',
    destinationCity: 'Marseille',
    stops: ['Lyon'],
  ),
  RouteData(
    departureCity: 'Lyon',
    destinationCity: 'Paris',
    stops: [],
  ),
  RouteData(
    departureCity: 'Paris',
    destinationCity: 'Lille',
    stops: [],
  ),
  RouteData(
    departureCity: 'Bordeaux',
    destinationCity: 'Paris',
    stops: ['Nantes'],
  ),
];

final List<BusType> busTypes = [
  BusType(name: 'Bus Standard', totalSeats: 50, priceMultiplier: 1.0, icon: Icons.airline_seat_recline_normal),
  BusType(name: 'Bus Confort', totalSeats: 40, priceMultiplier: 1.2, icon: Icons.chair),
  BusType(name: 'Bus VIP', totalSeats: 30, priceMultiplier: 1.5, icon: Icons.business_center),
];

final List<BusInstance> busInstances = [
  BusInstance(
    id: 'B001',
    licensePlate: 'AB-123-CD',
    type: busTypes[0], // Bus Standard
    availableSeats: List.generate(50, (index) => index + 1)..removeWhere((seat) => [1, 2, 3, 4, 5].contains(seat)), // 45 available
    departureTime: const TimeOfDay(hour: 8, minute: 0),
  ),
  BusInstance(
    id: 'B002',
    licensePlate: 'EF-456-GH',
    type: busTypes[0], // Bus Standard
    availableSeats: List.generate(50, (index) => index + 1)..removeWhere((seat) => [10, 11, 12].contains(seat)), // 47 available
    departureTime: const TimeOfDay(hour: 10, minute: 30),
  ),
  BusInstance(
    id: 'B003',
    licensePlate: 'IJ-789-KL',
    type: busTypes[1], // Bus Confort
    availableSeats: List.generate(40, (index) => index + 1)..removeWhere((seat) => [1, 2].contains(seat)), // 38 available
    departureTime: const TimeOfDay(hour: 9, minute: 0),
  ),
  BusInstance(
    id: 'B004',
    licensePlate: 'MN-012-OP',
    type: busTypes[2], // Bus VIP
    availableSeats: List.generate(30, (index) => index + 1)..removeWhere((seat) => [1, 2, 3].contains(seat)), // 27 available
    departureTime: const TimeOfDay(hour: 14, minute: 0),
  ),
];
