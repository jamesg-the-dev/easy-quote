import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quote.dart';
import '../services/quote_store.dart';

class ClientView extends StatefulWidget {
  final String quoteId;
  const ClientView({super.key, required this.quoteId});

  @override
  State<ClientView> createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientView> {
  bool responded = false;
  String? response; // 'Accepted' | 'Rejected'

  @override
  void initState() {
    super.initState();
    final store = Provider.of<QuoteStore>(context, listen: false);
    final quote = store.getQuote(widget.quoteId);
    if (quote != null && quote.status == 'Sent') {
      store.updateQuote(quote.id, {
        'status': 'Viewed',
        'viewedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  void handleResponse(bool accept) {
    final store = Provider.of<QuoteStore>(context, listen: false);
    final quote = store.getQuote(widget.quoteId);
    if (quote == null) return;
    final newStatus = accept ? 'Accepted' : 'Rejected';
    setState(() {
      response = newStatus;
      responded = true;
    });
    store.updateQuote(quote.id, {
      'status': newStatus,
      'respondedAt': DateTime.now().toIso8601String(),
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<QuoteStore>(context);
    final quote = store.getQuote(widget.quoteId);

    if (quote == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Quote not found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Text('This quote link may be invalid or expired.'),
              ],
            ),
          ),
        ),
      );
    }

    if (responded) {
      final accepted = response == 'Accepted';
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: accepted ? Colors.green[100] : Colors.red[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    accepted ? Icons.check_circle : Icons.cancel,
                    size: 48,
                    color: accepted ? Colors.green[700] : Colors.red[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  accepted ? 'Quote Accepted!' : 'Quote Declined',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  accepted
                      ? 'Thank you! We will contact you shortly to schedule the work.'
                      : 'Thank you for your response. Feel free to reach out if you have any questions.',
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
        title: const Text('Your Contractor'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('For', style: TextStyle(color: Colors.grey)),
            Text(quote.clientName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            const Text('Job Description', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
              child: Text(quote.jobDescription),
            ),
            const SizedBox(height: 24),
            const Text('Cost Breakdown', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: quote.lineItems.map((item) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(child: Text(item.description)),
                            Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      if (item != quote.lineItems.last) const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Total Price', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('\$${quote.total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Quote valid for 30 days from ${DateTime.parse(quote.createdAt).toLocal().toString().split(' ').first}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: (quote.status != 'Accepted' && quote.status != 'Rejected')
          ? Container(
              color: Colors.white.withOpacity(0.001),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => handleResponse(true),
                      icon: const Icon(Icons.check, size: 20),
                      label: const Text('Accept Quote'),
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(56), backgroundColor: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => handleResponse(false),
                      icon: const Icon(Icons.close, size: 20),
                      label: const Text('Decline Quote'),
                      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
