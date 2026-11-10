import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/features/washer/data/providers/washer_provider.dart';
import 'package:estella/features/washer/services/washer_service.dart';
import 'package:estella/shared/data/models/wash_request_model.dart';

class WasherJobScreen extends ConsumerWidget {
  final String requestId;
  const WasherJobScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<WashRequestModel>(
      stream: WasherService.streamJob(requestId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text('Job not found',
                  style: GoogleFonts.poppins(color: const Color(0xFF6B7280))),
            ),
          );
        }
        return _JobBody(request: snapshot.data!);
      },
    );
  }
}

class _JobBody extends ConsumerStatefulWidget {
  final WashRequestModel request;
  const _JobBody({required this.request});

  @override
  ConsumerState<_JobBody> createState() => _JobBodyState();
}

class _JobBodyState extends ConsumerState<_JobBody> {
  bool _actionLoading = false;
  final _codeController = TextEditingController();
  bool _codeVerified = false;
  String? _codeError;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _doAction(Future<void> Function() action) async {
    setState(() => _actionLoading = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Action failed. Try again.', style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _acceptJob() => _doAction(() async {
        final washer = ref.read(washerProvider).washer!;
        await WasherService.acceptJob(widget.request.id, washer);
      });

  Future<void> _updateStatus(String status) =>
      _doAction(() => WasherService.updateJobStatus(widget.request.id, status));

  void _verifyCode() {
    final entered = _codeController.text.trim();
    if (entered == widget.request.confirmationCode) {
      setState(() {
        _codeVerified = true;
        _codeError = null;
      });
      _updateStatus('in_progress');
    } else {
      setState(() => _codeError = 'Incorrect code. Ask the car owner to check.');
    }
  }

