import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/core/theme/app_colors.dart';
import 'package:estella/shared/helpers/onboarding_provider.dart';

class NameEntryScreen extends ConsumerStatefulWidget {
  const NameEntryScreen({super.key});

  @override
  ConsumerState<NameEntryScreen> createState() => _NameEntryScreenState();
}

class _NameEntryScreenState extends ConsumerState<NameEntryScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _controller.text.trim().length >= 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _BackButton(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'What should\nwe call you?',
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1C1C1E),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This is how we\'ll greet you',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 56),
                    _FancyNameInput(
                      controller: _controller,
                      focusNode: _focus,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: _PrimaryButton(
                label: 'Continue',
                enabled: canContinue,
                onTap: canContinue
                    ? () {
                        ref
                            .read(onboardingProvider.notifier)
                            .setName(_controller.text.trim());
                        context.push(AppRoutes.carSelection);
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FancyNameInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const _FancyNameInput({required this.controller, required this.focusNode});

  @override
  State<_FancyNameInput> createState() => _FancyNameInputState();
}

class _FancyNameInputState extends State<_FancyNameInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _underline;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _underline = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        _anim.forward();
      } else {
        _anim.reverse();
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textCapitalization: TextCapitalization.words,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1C1C1E),
          ),
          decoration: InputDecoration(
            hintText: 'Your name',
            hintStyle: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFD1D5DB),
            ),
            border: InputBorder.none,
          ),
        ),
        AnimatedBuilder(
          animation: _underline,
          builder: (_, __) => Container(
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(_underline.value),
                  const Color(0xFF1C1C1E).withOpacity(_underline.value * 0.5),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
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

  const _PrimaryButton({
    required this.label,
    this.onTap,
    this.enabled = true,
  });

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
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
