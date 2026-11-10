import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/shared/data/models/car_model.dart';
import 'package:estella/shared/helpers/onboarding_provider.dart';

class CarSelectionScreen extends ConsumerStatefulWidget {
  const CarSelectionScreen({super.key});

  @override
  ConsumerState<CarSelectionScreen> createState() => _CarSelectionScreenState();
}

class _CarSelectionScreenState extends ConsumerState<CarSelectionScreen> {
  final _brandController = TextEditingController();
  String _selectedType = '';

  static const _types = [
    {'key': 'saloon', 'label': 'Saloon', 'image': 'assets/images/saloon.png'},
    {'key': 'suv', 'label': 'SUV', 'image': 'assets/images/suv.png'},
    {'key': 'van', 'label': 'Van', 'image': 'assets/images/van.png'},
  ];

  @override
  void initState() {
    super.initState();
    _brandController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _brandController.dispose();
    super.dispose();
  }

  void _onExistingCarTap(CarModel car) {
    ref.read(onboardingProvider.notifier).selectExistingCar(car);
    context.push(AppRoutes.booking);
  }

  void _onAddNewCar() {
    ref.read(onboardingProvider.notifier).startAddingNewCar();
    setState(() {
      _brandController.clear();
      _selectedType = '';
    });
  }

  void _onContinueNewCar() {
    ref.read(onboardingProvider.notifier).setNewCarBrand(_brandController.text.trim());
    ref.read(onboardingProvider.notifier).setNewCarType(_selectedType);
    context.push(AppRoutes.carDetails);
  }

  void _backFromAddingCar() {
    final state = ref.read(onboardingProvider);
    if (state.existingCars.isNotEmpty) {
      ref.read(onboardingProvider.notifier).selectExistingCar(state.existingCars.first);
    } else {
      ref.read(onboardingProvider.notifier).setNewUser();
    }
    setState(() => _selectedType = '');
  }

  void _showProfile() {
    final state = ref.read(onboardingProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ProfileSheet(
        name: state.name,
        phone: state.phone,
        onSignOut: _signOut,
        onClearAccount: _clearAccount,
      ),
    );
  }

  void _signOut() {
    Navigator.pop(context);
    Hive.box<String>('strings').delete('userId');
    ref.read(onboardingProvider.notifier).reset();
    context.go(AppRoutes.roleSelection);
  }

