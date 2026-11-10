import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/shared/data/models/wash_request_model.dart';
import 'package:estella/shared/helpers/onboarding_provider.dart';
import 'package:estella/shared/services/wash_service.dart';

class WashStatusScreen extends ConsumerWidget {
  final bool showBackButton;
  const WashStatusScreen({super.key, required this.showBackButton});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final requestId = state.washRequestId;

    if (requestId == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Color(0xFF9CA3AF)),
              const SizedBox(height: 16),
              Text(
                'No active wash request',
                style: GoogleFonts.poppins(
                    fontSize: 16, color: const Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              _TextButton(
                label: 'Go home',
                onTap: () => context.go(AppRoutes.carSelection),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<WashRequestModel>(
      stream: WashService.streamWashRequest(requestId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'Unable to load status',
                style: GoogleFonts.poppins(
                    fontSize: 16, color: const Color(0xFF6B7280)),
              ),
            ),
          );
        }

        final request = snapshot.data!;
        return _WashStatusBody(request: request, showBackButton:showBackButton);
      },
    );
  }
}

class _WashStatusBody extends StatelessWidget {
  final WashRequestModel request;
  final bool showBackButton;
  const _WashStatusBody({required this.request, required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final isCancelled = request.status == 'cancelled';
    final isCompleted = request.status == 'completed';
    final isPending = request.status == 'pending';
    final hasWasher = request.washerName != null && request.washerName!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Header(isCompleted: isCompleted, showBackButton: showBackButton),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _CarSummaryCard(request: request),
                    const SizedBox(height: 20),
                    _ConfirmationCodeCard(code: request.confirmationCode),
                    const SizedBox(height: 20),
                    if (hasWasher) ...[
                      _WasherCard(request: request),
                      const SizedBox(height: 20),
                    ],
                    _StatusTimeline(currentStatus: request.status),
                    const SizedBox(height: 32),
                    if (isCompleted && !request.isOwnerRated) ...[
                      _PrimaryButton(
                        label: 'Rate your washer',
                        icon: Icons.star_rounded,
                        color: const Color(0xFFD97706),
                        onTap: () => context.push(
                          AppRoutes.rating,
                          extra: {
                            'requestId': request.id,
                            'role': 'owner',
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (isCompleted) ...[
                      _PrimaryButton(
                        label: 'Book another wash',
                        onTap: () => context.go(AppRoutes.carSelection),
                      ),
                    ],
                    if (isCancelled)
                      _PrimaryButton(
                        label: 'Book a new wash',
                        onTap: () => context.go(AppRoutes.carSelection),
                      ),
                    if (isPending)
                      _OutlineButton(
                        label: 'Cancel request',
                        onTap: () => _showCancelDialog(context),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Cancel request?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to cancel this wash request?',
          style: GoogleFonts.poppins(
              fontSize: 14, color: const Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('No, keep it',
                style: GoogleFonts.poppins(color: const Color(0xFF6B7280))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await WashService.cancelWashRequest(request.id);
                // Stream will auto-update the UI to the cancelled state
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to cancel. Please try again.')),
                  );
                }
              }
            },
            child: Text('Yes, cancel',
                style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isCompleted;
  final bool showBackButton;
  const _Header({required this.isCompleted,  required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton)
        _BackButton(onTap: () => context.pop())
          else
            const SizedBox(width: 44),
          Expanded(
            child: Text(
              'Wash Status',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1C1E),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class _CarSummaryCard extends StatelessWidget {
  final WashRequestModel request;
  const _CarSummaryCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(request.car.assetImage, fit: BoxFit.contain),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.car.brand,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1C1C1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${request.car.displayType} · ${request.car.platePrefix}***',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    request.serviceLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₦${request.fee.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1C1C1E),
                ),
              ),
              Text(
                request.paymentMethod == 'cash' ? 'Cash' : 'Transfer',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConfirmationCodeCard extends StatelessWidget {
  final String code;
  const _ConfirmationCodeCard({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confirmation code',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  code,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Share this with your washer to confirm identity',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Code copied',
                      style: GoogleFonts.poppins(fontSize: 14)),
                  duration: const Duration(seconds: 2),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.copy_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _WasherCard extends StatelessWidget {
  final WashRequestModel request;
  const _WasherCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: request.washerPhoto != null && request.washerPhoto!.isNotEmpty
                ? Image.network(
                    request.washerPhoto!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 28),
                  )
                : const Icon(Icons.person_rounded,
                    color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your washer',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  request.washerName ?? 'Washer',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1C1C1E),
                  ),
                ),
                if (request.washerPhone != null &&
                    request.washerPhone!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    request.washerPhone!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (request.washerPhone != null &&
              request.washerPhone!.isNotEmpty)
            GestureDetector(
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: request.washerPhone!));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Phone number copied',
                        style: GoogleFonts.poppins(fontSize: 14)),
                    duration: const Duration(seconds: 2),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.phone_rounded,
                    color: AppColors.primary, size: 18),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final String currentStatus;
  const _StatusTimeline({required this.currentStatus});

  static const _steps = [
    _StatusStep('pending', 'Waiting for acceptance',
        'Your request is being reviewed', Icons.hourglass_empty_rounded),
    _StatusStep('accepted', 'Request accepted',
        'A washer has been assigned to you', Icons.check_circle_outline_rounded),
    _StatusStep('washer_on_way', 'Washer on the way',
        'Your washer is heading to you', Icons.directions_car_rounded),
    _StatusStep('washer_arrived', 'Washer arrived',
        'Confirm your code and their identity', Icons.location_on_rounded),
    _StatusStep('in_progress', 'Wash in progress',
        'Sit back and relax', Icons.water_drop_rounded),
    _StatusStep('wash_ended', 'Wash complete',
        'Your car is clean!', Icons.star_outline_rounded),
    _StatusStep('payment_made', 'Payment confirmed',
        'Thank you for paying', Icons.payment_rounded),
    _StatusStep('completed', 'Service completed',
        'All done. Enjoy your clean car!', Icons.celebration_rounded),
  ];

  static const _statusOrder = [
    'pending', 'accepted', 'washer_on_way', 'washer_arrived',
    'in_progress', 'wash_ended', 'payment_made', 'completed',
  ];

  static const _cancelledStep = _StatusStep(
    'cancelled',
    'Request cancelled',
    'This request was cancelled',
    Icons.cancel_rounded,
  );

  @override
  Widget build(BuildContext context) {
    final isCancelled = currentStatus == 'cancelled';
    final currentIndex = _statusOrder.indexOf(currentStatus);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(_steps.length, (i) {
            final step = _steps[i];
            final isDone = i < currentIndex;
            final isCurrent = i == currentIndex;
            // Last normal step only if not cancelled
            final isLast = i == _steps.length - 1 && !isCancelled;

            return _TimelineRow(
              step: step,
              isDone: isDone,
              isCurrent: isCurrent,
              isLast: isLast,
            );
          }),
          if (isCancelled)
            _TimelineRow(
              step: _cancelledStep,
              isDone: false,
              isCurrent: true,
              isLast: true,
              isCancelledStep: true,
            ),
        ],
      ),
    );
  }
}

class _StatusStep {
  final String key;
  final String label;
  final String subtitle;
  final IconData icon;
  const _StatusStep(this.key, this.label, this.subtitle, this.icon);
}

class _TimelineRow extends StatelessWidget {
  final _StatusStep step;
  final bool isDone;
  final bool isCurrent;
  final bool isLast;
  final bool isCancelledStep;

  const _TimelineRow({
    required this.step,
    required this.isDone,
    required this.isCurrent,
    required this.isLast,
    this.isCancelledStep = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color dotColor = isCancelledStep
        ? Colors.red
        : isDone
            ? AppColors.primary
            : isCurrent
                ? const Color(0xFF1C1C1E)
                : const Color(0xFFE5E7EB);

    final Color iconColor = isDone || isCurrent ? Colors.white : const Color(0xFFD1D5DB);
    final Color labelColor = isCancelledStep
        ? Colors.red
        : isDone || isCurrent
            ? const Color(0xFF1C1C1E)
            : const Color(0xFF9CA3AF);
    final Color subtitleColor = isCancelledStep
        ? Colors.red.withValues(alpha: 0.7)
        : isDone || isCurrent
            ? const Color(0xFF6B7280)
            : const Color(0xFFD1D5DB);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
              child: isDone
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 18)
                  : Icon(step.icon, color: iconColor, size: 18),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: isDone
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : const Color(0xFFE5E7EB),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight:
                        isCurrent ? FontWeight.w600 : FontWeight.w500,
                    color: labelColor,
                  ),
                ),
                Text(
                  step.subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: isLast ? 0 : 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

class _TextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TextButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}


class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }
}
