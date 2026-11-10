import 'package:cloud_firestore/cloud_firestore.dart';
import 'car_model.dart';

class UserModel {
  String? id;
  String? fullName;
  String? phone;
  String? email;
  String? photoURL;
  List<CarModel> cars;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.photoURL,
    this.cars = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return UserModel(
      id: docId ?? map['id'] as String?,
      fullName: map['fullName'] as String?,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      photoURL: map['photoURL'] as String?,
      cars: (map['cars'] as List? ?? [])
          .map((c) => CarModel.fromMap(Map<String, dynamic>.from(c as Map)))
          .toList(),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Keep fromJson for backward compatibility
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel.fromMap(json);

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'photoURL': photoURL,
        'cars': cars.map((c) => c.toMap()).toList(),
        'createdAt':
            createdAt != null ? Timestamp.fromDate(createdAt!) : Timestamp.now(),
        'updatedAt':
            updatedAt != null ? Timestamp.fromDate(updatedAt!) : Timestamp.now(),
      };

  Map<String, dynamic> toJson() => toMap();
}
