import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../ui/elena_ui_system.dart';
import '../../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    try {
      final authController = ref.read(authControllerProvider.notifier);
      await authController.signIn(
          _emailController.text.trim(), _passwordController.text);
      if (mounted) context.go('/dashboard');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: ElenaColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: ElenaCenteredLayout(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo y título, centrados
                Center(
                  child: Image.asset(
                    'assets/logo_elena.png',
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 22),

                Text('Bienvenid@ a Elena',
                    style: ElenaText.title, textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text(
                  'Tu metamorfosis comienza ahora...',
                  style: ElenaText.subtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo de email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'tu@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: Validators.email,
                  enabled: !authState.isLoading,
                ),
                const SizedBox(height: 16),

                // Campo de contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    hintText: 'Mínimo 6 caracteres',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: Validators.password,
                  enabled: !authState.isLoading,
                ),
                const SizedBox(height: 24),

                // Botón de login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ElenaColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: authState.isLoading ? null : _handleLogin,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Iniciar Sesión', style: ElenaText.button),
                ),
                const SizedBox(height: 12),

                // Link a registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta? '),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: ElenaColors.primary,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: authState.isLoading
                          ? null
                          : () => context.go('/register'),
                      child: const Text('Crear Cuenta'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
