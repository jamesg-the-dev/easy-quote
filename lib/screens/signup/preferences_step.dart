import 'package:flutter/material.dart';
import 'package:easy_quote/ui/components/logo.dart';
import 'package:easy_quote/ui/components/text_button.dart';

class PreferencesStep extends StatefulWidget {
  const PreferencesStep({super.key});

  @override
  State<PreferencesStep> createState() => _PreferencesStepState();
}

class _PreferencesStepState extends State<PreferencesStep> {
  bool _enableGST = true;
  bool _defaultCurrencyAUD = true;
  bool _receiveOnboardingTips = true;
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);
    try {
      debugPrint(
        'Preferences: enableGST=$_enableGST, defaultCurrencyAUD=$_defaultCurrencyAUD, receiveOnboardingTips=$_receiveOnboardingTips',
      );
      if (mounted) {
        Navigator.of(context).pushNamed('/success');
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

  void _handleBack() {
    Navigator.of(context).pop();
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
                      child: AppLogo(),
                    ),

                    // Progress Indicator (3 of 3)
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
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Heading
                    const Text(
                      'Preferences',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Customize your quoting defaults',
                      style: TextStyle(fontSize: 14, color: Color(0xFF71717A)),
                    ),
                    const SizedBox(height: 32),

                    // Preferences Card
                    Container(
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
                        children: [
                          // GST Toggle
                          _buildToggleOption(
                            title: 'Enable GST defaults',
                            description:
                                'Automatically include 10% GST in quotes',
                            value: _enableGST,
                            onChanged: (value) {
                              setState(() => _enableGST = value);
                            },
                            isFirst: true,
                          ),

                          // Divider
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Divider(
                              height: 1,
                              color: const Color(0xFFE4E4E7),
                            ),
                          ),

                          // Currency Toggle
                          _buildToggleOption(
                            title: 'Default currency AUD',
                            description: 'Use Australian dollars by default',
                            value: _defaultCurrencyAUD,
                            onChanged: (value) {
                              setState(() => _defaultCurrencyAUD = value);
                            },
                          ),

                          // Divider
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Divider(
                              height: 1,
                              color: const Color(0xFFE4E4E7),
                            ),
                          ),

                          // Onboarding Tips Toggle
                          _buildToggleOption(
                            title: 'Receive onboarding tips',
                            description: 'Get helpful tips to get started',
                            value: _receiveOnboardingTips,
                            onChanged: (value) {
                              setState(() => _receiveOnboardingTips = value);
                            },
                          ),
                        ],
                      ),
                    ),

                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: AppButton(
                        label: 'Finish setup',
                        onTap: _isLoading ? null : _handleSubmit,
                        disabled: _isLoading,
                        loading: _isLoading,
                        variant: ButtonVariant.primary,
                        size: ButtonSize.lg,
                        fullWidth: true,
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

  Widget _buildToggleOption({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isFirst = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 13, color: Color(0xFF71717A)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.black,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFE4E4E7),
        ),
      ],
    );
  }
}
