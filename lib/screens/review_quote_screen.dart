import 'package:easy_quote/ui/components/icon_button.dart';
import 'package:easy_quote/ui/components/text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quote.dart';
import '../services/quote_store.dart';
import 'send_quote_screen.dart';

class ReviewQuoteScreen extends StatelessWidget {
  final String quoteId;

  const ReviewQuoteScreen({super.key, required this.quoteId});

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
  }

  String _formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${_getMonthName(date.month)} ${date.day}, ${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  void _handleDelete(BuildContext context, Quote quote) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quote'),
        content: const Text('Are you sure you want to delete this quote?'),
        actions: [
          AppButton(onTap: () => Navigator.of(context).pop(), label: 'Cancel'),
          AppButton(
            label: 'Delete',
            variant: ButtonVariant.danger,
            onTap: () {
              final store = Provider.of<QuoteStore>(context, listen: false);
              store.deleteQuote(quote.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteStore>(
      builder: (context, quoteStore, _) {
        final quote = quoteStore.getQuote(quoteId);

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

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: AppIconButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.of(context).pop(),
              color: const Color(0xFF111827),
            ),
            title: const Text(
              'Quote',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            actions: [
              AppIconButton(
                icon: Icons.delete,
                color: Theme.of(context).colorScheme.error,
                onTap: () => _handleDelete(context, quote),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: const Color(0xFFE5E7EB)),
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quote For',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            quote.clientName,
                            style: const TextStyle(
                              fontSize: 28,
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
                      const SizedBox(height: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Job Description',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            quote.jobDescription,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF111827),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Breakdown',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...quote.lineItems.asMap().entries.map((entry) {
                            final item = entry.value;
                            final isLast =
                                entry.key == quote.lineItems.length - 1;
                            return Padding(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : 0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.description,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        _formatCurrency(item.price),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isLast)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Divider(
                                        height: 1,
                                        color: const Color(0xFFF3F4F6),
                                      ),
                                    )
                                  else
                                    const SizedBox(height: 12),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _formatCurrency(quote.total),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          'Created ${_formatDateTime(quote.createdAt)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              if (quote.status == 'Draft')
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
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                SendQuoteScreen(quoteId: quote.id),
                          ),
                        );
                      },
                      size: ButtonSize.lg,
                      label: 'Send Quote',
                      variant: ButtonVariant.primary,
                      fullWidth: true,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
