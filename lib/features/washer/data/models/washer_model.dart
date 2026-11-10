import 'package:cloud_firestore/cloud_firestore.dart';

class WasherModel {
  final String id;
  final String name;
  final String phone;
  final String pin;
  final String? photo;
  final double rating;
  final int totalJobs;
  final double totalEarnings;
  final bool isAvailable;
  final DateTime createdAt;

  const WasherModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.pin,
    this.photo,
    this.rating = 0.0,
    this.totalJobs = 0,
    this.totalEarnings = 0.0,
    this.isAvailable = true,
    required this.createdAt,
  });

  factory WasherModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return WasherModel.fromMap(map, doc.id);
  }

  factory WasherModel.fromMap(Map<String, dynamic> map, String docId) {
    return WasherModel(
      id: docId,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      pin: map['pin'] ?? '',
      photo: map['photo'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalJobs: (map['totalJobs'] ?? 0) as int,
      totalEarnings: (map['totalEarnings'] ?? 0.0).toDouble(),
      isAvailable: map['isAvailable'] ?? true,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'pin': pin,
        if (photo != null) 'photo': photo,
        'rating': rating,
        'totalJobs': totalJobs,
        'totalEarnings': totalEarnings,
        'isAvailable': isAvailable,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  String get initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
