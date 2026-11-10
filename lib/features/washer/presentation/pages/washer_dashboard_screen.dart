import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/features/washer/data/providers/washer_provider.dart';
import 'package:estella/features/washer/services/washer_service.dart';
import 'package:estella/shared/data/models/wash_request_model.dart';

class WasherDashboardScreen extends ConsumerStatefulWidget {
  const WasherDashboardScreen({super.key});

  @override
  ConsumerState<WasherDashboardScreen> createState() =>
      _WasherDashboardScreenState();
}

class _WasherDashboardScreenState extends ConsumerState<WasherDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<WashRequestModel>? _history;
  bool _loadingHistory = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 2 && _history == null && !_loadingHistory) {
        _loadHistory();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final washerId = ref.read(washerProvider).washer?.id;
    if (washerId == null) return;
    setState(() => _loadingHistory = true);
    try {
      final history = await WasherService.getWasherHistory(washerId);
      if (mounted) setState(() => _history = history);
    } catch (_) {}
    if (mounted) setState(() => _loadingHistory = false);
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sign out?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(
          'You will need to sign in again to accept jobs.',
          style: GoogleFonts.poppins(
              fontSize: 14, color: const Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: const Color(0xFF6B7280))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Hive.box<String>('strings').delete('washerId');
              ref.read(washerProvider.notifier).signOut();
              context.go(AppRoutes.roleSelection);
            },
            child: Text('Sign out',
                style: GoogleFonts.poppins(
                    color: Colors.red, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final washerState = ref.watch(washerProvider);
    final washer = washerState.washer;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              washerName: washer?.name ?? '',
              rating: washer?.rating ?? 0,
              totalJobs: washer?.totalJobs ?? 0,
              onSignOut: _signOut,
            ),
            _TabBar(controller: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _AvailableJobsTab(washerId: washer?.id ?? ''),
                  _ActiveJobTab(washerId: washer?.id ?? ''),
                  _HistoryTab(
                    history: _history,
                    loading: _loadingHistory,
                    onRefresh: () {
                      setState(() => _history = null);
                      _loadHistory();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────── Header ───────────────────

class _Header extends StatelessWidget {
  final String washerName;
  final double rating;
  final int totalJobs;
  final VoidCallback onSignOut;

  const _Header({
    required this.washerName,
    required this.rating,
    required this.totalJobs,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.water_drop_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hey, ${washerName.split(' ').first}!',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1C1C1E),
                      ),
                    ),
                    Text(
                      'Ready for today\'s jobs',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onSignOut,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.logout_rounded,
                      size: 18, color: Color(0xFF6B7280)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatChip(
                icon: Icons.star_rounded,
                iconColor: const Color(0xFFD97706),
                value: rating > 0 ? rating.toStringAsFixed(1) : '—',
                label: 'Rating',
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.primary,
                value: totalJobs.toString(),
                label: 'Jobs done',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────── Tab bar ───────────────────

class _TabBar extends StatelessWidget {
  final TabController controller;
  const _TabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller,
        labelStyle:
            GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400),
        labelColor: AppColors.primary,
        unselectedLabelColor: const Color(0xFF9CA3AF),
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        tabs: const [
          Tab(text: 'Available'),
          Tab(text: 'Active'),
          Tab(text: 'History'),
        ],
      ),
    );
  }
}

// ─────────────────── Available jobs ───────────────────

class _AvailableJobsTab extends ConsumerWidget {
  final String washerId;
  const _AvailableJobsTab({required this.washerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<WashRequestModel>>(
      stream: WasherService.streamAvailableJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        final jobs = snapshot.data ?? [];
        if (jobs.isEmpty) {
          return _EmptyState(
            icon: Icons.hourglass_empty_rounded,
            title: 'No jobs available',
            subtitle: 'New requests will appear here',
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {},
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _JobCard(
              request: jobs[i],
              onTap: () => context.push(AppRoutes.washerJob, extra: jobs[i].id),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────── Active job ───────────────────

class _ActiveJobTab extends ConsumerWidget {
  final String washerId;
  const _ActiveJobTab({required this.washerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (washerId.isEmpty) {
      return _EmptyState(
        icon: Icons.work_outline_rounded,
        title: 'No active job',
        subtitle: 'Accept a job from the Available tab',
      );
    }

    return StreamBuilder<WashRequestModel?>(
      stream: WasherService.streamActiveJob(washerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        final job = snapshot.data;
        if (job == null) {
          return _EmptyState(
            icon: Icons.work_outline_rounded,
            title: 'No active job',
            subtitle: 'Accept a job from the Available tab',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _ActiveJobCard(
              request: job,
              onTap: () =>
                  context.push(AppRoutes.washerJob, extra: job.id),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────── History ───────────────────

class _HistoryTab extends StatelessWidget {
  final List<WashRequestModel>? history;
  final bool loading;
  final VoidCallback onRefresh;

  const _HistoryTab({
    required this.history,
    required this.loading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (history == null || history!.isEmpty) {
      return _EmptyState(
        icon: Icons.history_rounded,
        title: 'No history yet',
        subtitle: 'Completed jobs will appear here',
      );
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => onRefresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: history!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => _HistoryTile(request: history![i]),
      ),
    );
  }
}

// ─────────────────── Job card (available) ───────────────────

class _JobCard extends StatelessWidget {
  final WashRequestModel request;
  final VoidCallback onTap;

  const _JobCard({required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(request.car.assetImage,
                      fit: BoxFit.contain),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.car.brand,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1C1C1E),
                        ),
                      ),
                      Text(
                        '${request.car.displayType} · ${request.car.platePrefix}***',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: const Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₦${NumberFormat('#,###').format(request.fee)}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              height: 1,
              color: const Color(0xFFF3F4F6),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request.location.displayText.isNotEmpty
                        ? request.location.displayText
                        : 'Location not specified',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: const Color(0xFF6B7280)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _ServiceBadge(request.serviceLabel),
                const SizedBox(width: 8),
                _PaymentBadge(request.paymentMethod),
                const Spacer(),
                Text(
                  _formatTime(request.createdAt),
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: const Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return DateFormat('h:mm a').format(dt);
  }
}

// ─────────────────── Active job card ───────────────────

class _ActiveJobCard extends StatelessWidget {
  final WashRequestModel request;
  final VoidCallback onTap;

  const _ActiveJobCard({required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Active job',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '₦${NumberFormat('#,###').format(request.fee)}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${request.car.brand} · ${request.car.displayType}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              request.location.displayText.isNotEmpty
                  ? request.location.displayText
                  : 'Location not specified',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatusPill(request.statusLabel),
                const Spacer(),
                Text(
                  'Tap to manage',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: Colors.white.withValues(alpha: 0.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  const _StatusPill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ─────────────────── History tile ───────────────────

class _HistoryTile extends StatelessWidget {
  final WashRequestModel request;
  const _HistoryTile({required this.request});

  @override
  Widget build(BuildContext context) {
    final isCompleted = request.status == 'completed';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1C1C1E),
                  ),
                ),
                Text(
                  '${request.serviceLabel} · ${DateFormat('d MMM').format(request.createdAt)}',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: const Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₦${NumberFormat('#,###').format(request.fee)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isCompleted ? 'Done' : 'Cancelled',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? AppColors.primary : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────── Shared badges ───────────────────

class _ServiceBadge extends StatelessWidget {
  final String label;
  const _ServiceBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary)),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final String method;
  const _PaymentBadge(this.method);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        method == 'cash' ? '💵 Cash' : '📲 Transfer',
        style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280)),
      ),
    );
  }
}

// ─────────────────── Empty state ───────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: const Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
                fontSize: 13, color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}
