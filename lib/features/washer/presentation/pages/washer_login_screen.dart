import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:estella/core/navigation/routes.dart';
import 'package:estella/features/washer/data/providers/washer_provider.dart';
import 'package:estella/features/washer/services/washer_service.dart';

class WasherLoginScreen extends ConsumerStatefulWidget {
  const WasherLoginScreen({super.key});

  @override
  ConsumerState<WasherLoginScreen> createState() => _WasherLoginScreenState();
}

class _WasherLoginScreenState extends ConsumerState<WasherLoginScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final digits = _phoneController.text.trim();
    final pin = _pinController.text.trim();
    if (digits.length < 7 || pin.length < 4) return;

    final phone = '+234${digits.startsWith('0') ? digits.substring(1) : digits}';

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final washer = await WasherService.getWasherByPhone(phone);
      if (!mounted) return;

      if (washer == null) {
        setState(() {
          _error = 'No washer account found for this number.';
          _loading = false;
        });
        return;
      }

      if (washer.pin != pin) {
        setState(() {
          _error = 'Incorrect PIN. Please try again.';
          _loading = false;
        });
        return;
      }

      ref.read(washerProvider.notifier).setWasher(washer);
      await Hive.box<String>('strings').put('washerId', washer.id);
      if (mounted) context.go(AppRoutes.washerDashboard);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Something went wrong. Please try again.';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canLogin = _phoneController.text.trim().length >= 7 &&
        _pinController.text.trim().length == 4;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _BackButton(onTap: () => context.pop()),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.water_drop_rounded,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Washer sign in',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1C1C1E),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your registered phone and PIN',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _SectionLabel('Phone number'),
                    const SizedBox(height: 8),
                    _PhoneInput(controller: _phoneController, onChanged: (_) => setState(() {})),
                    const SizedBox(height: 24),
                    _SectionLabel('4-digit PIN'),
                    const SizedBox(height: 8),
                    _PinInput(controller: _pinController, onChanged: (_) => setState(() {})),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                color: Colors.red, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _error!,
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _InfoNote(
                      text: 'Contact your admin if you don\'t have an account or forgot your PIN.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: _PrimaryButton(
                label: 'Sign in',
                loading: _loading,
                enabled: canLogin,
                onTap: canLogin ? _login : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const _PhoneInput({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: const BoxDecoration(
              color: Color(0xFFE5E7EB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Text(
              '+234',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1C1E),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1C1C1E),
                letterSpacing: 1.5,
              ),
              decoration: InputDecoration(
                hintText: '80 0000 0000',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFFD1D5DB),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinInput extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const _PinInput({required this.controller, required this.onChanged});

  @override
  State<_PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<_PinInput> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        keyboardType: TextInputType.number,
        obscureText: _obscure,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1C1C1E),
          letterSpacing: 8,
        ),
        decoration: InputDecoration(
          hintText: '••••',
          hintStyle: GoogleFonts.poppins(
            fontSize: 22,
            color: const Color(0xFFD1D5DB),
            letterSpacing: 8,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscure = !_obscure),
            child: Icon(
              _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: const Color(0xFF9CA3AF),
              size: 20,
            ),
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

class _InfoNote extends StatelessWidget {
  final String text;
  const _InfoNote({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 16, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: const Color(0xFF6B7280), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final bool enabled;
  final VoidCallback? onTap;

  const _PrimaryButton({
    required this.label,
    this.loading = false,
    this.enabled = true,
    this.onTap,
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
