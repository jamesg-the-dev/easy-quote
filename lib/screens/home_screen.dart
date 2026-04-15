import 'package:easy_quote/ui/components/icon_button.dart';
import 'package:easy_quote/ui/components/text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_quote/services/quote_store.dart';
import 'package:easy_quote/services/auth_store.dart';
import 'create_quote_screen.dart';
import 'review_quote_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Returns the appropriate icon widget for a quote status
  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'Sent':
        return const Icon(Icons.send, size: 20);
      case 'Viewed':
        return const Icon(Icons.visibility, size: 20);
      case 'Accepted':
        return const Icon(Icons.check_circle, size: 20);
      case 'Rejected':
        return const Icon(Icons.cancel, size: 20);
      default:
        return const Icon(Icons.schedule, size: 20);
    }
  }

  /// Returns the color scheme for a quote status
  Map<String, Color> _getStatusColors(String status) {
    switch (status) {
      case 'Sent':
        return {
          'background': Color(0xFFEFF6FF),
          'text': Color(0xFF0369A1),
          'border': Color(0xFFBFDBFE),
        };
      case 'Viewed':
        return {
          'background': Color(0xFFFAF5FF),
          'text': Color(0xFF7E22CE),
          'border': Color(0xFFE9D5FF),
        };
      case 'Accepted':
        return {
          'background': Color(0xFFF0FDF4),
          'text': Color(0xFF16A34A),
          'border': Color(0xFFBBF7D0),
        };
      case 'Rejected':
        return {
          'background': Color(0xFFFEF2F2),
          'text': Color(0xFFDC2626),
          'border': Color(0xFFFECACA),
        };
      default:
        return {
          'background': Color(0xFFF9FAFB),
          'text': Color(0xFF374151),
          'border': Color(0xFFE5E7EB),
        };
    }
  }

  /// Formats a date string to a relative time format
  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return _formatDateShort(date);
    }
  }

  /// Formats a date to short format (e.g., "Jan 15")
  String _formatDateShort(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  /// Formats currency with proper formatting
  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                title: const Text(
                  'Quotes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                actions: [
                  AppIconButton(
                    icon: Icons.logout,
                    color: Color(0xFF6B7280),
                    onTap: () async {
                      await context.read<AuthStore>().signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(height: 1, color: Color(0xFFE5E7EB)),
                ),
              ),
              // Quotes List
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: Consumer<QuoteStore>(
                  builder: (context, quoteStore, _) {
                    final quotes = quoteStore.quotes;

                    if (quotes.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 64),
                            child: Column(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF3F4F6),
                                  ),
                                  child: Icon(
                                    Icons.schedule,
                                    size: 32,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No quotes yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Create your first quote to get started',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final quote = quotes[index];
                        final colors = _getStatusColors(quote.status);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ReviewQuoteScreen(quoteId: quote.id),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xFFE5E7EB)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Client name and status
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                quote.clientName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF111827),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                quote.jobDescription,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF6B7280),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Status badge
                                        Container(
                                          decoration: BoxDecoration(
                                            color: colors['background'],
                                            border: Border.all(
                                              color: colors['border']!,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconTheme(
                                                data: IconThemeData(
                                                  color: colors['text'],
                                                ),
                                                child: _getStatusIcon(
                                                  quote.status,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                quote.status,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: colors['text'],
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Total and date
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatCurrency(quote.total),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF111827),
                                          ),
                                        ),
                                        Text(
                                          _formatDate(quote.createdAt),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }, childCount: quotes.length),
                    );
                  },
                ),
              ),
              // Bottom spacing for button
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 120),
                sliver: SliverToBoxAdapter(child: Container()),
              ),
            ],
          ),
          // Bottom button with gradient
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
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  leftIcon: const Icon(Icons.add, color: Color(0xFFFFFFFF)),
                  label: 'Create Quote',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CreateQuoteScreen(),
                      ),
                    );
                  },
                  size: ButtonSize.lg,
                  variant: ButtonVariant.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
