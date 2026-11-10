import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:estella/features/washer/data/models/washer_model.dart';

class WasherState {
  final WasherModel? washer;
  final bool isLoading;
  final String? error;

  const WasherState({
    this.washer,
    this.isLoading = false,
    this.error,
  });

  bool get isLoggedIn => washer != null;

  WasherState copyWith({
    WasherModel? washer,
    bool? isLoading,
    String? error,
    bool clearWasher = false,
    bool clearError = false,
  }) {
    return WasherState(
      washer: clearWasher ? null : (washer ?? this.washer),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class WasherNotifier extends StateNotifier<WasherState> {
  WasherNotifier() : super(const WasherState());

  void setWasher(WasherModel washer) {
    state = state.copyWith(washer: washer, clearError: true);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String error) {
    state = state.copyWith(error: error, clearError: false);
  }

  void signOut() {
    state = const WasherState();
  }
}

final washerProvider =
    StateNotifierProvider<WasherNotifier, WasherState>(
  (ref) => WasherNotifier(),
);
