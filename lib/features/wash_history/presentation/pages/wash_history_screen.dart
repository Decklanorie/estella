import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/shared/data/models/wash_request_model.dart';
import 'package:estella/shared/helpers/onboarding_provider.dart';
import 'package:estella/shared/services/wash_service.dart';

class WashHistoryScreen extends ConsumerStatefulWidget {
  const WashHistoryScreen({super.key});

  @override
  ConsumerState<WashHistoryScreen> createState() => _WashHistoryScreenState();
}

class _WashHistoryScreenState extends ConsumerState<WashHistoryScreen> {
  List<WashRequestModel>? _history;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final userId = ref.read(onboardingProvider).existingUserId;
    if (userId == null) {
      setState(() {
        _loading = false;
        _error = 'No user found.';
      });
      return;
    }
    try {
      final history = await WashService.getUserWashHistory(userId);
      if (mounted) setState(() { _history = history; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  _BackButton(onTap: () => context.pop()),
                  const SizedBox(width: 16),
                  Text(
                    'Wash History',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1C1C1E),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null) {
      return Center(
        child: Text(_error!,
            style: GoogleFonts.poppins(
                fontSize: 15, color: const Color(0xFF6B7280))),
      );
    }
    if (_history == null || _history!.isEmpty) {
      return _EmptyState();
    }

    final active = _history!
        .where((r) => !_isTerminal(r.status))
        .toList();
    final past = _history!
        .where((r) => _isTerminal(r.status))
        .toList();

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          if (active.isNotEmpty) ...[
            _SectionHeader('Active washes', active.length),
            const SizedBox(height: 12),
            ...active.map((r) => _HistoryTile(
                  request: r,
                  onTap: () {
                    ref.read(onboardingProvider.notifier).setWashRequestId(r.id);
                    context.push(AppRoutes.washStatus, extra: true);
                  },
                )),
            const SizedBox(height: 28),
          ],
          if (past.isNotEmpty) ...[
            _SectionHeader('Past washes', past.length),
            const SizedBox(height: 12),
            ...past.map((r) => _HistoryTile(request: r, onTap:() {
            ref.read(onboardingProvider.notifier).setWashRequestId(r.id);
            context.push(AppRoutes.washStatus, extra: true);
            },)),
          ],
        ],
      ),
    );
  }

  bool _isTerminal(String status) =>
      status == 'completed' || status == 'cancelled';
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  const _SectionHeader(this.label, this.count);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1C1C1E),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final WashRequestModel request;
  final VoidCallback? onTap;
  const _HistoryTile({required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(request.status);
    final isActive = request.status != 'completed' && request.status != 'cancelled';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.3)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 50,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          request.car.brand,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1C1C1E),
                          ),
                        ),
                      ),
                      Text(
                        '₦${NumberFormat('#,###').format(request.fee)}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1C1C1E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${request.serviceLabel} · ${DateFormat('d MMM yyyy').format(request.createdAt)}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          request.statusLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            size: 12, color: Color(0xFF9CA3AF)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFD97706);
      case 'accepted':
      case 'washer_on_way':
      case 'washer_arrived':
        return const Color(0xFF2563EB);
      case 'in_progress':
        return AppColors.primary;
      case 'wash_ended':
      case 'payment_made':
        return const Color(0xFF16A34A);
      case 'completed':
        return const Color(0xFF6B7280);
      case 'cancelled':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF9CA3AF);
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history_rounded,
                size: 36, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 20),
          Text(
            'No washes yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your completed washes will appear here',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
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
