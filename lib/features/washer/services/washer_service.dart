import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estella/features/washer/data/models/washer_model.dart';
import 'package:estella/shared/data/models/wash_request_model.dart';

class WasherService {
  static final _db = FirebaseFirestore.instance;

  static Future<WasherModel?> getWasherByPhone(String phone) async {
    final snap = await _db
        .collection('washers')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    final doc = snap.docs.first;
    return WasherModel.fromMap(doc.data(), doc.id);
  }

  static Future<WasherModel?> getWasherById(String id) async {
    final doc = await _db.collection('washers').doc(id).get();
    if (!doc.exists) return null;
    return WasherModel.fromDoc(doc);
  }

  static Stream<List<WashRequestModel>> streamAvailableJobs() {
    return _db
        .collection('car-wash')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snap) {
      final results = snap.docs.map((d) => WashRequestModel.fromDoc(d)).toList();
      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return results;
    });
  }

  static Stream<WashRequestModel?> streamActiveJob(String washerId) {
    return _db
        .collection('car-wash')
        .where('washerId', isEqualTo: washerId)
        .where('status', whereIn: [
          'accepted',
          'washer_on_way',
          'washer_arrived',
          'in_progress',
          'wash_ended',
          'payment_made',
        ])
        .limit(1)
        .snapshots()
        .map((snap) {
          if (snap.docs.isEmpty) return null;
          return WashRequestModel.fromDoc(snap.docs.first);
        });
  }

  static Future<List<WashRequestModel>> getWasherHistory(String washerId) async {
    final snap = await _db
        .collection('car-wash')
        .where('washerId', isEqualTo: washerId)
        .where('status', whereIn: ['completed', 'cancelled'])
        .limit(50)
        .get();
    final results = snap.docs.map((d) => WashRequestModel.fromDoc(d)).toList();
    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  static Future<void> acceptJob(
      String requestId, WasherModel washer) async {
    await _db.collection('car-wash').doc(requestId).update({
      'status': 'accepted',
      'washerId': washer.id,
      'washerName': washer.name,
      'washerPhone': washer.phone,
      if (washer.photo != null) 'washerPhoto': washer.photo,
      'updatedAt': Timestamp.now(),
    });
  }

  static Future<void> updateJobStatus(String requestId, String status) async {
    await _db.collection('car-wash').doc(requestId).update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  static Future<void> confirmPayment(
      String requestId, String paymentMethod) async {
    await _db.collection('car-wash').doc(requestId).update({
      'status': 'payment_made',
      'paymentConfirmedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  static Future<void> completeJob(String requestId, String washerId) async {
    await _db.collection('car-wash').doc(requestId).update({
      'status': 'completed',
      'updatedAt': Timestamp.now(),
    });
    // Update washer stats
    await _db.collection('washers').doc(washerId).update({
      'totalJobs': FieldValue.increment(1),
      'updatedAt': Timestamp.now(),
    });
  }

  static Future<void> submitOwnerRating({
    required String requestId,
    required double rating,
    required String comment,
    required String washerId,
  }) async {
    await _db.collection('car-wash').doc(requestId).update({
      'ownerRating': rating,
      'ownerRatingComment': comment,
      'updatedAt': Timestamp.now(),
    });
    // Update washer's overall rating (simple average approximation)
    final washerDoc = await _db.collection('washers').doc(washerId).get();
    if (washerDoc.exists) {
      final data = washerDoc.data()!;
      final currentRating = (data['rating'] ?? 0.0).toDouble();
      final totalJobs = (data['totalJobs'] ?? 1) as int;
      final newRating = ((currentRating * (totalJobs - 1)) + rating) / totalJobs;
      await _db.collection('washers').doc(washerId).update({
        'rating': newRating,
      });
    }
  }

  static Future<void> submitWasherRating({
    required String requestId,
    required double rating,
    required String comment,
  }) async {
    await _db.collection('car-wash').doc(requestId).update({
      'washerRating': rating,
      'washerRatingComment': comment,
      'updatedAt': Timestamp.now(),
    });
  }

  static Stream<WashRequestModel> streamJob(String requestId) {
    return _db
        .collection('car-wash')
        .doc(requestId)
        .snapshots()
        .where((snap) => snap.exists)
        .map((snap) => WashRequestModel.fromDoc(snap));
  }
}