  void _clearAccount() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Clear account?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(
          'This will sign you out and clear all saved data on this device. Your account will still exist.',
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
              Hive.box<String>('strings').clear();
              ref.read(onboardingProvider.notifier).reset();
              context.go(AppRoutes.roleSelection);
            },
            child: Text('Clear',
                style: GoogleFonts.poppins(
                    color: Colors.red, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    // Existing user on their home screen (not mid-flow adding a car)
    final isHome = state.isExistingUser && !state.isAddingNewCar;
    // Show the saved-car list vs new-car form
    final showCarList = isHome && state.existingCars.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: isHome
                  // Profile avatar + history — always visible for existing users
                  ? _HomeTopBar(
                      userName: state.name,
                      onProfile: _showProfile,
                      onHistory: () => context.push(AppRoutes.washHistory),
                    )
                  // Back button — new users or existing user mid-flow adding a car
                  : _BackButton(
                      onTap: state.isAddingNewCar
                          ? _backFromAddingCar
                          : () => context.pop(),
                    ),
            ),
            Expanded(
              child: showCarList
                  ? _ExistingCarsList(
                      cars: state.existingCars,
                      userName: state.name,
                      onCarTap: _onExistingCarTap,
                      onAddNew: _onAddNewCar,
                    )
                  : _NewCarForm(
                      brandController: _brandController,
                      selectedType: _selectedType,
                      types: _types,
                      onTypeSelect: (t) => setState(() => _selectedType = t),
                      isExistingUser: isHome,
                    ),
            ),
            if (!showCarList)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: _PrimaryButton(
                  label: 'Continue',
                  enabled: _brandController.text.trim().isNotEmpty &&
                      _selectedType.isNotEmpty,
                  onTap: _brandController.text.trim().isNotEmpty &&
                          _selectedType.isNotEmpty
                      ? _onContinueNewCar
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// Top bar for home (existing users)
// ──────────────────────────────────────────

class _HomeTopBar extends StatelessWidget {
  final String userName;
  final VoidCallback onProfile;
  final VoidCallback onHistory;

  const _HomeTopBar({
    required this.userName,
    required this.onProfile,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(userName);
    return Row(
      children: [
        GestureDetector(
          onTap: onProfile,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onHistory,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.history_rounded,
                    size: 16, color: Color(0xFF6B7280)),
                const SizedBox(width: 6),
                Text(
                  'History',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

// ──────────────────────────────────────────
// Existing cars list
// ──────────────────────────────────────────

class _ExistingCarsList extends StatelessWidget {
  final List<CarModel> cars;
  final String userName;
  final void Function(CarModel) onCarTap;
  final VoidCallback onAddNew;

  const _ExistingCarsList({
    required this.cars,
    required this.userName,
    required this.onCarTap,
    required this.onAddNew,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Text(
            'Hey ${userName.split(' ').first}! 👋',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Which car needs\na wash today?',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C1C1E),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 28),
          Expanded(
            child: ListView.separated(
              itemCount: cars.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                if (i == cars.length) {
                  return _AddNewCarTile(onTap: onAddNew);
                }
                return _ExistingCarTile(car: cars[i], onTap: onCarTap);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────
// Profile bottom sheet
// ──────────────────────────────────────────

class _ProfileSheet extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback onSignOut;
  final VoidCallback onClearAccount;

  const _ProfileSheet({
    required this.name,
    required this.phone,
    required this.onSignOut,
    required this.onClearAccount,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (name.isNotEmpty)
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C1C1E),
              ),
            ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone_rounded,
                    size: 14, color: Color(0xFF6B7280)),
                const SizedBox(width: 6),
                Text(
                  phone.isNotEmpty ? phone : 'No phone saved',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _SheetButton(
              label: 'Sign out',
              icon: Icons.logout_rounded,
              color: const Color(0xFF1C1C1E),
              onTap: onSignOut,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _SheetButton(
              label: 'Use a different number',
              icon: Icons.swap_horiz_rounded,
              color: Colors.red,
              onTap: onClearAccount,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

class _SheetButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SheetButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// Car tiles
// ──────────────────────────────────────────

class _ExistingCarTile extends StatelessWidget {
  final CarModel car;
  final void Function(CarModel) onTap;
  const _ExistingCarTile({required this.car, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(car),
      child: Container(
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
              child: Image.asset(car.assetImage, fit: BoxFit.contain),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.brand,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          car.displayType,
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B7280)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (car.platePrefix.isNotEmpty)
                        Text(
                          '${car.platePrefix}***',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: const Color(0xFF9CA3AF)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _colorFromName(car.color),
                shape: BoxShape.circle,
                border:
                    Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

class _AddNewCarTile extends StatelessWidget {
  final VoidCallback onTap;
  const _AddNewCarTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Add a new car',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// New car form (new users & adding car)
// ──────────────────────────────────────────

class _NewCarForm extends StatelessWidget {
  final TextEditingController brandController;
  final String selectedType;
  final List<Map<String, String>> types;
  final void Function(String) onTypeSelect;
  final bool isExistingUser;

  const _NewCarForm({
    required this.brandController,
    required this.selectedType,
    required this.types,
    required this.onTypeSelect,
    this.isExistingUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Text(
            isExistingUser ? 'Add a new car' : 'Tell us about\nyour car',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1C1C1E),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the car you want washed',
            style: GoogleFonts.poppins(
                fontSize: 14, color: const Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 32),
          _SectionLabel('Car brand or name'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: brandController,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1C1C1E)),
              decoration: InputDecoration(
                hintText: 'e.g. Toyota, Honda, Kia…',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 15, color: const Color(0xFFD1D5DB)),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 28),
          _SectionLabel('Select car type'),
          const SizedBox(height: 12),
          Row(
            children: types
                .map((t) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: t['key'] != types.last['key'] ? 10 : 0,
                        ),
                        child: _CarTypeCard(
                          label: t['label']!,
                          image: t['image']!,
                          selected: selectedType == t['key'],
                          onTap: () => onTypeSelect(t['key']!),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _CarTypeCard extends StatelessWidget {
  final String label;
  final String image;
  final bool selected;
  final VoidCallback onTap;

  const _CarTypeCard({
    required this.label,
    required this.image,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 64,
              child: Image.asset(image, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// Shared small widgets
// ──────────────────────────────────────────

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

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  const _PrimaryButton({required this.label, this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF1C1C1E) : const Color(0xFFD1D5DB),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }
}

Color _colorFromName(String name) {
  final map = {
    'white': Colors.white,
    'black': Colors.black,
    'silver': const Color(0xFFC0C0C0),
    'grey': const Color(0xFF808080),
    'gray': const Color(0xFF808080),
    'red': const Color(0xFFDC2626),
    'blue': const Color(0xFF2563EB),
    'green': const Color(0xFF16A34A),
    'yellow': const Color(0xFFFACC15),
    'orange': const Color(0xFFF97316),
    'brown': const Color(0xFF92400E),
    'gold': const Color(0xFFD97706),
    'maroon': const Color(0xFF7F1D1D),
    'navy': const Color(0xFF1E3A5F),
    'beige': const Color(0xFFF5F5DC),
    'purple': const Color(0xFF7C3AED),
  };
  return map[name.toLowerCase()] ?? const Color(0xFFD1D5DB);
}
