import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/shared/data/models/car_model.dart';
import 'package:estella/shared/data/models/wash_request_model.dart';
import 'package:estella/shared/helpers/onboarding_provider.dart';
import 'package:estella/shared/services/wash_service.dart';
import 'package:intl/intl.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  bool _loadingPrices = true;
  bool _booking = false;
  bool _asap = true;
  DateTime _scheduledTime = DateTime.now().add(const Duration(hours: 1));
  final _addressController = TextEditingController();
  final _descController = TextEditingController();
  int _locationMode = 0;

  @override
  void initState() {
    super.initState();
    _loadPrices();
    _addressController.addListener(() => setState(() {}));
    _descController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _addressController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _loadPrices() async {
    try {
      final prices = await WashService.getCarPrices();
      ref.read(onboardingProvider.notifier).setCarPrices(prices);
    } catch (_) {}
    if (mounted) setState(() => _loadingPrices = false);
  }

  Future<void> _pickTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledTime),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (time == null) return;
    setState(() {
      _scheduledTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      _asap = false;
    });
  }

  bool get _canBook {
    final state = ref.read(onboardingProvider);
    if (state.activeCar == null) return false;
    final hasLoc = _locationMode == 0
        ? _addressController.text.trim().isNotEmpty
        : _descController.text.trim().isNotEmpty;
    if (!hasLoc) return false;
    return true;
  }

  Future<void> _book() async {
    if (!_canBook) return;
    setState(() => _booking = true);
    try {
      final state = ref.read(onboardingProvider);
      final notifier = ref.read(onboardingProvider.notifier);
      final car = state.activeCar!;

      final location = WashLocation(
        address: _locationMode == 0 ? _addressController.text.trim() : '',
        description: _locationMode == 1 ? _descController.text.trim() : '',
      );

      // Save new car to user if adding one
      String? savedCarId;
      if (state.isAddingNewCar || !state.isExistingUser) {
        savedCarId = await WashService.addCarToUser(
          state.existingUserId!,
          car,
        );
      }

      final code = WashService.generateConfirmationCode();
      final request = WashRequestModel(
        id: '',
        userId: state.existingUserId!,
        userName: state.name,
        userPhone: state.phone,
        car: car.copyWith(id: savedCarId ?? car.id),
        location: location,
        serviceType: state.serviceType,
        fee: state.activePrice,
        scheduledTime: _asap ? DateTime.now() : _scheduledTime,
        paymentMethod: state.paymentMethod,
        status: 'pending',
        confirmationCode: code,
        createdAt: DateTime.now(),
      );

      final requestId = await WashService.createWashRequest(request);
      notifier.setWashRequestId(requestId);
      if (mounted) context.go(AppRoutes.washStatus);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking failed. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _booking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final car = state.activeCar;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  _BackButton(onTap: () => context.pop()),
                  const SizedBox(width: 16),
                  Text(
                    'Book a Wash',
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
              child: _loadingPrices
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (car != null) _CarSummaryCard(car: car),
                          const SizedBox(height: 28),
                          _SectionLabel('Service type'),
                          const SizedBox(height: 12),
                          _ServiceTypePicker(
                            selected: state.serviceType,
                            prices: state.carPrices[car?.type] != null
                                ? Map<String, dynamic>.from(
                                    state.carPrices[car!.type]['prices'] ?? {})
                                : {},
                            onSelect: (t) => ref
                                .read(onboardingProvider.notifier)
                                .setServiceType(t),
                          ),
                          const SizedBox(height: 28),
                          _SectionLabel('Schedule'),
                          const SizedBox(height: 12),
                          _SchedulePicker(
                            asap: _asap,
                            scheduledTime: _scheduledTime,
                            onAsap: () => setState(() => _asap = true),
                            onSchedule: _pickTime,
                          ),
                          const SizedBox(height: 28),
                          _SectionLabel('Payment method'),
                          const SizedBox(height: 12),
                          _PaymentToggle(
                            selected: state.paymentMethod,
                            onSelect: (m) => ref
                                .read(onboardingProvider.notifier)
                                .setPaymentMethod(m),
                          ),
                          const SizedBox(height: 28),
                          _SectionLabel('Where is your car?'),
                          const SizedBox(height: 12),
                          _LocationModePicker(
                            mode: _locationMode,
                            onModeChange: (m) =>
                                setState(() => _locationMode = m),
                          ),
                          const SizedBox(height: 10),
                          _locationMode == 0
                              ? _StyledField(
                                  controller: _addressController,
                                  hint: 'Enter address or landmark',
                                  icon: Icons.location_on_outlined,
                                )
                              : _StyledField(
                                  controller: _descController,
                                  hint: 'Describe where your car is parked…',
                                  icon: Icons.edit_note_rounded,
                                  maxLines: 3,
                                ),
                          const SizedBox(height: 28),
                          _TotalCard(
                            amount: state.activePrice,
                            serviceType: state.serviceType,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: _BookButton(
                amount: state.activePrice,
                loading: _booking,
                enabled: !_loadingPrices,
                onTap: _book,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarSummaryCard extends StatelessWidget {
  final CarModel car;
  const _CarSummaryCard({required this.car});

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
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(car.assetImage, fit: BoxFit.contain),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(car.brand,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1C1C1E))),
              const SizedBox(height: 4),
              Row(
                children: [
                  _Badge(car.displayType),
                  if (car.platePrefix.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text('${car.platePrefix}***',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF9CA3AF))),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280))),
    );
  }
}

