import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/shared/helpers/onboarding_provider.dart';
import 'package:estella/shared/services/wash_service.dart';

class PhoneEntryScreen extends ConsumerStatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  ConsumerState<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends ConsumerState<PhoneEntryScreen> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final digits = _controller.text.trim();
    if (digits.length < 7) return;
    final phone = '+234${digits.startsWith('0') ? digits.substring(1) : digits}';

    setState(() => _loading = true);
    try {
      final user = await WashService.getUserByPhone(phone);
      if (!mounted) return;

      ref.read(onboardingProvider.notifier).setPhone(phone);

      if (user != null) {
        ref.read(onboardingProvider.notifier).setExistingUser(
              userId: user.id!,
              cars: user.cars,
            );
        ref.read(onboardingProvider.notifier).setName(user.fullName ?? '');
        context.go(AppRoutes.carSelection);
      } else {
        ref.read(onboardingProvider.notifier).setNewUser();
        context.push(AppRoutes.nameEntry);
      }
    } catch (_) {
      ref.read(onboardingProvider.notifier).setPhone(
            '+234${_controller.text.trim()}',
          );
      ref.read(onboardingProvider.notifier).setNewUser();
      context.push(AppRoutes.nameEntry);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.roleSelection),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: Color(0xFF1C1C1E)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'estella',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      'Welcome! 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your\nphone number',
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1C1C1E),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "We'll check if you have an existing account",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _PhoneInput(controller: _controller),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: _PrimaryButton(
                label: 'Continue',
                loading: _loading,
                onTap: _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Text(
              '+234',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1C1E),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1C1C1E),
                letterSpacing: 1.5,
              ),
              decoration: InputDecoration(
                hintText: '80 0000 0000',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFFD1D5DB),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;

  const _PrimaryButton({
    required this.label,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
