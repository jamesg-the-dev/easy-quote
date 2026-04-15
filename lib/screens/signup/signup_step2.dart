import 'package:flutter/material.dart';
import 'package:easy_quote/ui/components/logo.dart';
import 'package:easy_quote/ui/components/text_button.dart';
import 'package:easy_quote/ui/components/input_decoration.dart';
import 'package:provider/provider.dart';
import 'package:easy_quote/services/signup_store.dart';

class SignupStep2 extends StatefulWidget {
  const SignupStep2({super.key});

  @override
  State<SignupStep2> createState() => _SignupStep2State();
}

class _SignupStep2State extends State<SignupStep2> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with stored data from SignupStore
    final signupStore = context.read<SignupStore>();
    _fullNameController = TextEditingController(text: signupStore.fullName);
    _phoneNumberController = TextEditingController(
      text: signupStore.phoneNumber,
    );

    // Listen for text changes and update store
    _fullNameController.addListener(() {
      context.read<SignupStore>().fullName = _fullNameController.text;
    });
    _phoneNumberController.addListener(() {
      context.read<SignupStore>().phoneNumber = _phoneNumberController.text;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // Data is already saved to SignupStore via listeners
        if (mounted) {
          Navigator.of(context).pushNamed('/signup/business');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _handleBack() {
    Navigator.of(context).pop();
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: AppLogo(variant: AppLogoVariant.withText),
                    ),

                    // Progress Indicator
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE4E4E7),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),

                    // Heading
                    const Text(
                      'Tell us about you',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We\'ll use this to personalize your experience',
                      style: TextStyle(fontSize: 14, color: Color(0xFF71717A)),
                    ),
                    const SizedBox(height: 32),

                    // Full Name Field
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Full name',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF52525B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _fullNameController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Full name is required';
                              }
                              return null;
                            },
                            decoration: AppInputDecoration.standard(
                              hintText: 'John Smith',
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Phone Number Field
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Phone number ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF52525B),
                                  ),
                                ),
                                TextSpan(
                                  text: '(optional)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFA1A1A6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: AppInputDecoration.standard(
                              hintText: '0412 345 678',
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
                      label: 'Next',
                      onTap: _isLoading ? null : _handleSubmit,
                      disabled: _isLoading,
                      loading: _isLoading,
                      variant: ButtonVariant.primary,
                      size: ButtonSize.lg,
                      fullWidth: true,
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
