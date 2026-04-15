import 'package:flutter/material.dart';
import 'package:easy_quote/ui/components/logo.dart';
import 'package:easy_quote/ui/components/text_button.dart';
import 'package:provider/provider.dart';
import 'package:easy_quote/services/signup_store.dart';

class SignupSuccessScreen extends StatelessWidget {
  const SignupSuccessScreen({super.key});

  void _handleCreateQuote(BuildContext context) {
    context.read<SignupStore>().clearSignupData();
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _handleImportLater(BuildContext context) {
    context.read<SignupStore>().clearSignupData();
    Navigator.of(context).pushReplacementNamed('/home');
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Success Icon
                    Center(
                      child: Icon(
                        Icons.check_circle,
                        size: 70,
                        color: Colors.green.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Heading
                    const Text(
                      'You\'re ready to start quoting',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your account is all set up. Let\'s create your first quote and get your business moving.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF71717A)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    AppButton(
                      label: 'Create your first quote',
                      onTap: () => _handleCreateQuote(context),
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

  Widget _buildInfoItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8, top: 2),
          child: Text('•', style: TextStyle(fontSize: 14, color: Colors.black)),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
          ),
        ),
      ],
    );
  }
}
