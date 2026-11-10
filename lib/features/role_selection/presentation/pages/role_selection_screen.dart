import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'estella',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Welcome back.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'How are you\nusing estella?',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1C1C1E),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 48),
              _RoleCard(
                icon: Icons.directions_car_rounded,
                title: 'Car owner',
                subtitle: 'Book a wash for your vehicle\nanywhere, anytime',
                primaryColor: AppColors.primary,
                onTap: () => context.go(AppRoutes.phoneEntry),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.water_drop_rounded,
                title: 'Washer',
                subtitle: 'Accept jobs and manage\nyour wash schedule',
                primaryColor: const Color(0xFF1C1C1E),
                onTap: () => context.push(AppRoutes.washerLogin),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'Professional car care, on demand',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFFD1D5DB),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: primaryColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: primaryColor.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
