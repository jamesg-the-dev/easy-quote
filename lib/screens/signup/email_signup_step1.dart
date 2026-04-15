import 'package:easy_quote/ui/components/logo.dart';
import 'package:flutter/material.dart';
import 'package:easy_quote/ui/components/text_button.dart';
import 'package:easy_quote/ui/components/input_decoration.dart';

class EmailSignupStep1 extends StatefulWidget {
  const EmailSignupStep1({super.key});

  @override
  State<EmailSignupStep1> createState() => _EmailSignupStep1State();
}

class _EmailSignupStep1State extends State<EmailSignupStep1> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
        }
        return;
      }

      setState(() => _isLoading = true);
      try {
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
  }

  void _handleBack() {
    Navigator.of(context).pop();
  }

  void _handleSignIn() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: _handleBack,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.chevron_left,
                              size: 20,
                              color: Color(0xFF71717A),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Back',
                              style: TextStyle(
                                color: Color(0xFF71717A),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Logo Section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: AppLogo(variant: AppLogoVariant.withText),
                    ),

                    // Heading
                    const Text(
                      'Create your account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your details to get started',
                      style: TextStyle(fontSize: 14, color: Color(0xFF71717A)),
                    ),
                    const SizedBox(height: 32),

                    // Email Field
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email address',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF52525B),
                            ),
                          ),
                          const SizedBox(height: 8),
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
                            decoration: AppInputDecoration.standard(
                              hintText: 'you@example.com',
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Password Field
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF52525B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Password is required';
                              }
                              if (value!.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                            decoration: AppInputDecoration.standard(
                              hintText: 'At least 8 characters',
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Confirm Password Field
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Confirm password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF52525B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please confirm your password';
                              }
                              if (value!.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                            decoration: AppInputDecoration.standard(
                              hintText: 'Re-enter your password',
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Submit Button
                    AppButton(
                      label: 'Continue',
                      onTap: _isLoading ? null : _handleSubmit,
                      disabled: _isLoading,
                      loading: _isLoading,
                      variant: ButtonVariant.primary,
                      size: ButtonSize.lg,
                      fullWidth: true,
                    ),

                    // Footer
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF71717A),
                            ),
                          ),
                          AppButton(
                            onTap: _handleSignIn,
                            label: 'Sign in',
                            variant: ButtonVariant.link,
                          ),
                        ],
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
