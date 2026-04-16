import 'package:easy_quote/ui/components/text_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_quote/ui/components/google_button.dart';
import 'package:easy_quote/ui/components/apple_button.dart';

class SignupWelcomeScreen extends StatefulWidget {
  const SignupWelcomeScreen({super.key});

  @override
  State<SignupWelcomeScreen> createState() => _SignupWelcomeScreenState();
}

class _SignupWelcomeScreenState extends State<SignupWelcomeScreen> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignUp() async {
    debugPrint('Google sign up clicked');
    setState(() => _isLoading = true);
    try {
      // TODO: Implement Google OAuth flow
      // For now, navigate to details screen
      if (mounted) {
        Navigator.of(context).pushNamed('/signup/details');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign up failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignUp() async {
    debugPrint('Apple sign up clicked');
    setState(() => _isLoading = true);
    try {
      // TODO: Implement Apple OAuth flow
      // For now, navigate to details screen
      if (mounted) {
        Navigator.of(context).pushNamed('/signup/details');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign up failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleEmailSignUp() {
    Navigator.of(context).pushNamed('/signup/email');
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo/Brand Section
                    _buildLogoSection(),
                    const SizedBox(height: 48),

                    // Social Sign Up Buttons
                    GoogleButton(
                      onTap: _handleGoogleSignUp,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 12),
                    AppleButton(
                      onTap: _handleAppleSignUp,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 32),

                    // Divider
                    _buildDivider(),
                    const SizedBox(height: 32),

                    // Email Button
                    _buildEmailButton(),
                    const SizedBox(height: 16),

                    _buildHaveAccountText(),
                    const SizedBox(height: 16),

                    // Footer Text
                    _buildFooterText(),
                  ],
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
          'Easy Quote',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Create and send quotes in seconds',
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
            style: TextStyle(color: Color(0xFFA1A1A6), fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4D4D8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleEmailSignUp,
          borderRadius: BorderRadius.circular(12),
          hoverColor: const Color(0xFFFAFAFA),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue with Email',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return const Text(
      'By continuing, you agree to our Terms of Service and Privacy Policy',
      textAlign: TextAlign.center,
      style: TextStyle(color: Color(0xFFA1A1A6), fontSize: 12),
    );
  }

  Widget _buildHaveAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(color: Color(0xFF525252), fontSize: 14),
        ),
        AppButton(
          onTap: () => Navigator.of(context).pushNamed('/login'),
          label: 'Sign in',
          variant: ButtonVariant.link,
        ),
      ],
    );
  }
}
