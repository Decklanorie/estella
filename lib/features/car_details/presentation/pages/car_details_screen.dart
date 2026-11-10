import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/shared/helpers/onboarding_provider.dart';

class CarDetailsScreen extends ConsumerStatefulWidget {
  const CarDetailsScreen({super.key});

  @override
  ConsumerState<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends ConsumerState<CarDetailsScreen> {
  String _selectedColor = '';
  final _plateController = TextEditingController();

  static const _colors = [
    {'name': 'white', 'color': Color(0xFFFFFFFF)},
    {'name': 'black', 'color': Color(0xFF1C1C1E)},
    {'name': 'silver', 'color': Color(0xFFC0C0C0)},
    {'name': 'grey', 'color': Color(0xFF9CA3AF)},
    {'name': 'red', 'color': Color(0xFFDC2626)},
    {'name': 'blue', 'color': Color(0xFF2563EB)},
    {'name': 'green', 'color': Color(0xFF16A34A)},
    {'name': 'gold', 'color': Color(0xFFD97706)},
    {'name': 'brown', 'color': Color(0xFF92400E)},
    {'name': 'navy', 'color': Color(0xFF1E3A5F)},
  ];

  @override
  void initState() {
    super.initState();
    _plateController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    final hasColor = _selectedColor.isNotEmpty;
    final hasPlate = _plateController.text.trim().length >= 2;
    return hasColor && hasPlate;
  }

  void _onContinue() {
    final notifier = ref.read(onboardingProvider.notifier);
    notifier.setNewCarColor(_selectedColor);
    notifier.setNewCarPlate(_plateController.text.trim().toUpperCase());

    final state = ref.read(onboardingProvider);
    if (state.needsPhoneConfirm) {
      context.push(AppRoutes.phoneConfirm);
    } else {
      context.push(AppRoutes.booking);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Text(
                      'One more thing!',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Car details',
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1C1C1E),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 36),
                    _SectionLabel('Car colour'),
                    const SizedBox(height: 14),
                    _ColorPicker(
                      colors: _colors,
                      selected: _selectedColor,
                      onSelect: (c) => setState(() => _selectedColor = c),
                    ),
                    const SizedBox(height: 32),
                    _SectionLabel('Plate number (first 3 characters)'),
                    const SizedBox(height: 10),
                    _PlateInput(controller: _plateController),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: _PrimaryButton(
                label: 'Continue',
                enabled: _canContinue,
                onTap: _canContinue ? _onContinue : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final List<Map<String, Object>> colors;
  final String selected;
  final void Function(String) onSelect;

  const _ColorPicker({
    required this.colors,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((c) {
        final name = c['name'] as String;
        final color = c['color'] as Color;
        final isSelected = selected == name;
        return GestureDetector(
          onTap: () => onSelect(name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                width: isSelected ? 3 : 1.5,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: isSelected
                ? Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: color == const Color(0xFFFFFFFF)
                        ? const Color(0xFF1C1C1E)
                        : Colors.white,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}

class _PlateInput extends StatelessWidget {
  final TextEditingController controller;
  const _PlateInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
        ],
        style: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1C1C1E),
          letterSpacing: 8,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'ABC',
          hintStyle: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFD1D5DB),
            letterSpacing: 8,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          suffixText: '***',
          suffixStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFD1D5DB),
          ),
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
