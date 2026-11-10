import 'package:cloud_firestore/cloud_firestore.dart';

class CarModel {
  final String id;
  final String brand;
  final String type; // 'saloon', 'suv', 'van'
  final String color;
  final String platePrefix;
  final DateTime createdAt;

  const CarModel({
    required this.id,
    required this.brand,
    required this.type,
    required this.color,
    required this.platePrefix,
    required this.createdAt,
  });

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] ?? '',
      brand: map['brand'] ?? '',
      type: map['type'] ?? 'saloon',
      color: map['color'] ?? '',
      platePrefix: map['platePrefix'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'brand': brand,
        'type': type,
        'color': color,
        'platePrefix': platePrefix,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  CarModel copyWith({
    String? id,
    String? brand,
    String? type,
    String? color,
    String? platePrefix,
    DateTime? createdAt,
  }) {
    return CarModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      type: type ?? this.type,
      color: color ?? this.color,
      platePrefix: platePrefix ?? this.platePrefix,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get assetImage {
    switch (type) {
      case 'suv':
        return 'assets/images/suv.png';
      case 'van':
        return 'assets/images/van.png';
      default:
        return 'assets/images/saloon.png';
    }
  }

  String get displayType {
    switch (type) {
      case 'suv':
        return 'SUV';
      case 'van':
        return 'Van';
      default:
        return 'Saloon';
    }
  }
}
