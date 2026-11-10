import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/car_model.dart';
import '../data/models/user_model.dart';
import '../data/models/wash_request_model.dart';

class WashService {
  static final _db = FirebaseFirestore.instance;

  static Future<UserModel?> getUserByPhone(String phone) async {
    final snap = await _db
        .collection('users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    final doc = snap.docs.first;
    return UserModel.fromMap(doc.data(), doc.id);
  }

  static Future<String> createUser({
    required String phone,
    required String name,
  }) async {
    final ref = _db.collection('users').doc();
    final user = UserModel(
      id: ref.id,
      fullName: name,
      phone: phone,
      cars: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.set(user.toMap());
    return ref.id;
  }

  static Future<String> addCarToUser(String userId, CarModel car) async {
    final id = _db.collection('users').doc().id;
    final carWithId = car.copyWith(id: id);
    await _db.collection('users').doc(userId).update({
      'cars': FieldValue.arrayUnion([carWithId.toMap()]),
      'updatedAt': Timestamp.now(),
    });
    return id;
  }

  static Future<UserModel?> getUserById(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  static Future<Map<String, dynamic>> getCarPrices() async {
    final doc = await _db.collection('general').doc('cars').get();
    return doc.data() ?? {};
  }

  static Future<String> createWashRequest(WashRequestModel request) async {
    final ref = _db.collection('car-wash').doc();
    final map = request.toMap();
    map['id'] = ref.id;
    await ref.set(map);
    return ref.id;
  }

  static Stream<WashRequestModel> streamWashRequest(String requestId) {
    return _db
        .collection('car-wash')
        .doc(requestId)
        .snapshots()
        .where((snap) => snap.exists)
        .map((snap) => WashRequestModel.fromDoc(snap));
  }

  static Future<List<WashRequestModel>> getUserWashHistory(String userId) async {
    final snap = await _db
        .collection('car-wash')
        .where('userId', isEqualTo: userId)
        .limit(50)
        .get();
    final results = snap.docs.map((d) => WashRequestModel.fromDoc(d)).toList();
    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  static Future<void> cancelWashRequest(String requestId) async {
    await _db.collection('car-wash').doc(requestId).update({
      'status': 'cancelled',
      'updatedAt': Timestamp.now(),
    });
  }

  static String generateConfirmationCode() {
    final rng = Random();
    return (1000 + rng.nextInt(9000)).toString();
  }
}
