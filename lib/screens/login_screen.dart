import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_quote/services/auth_store.dart';
import 'package:easy_quote/ui/components/text_button.dart';
import 'package:easy_quote/ui/components/google_button.dart';
import 'package:easy_quote/ui/components/apple_button.dart';
import 'package:easy_quote/ui/components/input_decoration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await context.read<AuthStore>().signInWithGoogle();
      // AuthGate will automatically detect auth state change and rebuild
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await context.read<AuthStore>().signInWithApple();
      // AuthGate will automatically detect auth state change and rebuild
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleEmailSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await context.read<AuthStore>().signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
        // AuthGate will automatically detect auth state change and rebuild
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _handleForgotPassword() {
    debugPrint('Forgot password clicked');
  }

  void _handleSignUp() {
    Navigator.of(context).pushNamed('/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo/Brand Section
                      _buildLogoSection(),
                      const SizedBox(height: 48),

                      // Social Sign In Buttons
                      GoogleButton(
                        onTap: _handleGoogleSignIn,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 12),
                      AppleButton(
                        onTap: _handleAppleSignIn,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 32),

                      // Divider
                      _buildDivider(),
                      const SizedBox(height: 32),

                      // Email Sign In Form
                      _buildEmailForm(),
                      const SizedBox(height: 32),

                      // Sign Up Link
                      _buildSignUpLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Logo placeholder
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFD4D4D8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFA1A1A6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to continue',
          style: TextStyle(fontSize: 14, color: Color(0xFF525252)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(height: 1, color: const Color(0xFFD4D4D8)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: const Color(0xFFFAFAFA),
          child: const Text(
            'or',
            style: TextStyle(color: Color(0xFF71717A), fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        // Email Input
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Email is required';
            }
            if (!value!.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
          decoration: AppInputDecoration.standard(hintText: 'Email address'),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 16),

        // Password Input
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Password is required';
            }
            return null;
          },
          decoration: AppInputDecoration.standard(hintText: 'Password'),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 12),

        // Forgot Password Button
        Align(
          alignment: Alignment.centerRight,
          child: AppButton(
            onTap: _handleForgotPassword,
            label: 'Forgot password?',
            variant: ButtonVariant.ghost,
          ),
        ),
        const SizedBox(height: 16),

        // Sign In Button (using custom AppButton)
        AppButton(
          label: 'Sign in',
          onTap: _isLoading ? null : _handleEmailSignIn,
          disabled: _isLoading,
          loading: _isLoading,
          variant: ButtonVariant.primary,
          size: ButtonSize.lg,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account? ',
          style: TextStyle(color: Color(0xFF525252), fontSize: 14),
        ),
        AppButton(
          onTap: _handleSignUp,
          label: 'Sign up',
          variant: ButtonVariant.link,
        ),
      ],
    );
  }
}
