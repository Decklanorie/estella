import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/features/washer/data/providers/washer_provider.dart';
import 'package:estella/features/washer/services/washer_service.dart';
import 'package:estella/shared/helpers/onboarding_provider.dart';
import 'package:estella/shared/services/wash_service.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final strings = Hive.box<String>('strings');
    final washerId = strings.get('washerId');
    final userId = strings.get('userId');

    // Washer session takes priority
    if (washerId != null && washerId.isNotEmpty) {
      try {
        final washer = await WasherService.getWasherById(washerId);
        if (!mounted) return;
        if (washer != null) {
          ref.read(washerProvider.notifier).setWasher(washer);
          context.go(AppRoutes.washerDashboard);
          return;
        }
      } catch (_) {}
      // Clear stale washerId
      await strings.delete('washerId');
    }

    // Car owner session
    if (userId != null && userId.isNotEmpty) {
      try {
        final user = await WashService.getUserById(userId);
        if (!mounted) return;
        if (user != null) {
          ref.read(onboardingProvider.notifier).setExistingUser(
                userId: userId,
                cars: user.cars,
                name: user.fullName ?? '',
              );
          context.go(AppRoutes.carSelection);
          return;
        }
      } catch (_) {}
    }

    if (mounted) context.go(AppRoutes.roleSelection);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.splashBackground,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.splashBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Image.asset('assets/images/splash.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
