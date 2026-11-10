import 'package:go_router/go_router.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/features/splash/presentation/pages/index.dart';
import 'package:estella/features/role_selection/presentation/pages/role_selection_screen.dart';
import 'package:estella/features/phone_entry/presentation/pages/phone_entry_screen.dart';
import 'package:estella/features/name_entry/presentation/pages/name_entry_screen.dart';
import 'package:estella/features/car_selection/presentation/pages/car_selection_screen.dart';
import 'package:estella/features/car_details/presentation/pages/car_details_screen.dart';
import 'package:estella/features/phone_confirm/presentation/pages/phone_confirm_screen.dart';
import 'package:estella/features/booking/presentation/pages/booking_screen.dart';
import 'package:estella/features/wash_status/presentation/pages/wash_status_screen.dart';
import 'package:estella/features/wash_history/presentation/pages/wash_history_screen.dart';
import 'package:estella/features/rating/presentation/pages/rating_screen.dart';
import 'package:estella/features/washer/presentation/pages/washer_login_screen.dart';
import 'package:estella/features/washer/presentation/pages/washer_dashboard_screen.dart';
import 'package:estella/features/washer/presentation/pages/washer_job_screen.dart';

final router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const Splash(),
    ),
    GoRoute(
      path: AppRoutes.roleSelection,
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.phoneEntry,
      builder: (context, state) => const PhoneEntryScreen(),
    ),
    GoRoute(
      path: AppRoutes.nameEntry,
      builder: (context, state) => const NameEntryScreen(),
    ),
    GoRoute(
      path: AppRoutes.carSelection,
      builder: (context, state) => const CarSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.carDetails,
      builder: (context, state) => const CarDetailsScreen(),
    ),
    GoRoute(
      path: AppRoutes.phoneConfirm,
      builder: (context, state) => const PhoneConfirmScreen(),
    ),
    GoRoute(
      path: AppRoutes.booking,
      builder: (context, state) => const BookingScreen(),
    ),
    GoRoute(
      path: AppRoutes.washStatus,
      builder: (context, state) {
        final showBackButton = (state.extra as bool?) ?? false;
        return WashStatusScreen(showBackButton: showBackButton);
      },
    ),
    GoRoute(
      path: AppRoutes.washHistory,
      builder: (context, state) => const WashHistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.rating,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return RatingScreen(
          requestId: extra['requestId'] as String,
          role: extra['role'] as String,
        );
      },
    ),
    // Washer routes
    GoRoute(
      path: AppRoutes.washerLogin,
      builder: (context, state) => const WasherLoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.washerDashboard,
      builder: (context, state) => const WasherDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.washerJob,
      builder: (context, state) {
        final requestId = state.extra as String;
        return WasherJobScreen(requestId: requestId);
      },
    ),
  ],
);
