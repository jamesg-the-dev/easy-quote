import 'package:easy_quote/ui/components/icon_button.dart';
import 'package:easy_quote/ui/components/text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_quote/models/quote.dart';
import 'package:easy_quote/services/quote_store.dart';

class SendQuoteScreen extends StatefulWidget {
  final String quoteId;

  const SendQuoteScreen({super.key, required this.quoteId});

  @override
  State<SendQuoteScreen> createState() => _SendQuoteScreenState();
}

class _SendQuoteScreenState extends State<SendQuoteScreen> {
  String? method; // 'email' or 'sms'
  bool sent = false;

  void handleSend(Quote quote) {
    if (method == null) {
      _showAlert('Please select a delivery method');
      return;
    }

    // Update quote status
    final store = Provider.of<QuoteStore>(context, listen: false);
    store.updateQuote(quote.id, {
      'status': 'Sent',
      'sentAt': DateTime.now().toIso8601String(),
    });

    setState(() => sent = true);

    // Navigate back after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteStore>(
      builder: (context, quoteStore, _) {
        final quote = quoteStore.getQuote(widget.quoteId);

        if (quote == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Quote not found',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Return home'),
                  ),
                ],
              ),
            ),
          );
        }

        if (sent) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFDCFCE7),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 40,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Quote Sent!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${quote.clientName} will receive your quote via ${method == 'email' ? 'email' : 'SMS'}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4B5563),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: AppIconButton(
              icon: Icons.arrow_back,
              color: Color(0xFF6B7280),
              onTap: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Send Quote',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: const Color(0xFFE5E7EB)),
            ),
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipient Info
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sending to',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              quote.clientName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            if (quote.jobDescription.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                quote.jobDescription,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Delivery Method
                      const Text(
                        'Choose delivery method',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Email Option
                      _buildMethodButton(
                        icon: Icons.email,
                        title: 'Email',
                        subtitle: 'Send via email with tracking',
                        isSelected: method == 'email',
                        onTap: () => setState(() => method = 'email'),
                      ),
                      const SizedBox(height: 12),
                      // SMS Option
                      _buildMethodButton(
                        icon: Icons.message,
                        title: 'SMS',
                        subtitle: 'Send via text message',
                        isSelected: method == 'sms',
                        onTap: () => setState(() => method = 'sms'),
                      ),
                      const SizedBox(height: 32),
                      // Confirmation Message
                      if (method != null)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1E3A8A),
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Double check: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: 'This quote will be sent to '),
                                TextSpan(
                                  text: quote.clientName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (quote.jobDescription.isNotEmpty)
                                  TextSpan(text: ' at ${quote.jobDescription}'),
                                const TextSpan(
                                  text:
                                      '. The client will be able to view and respond to the quote.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0),
                        Colors.white.withValues(alpha: 0.5),
                        Colors.white,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: AppButton(
                    label: 'Send Secure Link',
                    size: ButtonSize.lg,
                    fullWidth: true,
                    onTap: method != null ? () => handleSend(quote) : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMethodButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF111827)
                  : const Color(0xFFE5E7EB),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? const Color(0xFFF9FAFB) : Colors.white,
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFF111827)
                      : const Color(0xFFF3F4F6),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF111827),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