  Future<void> _completeAndRate() => _doAction(() async {
        final washerId = ref.read(washerProvider).washer!.id;
        await WasherService.completeJob(widget.request.id, washerId);
        if (mounted) {
          context.pushReplacement(AppRoutes.rating,
              extra: {'requestId': widget.request.id, 'role': 'washer'});
        }
      });

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final isPending = req.status == 'pending';
    final isAccepted = req.status == 'accepted';
    final isOnWay = req.status == 'washer_on_way';
    final isArrived = req.status == 'washer_arrived';
    final isInProgress = req.status == 'in_progress';
    final isWashEnded = req.status == 'wash_ended';
    final isPaymentMade = req.status == 'payment_made';
    final isCompleted = req.status == 'completed';
    final isCancelled = req.status == 'cancelled';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  _BackBtn(onTap: () => context.pop()),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      isPending ? 'Job Details' : 'Active Job',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1C1C1E),
                      ),
                    ),
                  ),
                  _StatusBadge(req.status),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Car card
                    _CarCard(request: req),
                    const SizedBox(height: 16),

                    // Amount + payment
                    _AmountCard(request: req),
                    const SizedBox(height: 16),

                    // Location
                    _LocationCard(request: req),
                    const SizedBox(height: 16),

                    // Confirmation code (shown after accepted)
                    if (!isPending) ...[
                      _ConfirmationCodeSection(
                        code: req.confirmationCode,
                        verified: _codeVerified,
                        controller: _codeController,
                        error: _codeError,
                        isArrived: isArrived,
                        onVerify: _verifyCode,
                        onChanged: (_) => setState(() => _codeError = null),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Payment simulation (when wash ended)
                    if (isWashEnded) ...[
                      _PaymentSimCard(
                        request: req,
                        loading: _actionLoading,
                        onConfirm: () => _doAction(() async {
                          await WasherService.confirmPayment(
                              req.id, req.paymentMethod);
                        }),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Rating completed
                    if (isCompleted && req.washerRating != null) ...[
                      _RatingDoneCard(
                        label: 'You rated this owner',
                        rating: req.washerRating!,
                      ),
                      const SizedBox(height: 16),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Action button
            if (!isCompleted && !isCancelled)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: _buildActionButton(
                  isPending: isPending,
                  isAccepted: isAccepted,
                  isOnWay: isOnWay,
                  isArrived: isArrived,
                  isInProgress: isInProgress,
                  isWashEnded: isWashEnded,
                  isPaymentMade: isPaymentMade,
                ),
              ),

            if (isCompleted && req.washerRating == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: _ActionButton(
                  label: 'Rate this customer',
                  icon: Icons.star_rounded,
                  color: const Color(0xFFD97706),
                  loading: false,
                  onTap: () => context.push(AppRoutes.rating,
                      extra: {'requestId': req.id, 'role': 'washer'}),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required bool isPending,
    required bool isAccepted,
    required bool isOnWay,
    required bool isArrived,
    required bool isInProgress,
    required bool isWashEnded,
    required bool isPaymentMade,
  }) {
    if (isPending) {
      return _ActionButton(
        label: 'Accept this job',
        icon: Icons.check_circle_rounded,
        color: AppColors.primary,
        loading: _actionLoading,
        onTap: _acceptJob,
      );
    }
    if (isAccepted) {
      return _ActionButton(
        label: 'I\'m on my way',
        icon: Icons.directions_car_rounded,
        color: const Color(0xFF2563EB),
        loading: _actionLoading,
        onTap: () => _updateStatus('washer_on_way'),
      );
    }
    if (isOnWay) {
      return _ActionButton(
        label: 'I\'ve arrived',
        icon: Icons.location_on_rounded,
        color: const Color(0xFF7C3AED),
        loading: _actionLoading,
        onTap: () => _updateStatus('washer_arrived'),
      );
    }
    if (isArrived) {
      return Column(
        children: [
          if (!_codeVerified)
            Text(
              'Enter the confirmation code above to start the wash',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF9CA3AF)),
            ),
        ],
      );
    }
    if (isInProgress) {
      return _ActionButton(
        label: 'Mark wash as complete',
        icon: Icons.water_drop_rounded,
        color: AppColors.primary,
        loading: _actionLoading,
        onTap: () => _updateStatus('wash_ended'),
      );
    }
    if (isWashEnded) {
      return const SizedBox.shrink();
    }
    if (isPaymentMade) {
      return _ActionButton(
        label: 'Complete job & rate customer',
        icon: Icons.star_rounded,
        color: const Color(0xFF1C1C1E),
        loading: _actionLoading,
        onTap: _completeAndRate,
      );
    }
    return const SizedBox.shrink();
  }
}

// ─────────────────── Sub-widgets ───────────────────

class _CarCard extends StatelessWidget {
  final WashRequestModel request;
  const _CarCard({required this.request});

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
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Image.asset(request.car.assetImage, fit: BoxFit.contain),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.car.brand,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1C1C1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${request.car.displayType} · ${request.car.color.isNotEmpty ? request.car.color : 'Unknown color'}',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: const Color(0xFF6B7280)),
                ),
                const SizedBox(height: 4),
                Text(
                  request.car.platePrefix.isNotEmpty
                      ? '${request.car.platePrefix}***'
                      : 'No plate',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: const Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              request.serviceLabel,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  final WashRequestModel request;
  const _AmountCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service fee',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    request.paymentMethod == 'cash'
                        ? '💵 Cash payment'
                        : '📲 Transfer',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '₦${NumberFormat('#,###').format(request.fee)}',
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final WashRequestModel request;
  const _LocationCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on_rounded,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Car location',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: const Color(0xFF9CA3AF)),
                ),
                const SizedBox(height: 2),
                Text(
                  request.location.displayText.isNotEmpty
                      ? request.location.displayText
                      : 'No location specified',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1C1C1E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationCodeSection extends StatelessWidget {
  final String code;
  final bool verified;
  final TextEditingController controller;
  final String? error;
  final bool isArrived;
  final VoidCallback onVerify;
  final void Function(String) onChanged;

  const _ConfirmationCodeSection({
    required this.code,
    required this.verified,
    required this.controller,
    required this.error,
    required this.isArrived,
    required this.onVerify,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: verified
            ? AppColors.primary.withValues(alpha: 0.06)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: verified
              ? AppColors.primary.withValues(alpha: 0.3)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                verified
                    ? Icons.verified_rounded
                    : Icons.lock_outline_rounded,
                size: 18,
                color: verified ? AppColors.primary : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 8),
              Text(
                verified
                    ? 'Code verified — wash started!'
                    : 'Confirm customer identity',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: verified
                      ? AppColors.primary
                      : const Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
          if (!verified && isArrived) ...[
            const SizedBox(height: 12),
            Text(
              'Ask the car owner for their 4-digit confirmation code',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: const Color(0xFF6B7280)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: error != null
                            ? Colors.red.withValues(alpha: 0.4)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1C1C1E),
                        letterSpacing: 8,
                      ),
                      decoration: InputDecoration(
                        hintText: '0000',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 24,
                          color: const Color(0xFFD1D5DB),
                          letterSpacing: 8,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onVerify,
                  child: Container(
                    height: 52,
                    width: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Verify',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error!,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.red),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _PaymentSimCard extends StatelessWidget {
  final WashRequestModel request;
  final bool loading;
  final VoidCallback onConfirm;

  const _PaymentSimCard({
    required this.request,
    required this.loading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isCash = request.paymentMethod == 'cash';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1C1C1E),
            const Color(0xFF2D2D30),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.payment_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Collect payment',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    isCash ? 'Cash payment' : 'Bank transfer',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6)),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '₦${NumberFormat('#,###').format(request.fee)}',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!isCash) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ask customer to transfer to:',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '090 1234 5678',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              const ClipboardData(text: '09012345678'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Account number copied')),
                          );
                        },
                        child: Icon(Icons.copy_rounded,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.5)),
                      ),
                    ],
                  ),
                  Text(
                    'Opay · Estella Washer',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          GestureDetector(
            onTap: loading ? null : onConfirm,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      isCash
                          ? 'Cash received — confirm payment'
                          : 'Transfer received — confirm payment',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingDoneCard extends StatelessWidget {
  final String label;
  final double rating;

  const _RatingDoneCard({required this.label, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFD97706), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: const Color(0xFF6B7280))),
          ),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 16,
                color: const Color(0xFFD97706),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'pending':
        color = const Color(0xFFD97706);
        break;
      case 'accepted':
      case 'washer_on_way':
        color = const Color(0xFF2563EB);
        break;
      case 'washer_arrived':
      case 'in_progress':
        color = AppColors.primary;
        break;
      case 'wash_ended':
      case 'payment_made':
        color = const Color(0xFF16A34A);
        break;
      case 'completed':
        color = const Color(0xFF6B7280);
        break;
      default:
        color = const Color(0xFF9CA3AF);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _label(status),
        style: GoogleFonts.poppins(
            fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  String _label(String s) {
    switch (s) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'washer_on_way':
        return 'En route';
      case 'washer_arrived':
        return 'Arrived';
      case 'in_progress':
        return 'Washing';
      case 'wash_ended':
        return 'Wash done';
      case 'payment_made':
        return 'Paid';
      case 'completed':
        return 'Completed';
      default:
        return s;
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool loading;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _BackBtn({required this.onTap});

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
