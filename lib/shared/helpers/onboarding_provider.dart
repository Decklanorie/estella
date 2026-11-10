import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/car_model.dart';
import '../data/models/wash_request_model.dart';

class OnboardingState {
  final String phone;
  final String name;
  final bool isExistingUser;
  final String? existingUserId;
  final List<CarModel> existingCars;
  final CarModel? selectedCar;
  final bool isAddingNewCar;
  // New car fields
  final String newCarBrand;
  final String newCarType;
  final String newCarColor;
  final String newCarPlate;
  // Location (used in screen 4 for new users, screen 6 for existing)
  final WashLocation location;
  // Booking
  final String serviceType;
  final DateTime? scheduledTime;
  final String paymentMethod;
  final Map<String, dynamic> carPrices;
  final String? washRequestId;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.phone = '',
    this.name = '',
    this.isExistingUser = false,
    this.existingUserId,
    this.existingCars = const [],
    this.selectedCar,
    this.isAddingNewCar = false,
    this.newCarBrand = '',
    this.newCarType = '',
    this.newCarColor = '',
    this.newCarPlate = '',
    this.location = const WashLocation(),
    this.serviceType = 'exteriorAndInterior',
    this.scheduledTime,
    this.paymentMethod = 'cash',
    this.carPrices = const {},
    this.washRequestId,
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    String? phone,
    String? name,
    bool? isExistingUser,
    String? existingUserId,
    List<CarModel>? existingCars,
    CarModel? selectedCar,
    bool? isAddingNewCar,
    String? newCarBrand,
    String? newCarType,
    String? newCarColor,
    String? newCarPlate,
    WashLocation? location,
    String? serviceType,
    DateTime? scheduledTime,
    String? paymentMethod,
    Map<String, dynamic>? carPrices,
    String? washRequestId,
    bool? isLoading,
    String? error,
    bool clearSelectedCar = false,
    bool clearError = false,
  }) {
    return OnboardingState(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      isExistingUser: isExistingUser ?? this.isExistingUser,
      existingUserId: existingUserId ?? this.existingUserId,
      existingCars: existingCars ?? this.existingCars,
      selectedCar: clearSelectedCar ? null : (selectedCar ?? this.selectedCar),
      isAddingNewCar: isAddingNewCar ?? this.isAddingNewCar,
      newCarBrand: newCarBrand ?? this.newCarBrand,
      newCarType: newCarType ?? this.newCarType,
      newCarColor: newCarColor ?? this.newCarColor,
      newCarPlate: newCarPlate ?? this.newCarPlate,
      location: location ?? this.location,
      serviceType: serviceType ?? this.serviceType,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      carPrices: carPrices ?? this.carPrices,
      washRequestId: washRequestId ?? this.washRequestId,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  CarModel? get activeCar {
    if (selectedCar != null) return selectedCar;
    if (newCarType.isNotEmpty) {
      return CarModel(
        id: '',
        brand: newCarBrand,
        type: newCarType,
        color: newCarColor,
        platePrefix: newCarPlate,
        createdAt: DateTime.now(),
      );
    }
    return null;
  }

  double get activePrice {
    final car = activeCar;
    if (car == null || carPrices.isEmpty) return 0;
    final typeKey = car.type;
    final typePrices = carPrices[typeKey]?['prices'] as Map? ?? {};
    return (typePrices[serviceType] ?? 0).toDouble();
  }

  bool get needsCarDetails =>
      !isExistingUser || isAddingNewCar;

  bool get needsPhoneConfirm => !isExistingUser;

  bool get showLocationInBooking =>
      isExistingUser && !isAddingNewCar;
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void setPhone(String phone) =>
      state = state.copyWith(phone: phone, clearError: true);

  void setName(String name) => state = state.copyWith(name: name);

  void setExistingUser({
    required String userId,
    required List<CarModel> cars,
    String? name,
  }) {
    state = state.copyWith(
      isExistingUser: true,
      existingUserId: userId,
      existingCars: cars,
      name: name ?? state.name,
    );
  }

  void setNewUser() {
    state = state.copyWith(isExistingUser: false);
  }

  void selectExistingCar(CarModel car) {
    state = state.copyWith(
      selectedCar: car,
      isAddingNewCar: false,
      newCarType: '',
    );
  }

  void startAddingNewCar() {
    state = state.copyWith(
      isAddingNewCar: true,
      clearSelectedCar: true,
    );
  }

  void setNewCarBrand(String brand) =>
      state = state.copyWith(newCarBrand: brand);

  void setNewCarType(String type) =>
      state = state.copyWith(newCarType: type);

  void setNewCarColor(String color) =>
      state = state.copyWith(newCarColor: color);

  void setNewCarPlate(String plate) =>
      state = state.copyWith(newCarPlate: plate);

  void setLocation(WashLocation location) =>
      state = state.copyWith(location: location);

  void setServiceType(String type) =>
      state = state.copyWith(serviceType: type);

  void setScheduledTime(DateTime time) =>
      state = state.copyWith(scheduledTime: time);

  void setPaymentMethod(String method) =>
      state = state.copyWith(paymentMethod: method);

  void setCarPrices(Map<String, dynamic> prices) =>
      state = state.copyWith(carPrices: prices);

  void setWashRequestId(String id) =>
      state = state.copyWith(washRequestId: id);

  void setLoading(bool loading) =>
      state = state.copyWith(isLoading: loading);

  void setError(String? error) => state = state.copyWith(error: error);

  void reset() => state = const OnboardingState();
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);
