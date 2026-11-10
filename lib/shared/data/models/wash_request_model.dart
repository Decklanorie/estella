import 'package:cloud_firestore/cloud_firestore.dart';
import 'car_model.dart';

class WashLocation {
  final String address;
  final String description;
  final double? lat;
  final double? lng;

  const WashLocation({
    this.address = '',
    this.description = '',
    this.lat,
    this.lng,
  });

  factory WashLocation.fromMap(Map<String, dynamic> map) {
    final gp = map['geopoint'] as GeoPoint?;
    return WashLocation(
      address: map['address'] ?? '',
      description: map['description'] ?? '',
      lat: gp?.latitude,
      lng: gp?.longitude,
    );
  }

  Map<String, dynamic> toMap() => {
        'address': address,
        'description': description,
        if (lat != null && lng != null) 'geopoint': GeoPoint(lat!, lng!),
      };

  bool get hasLocation =>
      address.isNotEmpty || description.isNotEmpty || (lat != null && lng != null);

  String get displayText {
    if (address.isNotEmpty) return address;
    if (description.isNotEmpty) return description;
    if (lat != null && lng != null) return '$lat, $lng';
    return '';
  }
}

class WashRequestModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final CarModel car;
  final WashLocation location;
  final String serviceType;
  final double fee;
  final DateTime scheduledTime;
  final String paymentMethod;
  final String status;
  final String? washerId;
  final String? washerName;
  final String? washerPhone;
  final String? washerPhoto;
  final String? washerIcon;
  final GeoPoint? washerLocation;
  final List<Map<String, dynamic>> washers;
  final String confirmationCode;
  final DateTime createdAt;
  final DateTime? updatedAt;
  // Ratings
  final double? ownerRating;
  final String? ownerRatingComment;
  final double? washerRating;
  final String? washerRatingComment;

  const WashRequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.car,
    required this.location,
    required this.serviceType,
    required this.fee,
    required this.scheduledTime,
    required this.paymentMethod,
    required this.status,
    this.washerId,
    this.washerName,
    this.washerPhone,
    this.washerPhoto,
    this.washerIcon,
    this.washerLocation,
    this.washers = const [],
    required this.confirmationCode,
    required this.createdAt,
    this.updatedAt,
    this.ownerRating,
    this.ownerRatingComment,
    this.washerRating,
    this.washerRatingComment,
  });

  factory WashRequestModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return WashRequestModel.fromMap(map, doc.id);
  }

  factory WashRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return WashRequestModel(
      id: docId,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      car: CarModel.fromMap(Map<String, dynamic>.from(map['car'] ?? {})),
      location: WashLocation.fromMap(Map<String, dynamic>.from(map['location'] ?? {})),
      serviceType: map['serviceType'] ?? 'exteriorAndInterior',
      fee: (map['fee'] ?? 0).toDouble(),
      scheduledTime: map['scheduledTime'] is Timestamp
          ? (map['scheduledTime'] as Timestamp).toDate()
          : DateTime.now(),
      paymentMethod: map['paymentMethod'] ?? 'cash',
      status: map['status'] ?? 'pending',
      washerId: map['washerId'],
      washerName: map['washerName'],
      washerPhone: map['washerPhone'],
      washerPhoto: map['washerPhoto'],
      washerIcon: map['washerIcon'],
      washerLocation: map['washerLocation'] as GeoPoint?,
      washers: List<Map<String, dynamic>>.from(
          (map['washers'] as List? ?? []).map((e) => Map<String, dynamic>.from(e))),
      confirmationCode: map['confirmationCode'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      ownerRating: map['ownerRating'] != null
          ? (map['ownerRating'] as num).toDouble()
          : null,
      ownerRatingComment: map['ownerRatingComment'],
      washerRating: map['washerRating'] != null
          ? (map['washerRating'] as num).toDouble()
          : null,
      washerRatingComment: map['washerRatingComment'],
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userName': userName,
        'userPhone': userPhone,
        'car': car.toMap(),
        'location': location.toMap(),
        'serviceType': serviceType,
        'fee': fee,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'paymentMethod': paymentMethod,
        'status': status,
        if (washerId != null) 'washerId': washerId,
        if (washerName != null) 'washerName': washerName,
        if (washerPhone != null) 'washerPhone': washerPhone,
        if (washerPhoto != null) 'washerPhoto': washerPhoto,
        if (washerIcon != null) 'washerIcon': washerIcon,
        if (washerLocation != null) 'washerLocation': washerLocation,
        'washers': washers,
        'confirmationCode': confirmationCode,
        'createdAt': Timestamp.fromDate(createdAt),
        if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
        if (ownerRating != null) 'ownerRating': ownerRating,
        if (ownerRatingComment != null) 'ownerRatingComment': ownerRatingComment,
        if (washerRating != null) 'washerRating': washerRating,
        if (washerRatingComment != null) 'washerRatingComment': washerRatingComment,
      };

  String get serviceLabel {
    switch (serviceType) {
      case 'exteriorOnly':
        return 'Exterior Only';
      case 'interiorOnly':
        return 'Interior Only';
      default:
        return 'Exterior & Interior';
    }
  }

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Waiting for acceptance';
      case 'accepted':
        return 'Request accepted';
      case 'washer_on_way':
        return 'Washer on the way';
      case 'washer_arrived':
        return 'Washer arrived';
      case 'in_progress':
        return 'Wash in progress';
      case 'wash_ended':
        return 'Wash complete';
      case 'payment_made':
        return 'Payment confirmed';
      case 'completed':
        return 'Service completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  int get statusStep {
    const steps = [
      'pending',
      'accepted',
      'washer_on_way',
      'washer_arrived',
      'in_progress',
      'wash_ended',
      'payment_made',
      'completed',
    ];
    return steps.indexOf(status);
  }

  bool get isOwnerRated => ownerRating != null;
  bool get isWasherRated => washerRating != null;
}
