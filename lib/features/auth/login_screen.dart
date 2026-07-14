import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/logo_mark.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _createAccount = false;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AuthProvider>().signIn(
          name: _name.text,
          email: _email.text,
          password: _password.text,
          createAccount: _createAccount,
        );
    if (!ok || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Logged in successfully'),
          backgroundColor: AppColors.crimson),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(child: LogoMark(size: 56)),
                    const SizedBox(height: 18),
                    Text(
                      'Login to Nouveau',
                      textAlign: TextAlign.center,
                      style: AppTypography.sectionTitle(30),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Secure access for shopping, wishlist, cart, orders, and bills.',
                      textAlign: TextAlign.center,
                      style: AppTypography.poppins(
                          color: AppColors.textMuted, height: 1.5),
                    ),
                    const SizedBox(height: 28),
                    _Field(
                      controller: _name,
                      label: 'Full name',
                      icon: Icons.person_outline,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Enter your name'
                              : null,
                    ),
                    const SizedBox(height: 14),
                    _Field(
                      controller: _email,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        return text.contains('@') && text.contains('.')
                            ? null
                            : 'Enter a valid email';
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      validator: (value) => (value ?? '').length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                      decoration:
                          _decoration('Password', Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(_obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: AppColors.crimson,
                      title: Text('Create account if needed',
                          style: AppTypography.poppins(
                              fontWeight: FontWeight.w600)),
                      value: _createAccount,
                      onChanged: (value) =>
                          setState(() => _createAccount = value),
                    ),
                    if (auth.error != null) ...[
                      const SizedBox(height: 8),
                      Text(auth.error!,
                          style: AppTypography.poppins(
                              color: AppColors.outOfStock)),
                    ],
                    const SizedBox(height: 20),
                    Align(
                      child: PrimaryPillButton(
                        label: auth.loading ? 'PLEASE WAIT' : 'LOGIN',
                        disabled: auth.loading,
                        onPressed: _submit,
                        trailing: auth.loading
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.arrow_forward,
                                color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _decoration(label, icon),
    );
  }
}

InputDecoration _decoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.crimson, width: 1.5)),
  );
}
