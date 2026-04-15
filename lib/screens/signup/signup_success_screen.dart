import 'package:flutter/material.dart';
import 'package:easy_quote/ui/components/logo.dart';
import 'package:easy_quote/ui/components/text_button.dart';

class SignupSuccessScreen extends StatelessWidget {
  const SignupSuccessScreen({super.key});

  void _handleCreateQuote(BuildContext context) {
    debugPrint('Create first quote');
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _handleImportLater(BuildContext context) {
    debugPrint('Import customers later');
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
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Logo Section
                    const AppLogo(),
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
                    const SizedBox(height: 12),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD4D4D8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _handleImportLater(context),
                          borderRadius: BorderRadius.circular(12),
                          hoverColor: const Color(0xFFFAFAFA),
                          child: const Center(
                            child: Text(
                              'Import customers later',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Additional Info Card
                    Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE4E4E7)),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'What\'s next?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoItem(
                              'Add your first customer and create a quote',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoItem('Customize your quote templates'),
                            const SizedBox(height: 8),
                            _buildInfoItem(
                              'Send quotes directly to clients via email',
                            ),
                          ],
                        ),
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
