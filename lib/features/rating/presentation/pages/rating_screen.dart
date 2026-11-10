import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/features/washer/services/washer_service.dart';
import 'package:estella/shared/services/wash_service.dart';

/// Extra passed as: {'requestId': String, 'role': 'owner' | 'washer'}
class RatingScreen extends ConsumerStatefulWidget {
  final String requestId;
  final String role; // 'owner' or 'washer'

  const RatingScreen({
    super.key,
    required this.requestId,
    required this.role,
  });

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  double _rating = 0;
  final _commentController = TextEditingController();
  bool _submitting = false;
  bool _submitted = false;

  bool get _isOwner => widget.role == 'owner';

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) return;
    setState(() => _submitting = true);
    try {
      if (_isOwner) {
        final snap =
            await WashService.streamWashRequest(widget.requestId).first;
        await WasherService.submitOwnerRating(
          requestId: widget.requestId,
          rating: _rating,
          comment: _commentController.text.trim(),
          washerId: snap.washerId ?? '',
        );
      } else {
        await WasherService.submitWasherRating(
          requestId: widget.requestId,
          rating: _rating,
          comment: _commentController.text.trim(),
        );
      }
      if (mounted) setState(() => _submitted = true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit rating. Try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _finish() {
    if (_isOwner) {
      context.go(AppRoutes.carSelection);
    } else {
      context.go(AppRoutes.washerDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _submitted
            ? _SuccessView(onDone: _finish)
            : _RatingForm(
                isOwner: _isOwner,
                rating: _rating,
                commentController: _commentController,
                submitting: _submitting,
                onRating: (r) => setState(() => _rating = r),
                onSubmit: _submit,
                onSkip: _finish,
                onClose: _finish,
              ),
      ),
    );
  }
}

// ─────────────────── Rating form ───────────────────

class _RatingForm extends StatelessWidget {
  final bool isOwner;
  final double rating;
  final TextEditingController commentController;
  final bool submitting;
  final void Function(double) onRating;
  final VoidCallback onSubmit;
  final VoidCallback onSkip;
  final VoidCallback onClose;

  const _RatingForm({
    required this.isOwner,
    required this.rating,
    required this.commentController,
    required this.submitting,
    required this.onRating,
    required this.onSubmit,
    required this.onSkip,
    required this.onClose,
  });

  String get _ratingLabel {
    if (rating == 0) return 'Tap a star to rate';
    if (rating <= 1) return 'Very poor';
    if (rating <= 2) return 'Poor';
    if (rating <= 3) return 'Okay';
    if (rating <= 4) return 'Good';
    return 'Excellent!';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 20, color: Color(0xFF1C1C1E)),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                isOwner ? 'Rate your washer' : 'Rate this customer',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFFDE68A), width: 2),
                  ),
                  child: const Icon(Icons.star_rounded,
                      size: 48, color: Color(0xFFD97706)),
                ),
                const SizedBox(height: 24),
                Text(
                  isOwner
                      ? 'How was your wash experience?'
                      : 'How was this customer?',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1C1C1E),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isOwner
                      ? 'Your feedback helps us maintain quality'
                      : 'This helps build trust in the community',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: const Color(0xFF9CA3AF)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _StarPicker(rating: rating, onRating: onRating),
                const SizedBox(height: 8),
                Text(
                  _ratingLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: rating > 0
                        ? const Color(0xFFD97706)
                        : const Color(0xFFD1D5DB),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: commentController,
                    maxLines: 4,
                    style: GoogleFonts.poppins(
                        fontSize: 15, color: const Color(0xFF1C1C1E)),
                    decoration: InputDecoration(
                      hintText: isOwner
                          ? 'Share details about your experience (optional)…'
                          : 'Any notes about this customer (optional)…',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14, color: const Color(0xFFD1D5DB)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            children: [
              _SubmitButton(
                  enabled: rating > 0,
                  loading: submitting,
                  onTap: onSubmit),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: onSkip,
                child: Text(
                  'Skip for now',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF9CA3AF),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────── Shared widgets ───────────────────

class _StarPicker extends StatelessWidget {
  final double rating;
  final void Function(double) onRating;

  const _StarPicker({required this.rating, required this.onRating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final filled = i < rating;
        return GestureDetector(
          onTap: () => onRating((i + 1).toDouble()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 48,
              color: filled
                  ? const Color(0xFFD97706)
                  : const Color(0xFFE5E7EB),
            ),
          ),
        );
      }),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;

  const _SubmitButton({
    required this.enabled,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (loading || !enabled) ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF1C1C1E) : const Color(0xFFD1D5DB),
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
            : Text(
                'Submit rating',
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

class _SuccessView extends StatelessWidget {
  final VoidCallback onDone;
  const _SuccessView({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  size: 52, color: AppColors.primary),
            ),
            const SizedBox(height: 28),
            Text(
              'Thanks for the feedback!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C1C1E),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your rating helps keep the Estella community great.',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                  height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: onDone,
              child: Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Back to home',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