class _ServiceTypePicker extends StatelessWidget {
  final String selected;
  final Map<String, dynamic> prices;
  final void Function(String) onSelect;

  const _ServiceTypePicker({
    required this.selected,
    required this.prices,
    required this.onSelect,
  });

  static const _options = [
    {'key': 'exteriorOnly', 'label': 'Exterior\nOnly', 'icon': '🚿'},
    {'key': 'interiorOnly', 'label': 'Interior\nOnly', 'icon': '🪑'},
    {'key': 'exteriorAndInterior', 'label': 'Exterior\n& Interior', 'icon': '✨'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _options.map((opt) {
        final key = opt['key']!;
        final isSelected = selected == key;
        final price = (prices[key] ?? 0) as num;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: key != _options.last['key'] ? 10 : 0),
            child: GestureDetector(
              onTap: () => onSelect(key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(opt['icon']!, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 8),
                    Text(
                      opt['label']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFF4B5563),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (price > 0)
                      Text(
                        '₦${NumberFormat('#,###').format(price)}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFF1C1C1E),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SchedulePicker extends StatelessWidget {
  final bool asap;
  final DateTime scheduledTime;
  final VoidCallback onAsap;
  final VoidCallback onSchedule;

  const _SchedulePicker({
    required this.asap,
    required this.scheduledTime,
    required this.onAsap,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onAsap,
            child: _ScheduleChip(
              label: 'As soon as possible',
              icon: Icons.bolt_rounded,
              selected: asap,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onSchedule,
            child: _ScheduleChip(
              label: asap
                  ? 'Pick a time'
                  : DateFormat('d MMM, h:mm a').format(scheduledTime),
              icon: Icons.schedule_rounded,
              selected: !asap,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;

  const _ScheduleChip({
    required this.label,
    required this.icon,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.08)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: selected ? AppColors.primary : const Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.primary : const Color(0xFF6B7280),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentToggle extends StatelessWidget {
  final String selected;
  final void Function(String) onSelect;

  const _PaymentToggle({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _PaymentOption(
            label: '💵  Cash',
            selected: selected == 'cash',
            onTap: () => onSelect('cash'),
          ),
          _PaymentOption(
            label: '📲  Transfer',
            selected: selected == 'transfer',
            onTap: () => onSelect('transfer'),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? const Color(0xFF1C1C1E) : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final double amount;
  final String serviceType;

  const _TotalCard({required this.amount, required this.serviceType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                'Total amount',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 4),
              Text(
                'Payment after wash',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: Colors.white.withValues(alpha: 0.4)),
              ),
            ],
          ),
          Text(
            amount > 0
                ? '₦${NumberFormat('#,###').format(amount)}'
                : '—',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookButton extends StatelessWidget {
  final double amount;
  final bool loading;
  final bool enabled;
  final VoidCallback onTap;

  const _BookButton({
    required this.amount,
    required this.loading,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (loading || !enabled) ? null : onTap,
      child: Container(
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
                amount > 0
                    ? 'Book Now — ₦${NumberFormat('#,###').format(amount)}'
                    : 'Book Now',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
      ),
    );
  }
}

class _LocationModePicker extends StatelessWidget {
  final int mode;
  final void Function(int) onModeChange;

  const _LocationModePicker({required this.mode, required this.onModeChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ModeChip(
          label: 'Address',
          icon: Icons.location_on_outlined,
          selected: mode == 0,
          onTap: () => onModeChange(0),
        ),
        const SizedBox(width: 10),
        _ModeChip(
          label: 'Describe',
          icon: Icons.edit_note_rounded,
          selected: mode == 1,
          onTap: () => onModeChange(1),
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip(
      {required this.label,
      required this.icon,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.1)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color:
                    selected ? AppColors.primary : const Color(0xFF9CA3AF)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color:
                    selected ? AppColors.primary : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _StyledField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.poppins(
            fontSize: 15, color: const Color(0xFF1C1C1E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.poppins(fontSize: 14, color: const Color(0xFFD1D5DB)),
          border: InputBorder.none,
          prefixIcon: Icon(icon, size: 20, color: const Color(0xFF9CA3AF)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF6B7280),
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
