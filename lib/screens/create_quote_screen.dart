import 'package:easy_quote/screens/send_quote_screen.dart';
import 'package:easy_quote/ui/components/icon_button.dart';
import 'package:easy_quote/ui/components/text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';
import '../services/quote_store.dart';

class CreateQuoteScreen extends StatefulWidget {
  const CreateQuoteScreen({super.key});

  @override
  State<CreateQuoteScreen> createState() => _CreateQuoteScreenState();
}

class _CreateQuoteScreenState extends State<CreateQuoteScreen> {
  // Mode toggle
  String mode = 'quick'; // 'quick' or 'detailed'

  // Controllers
  late TextEditingController jobDescriptionController;
  late TextEditingController totalPriceController;
  late TextEditingController clientContactController;
  late TextEditingController clientNameController;

  // Detailed quote fields
  List<LineItem> lineItems = [LineItem(id: '1', description: '', price: 0)];
  bool showDetailedBreakdown = false;

  // Contact picker state
  Map<String, String>? selectedContact;

  @override
  void initState() {
    super.initState();
    jobDescriptionController = TextEditingController();
    totalPriceController = TextEditingController();
    clientContactController = TextEditingController();
    clientNameController = TextEditingController();
  }

  @override
  void dispose() {
    jobDescriptionController.dispose();
    totalPriceController.dispose();
    clientContactController.dispose();
    clientNameController.dispose();
    super.dispose();
  }

  void addLineItem() {
    setState(() {
      lineItems.add(
        LineItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          description: '',
          price: 0,
        ),
      );
    });
  }

  void updateLineItem(String id, String field, dynamic value) {
    setState(() {
      final index = lineItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = lineItems[index];
        if (field == 'description') {
          lineItems[index] = LineItem(
            id: item.id,
            description: value as String,
            price: item.price,
          );
        } else if (field == 'price') {
          lineItems[index] = LineItem(
            id: item.id,
            description: item.description,
            price: value as double,
          );
        }
      }
    });
  }

  void removeLineItem(String id) {
    if (lineItems.length > 1) {
      setState(() {
        lineItems.removeWhere((item) => item.id == id);
      });
    }
  }

  double get detailedTotal =>
      lineItems.fold(0.0, (sum, item) => sum + item.price);

  void handleSelectContact(Map<String, String> contact) {
    setState(() {
      selectedContact = contact;
      if (mode == 'detailed') {
        clientNameController.text = contact['name'] ?? '';
      }
      clientContactController.text = contact['phone'] ?? '';
    });
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
  }

  String _formatQuoteForSharing(Quote quote) {
    final buffer = StringBuffer();
    buffer.writeln('Quote for: ${quote.clientName}');
    buffer.writeln('Job: ${quote.jobDescription}');
    buffer.writeln('');
    buffer.writeln('--- Cost Breakdown ---');
    for (final item in quote.lineItems) {
      buffer.writeln('${item.description}: ${_formatCurrency(item.price)}');
    }
    buffer.writeln('');
    buffer.writeln('Total: ${_formatCurrency(quote.total)}');
    buffer.writeln('');
    buffer.writeln(
      'Created: ${DateTime.parse(quote.createdAt).toLocal().toString().split('.')[0]}',
    );
    return buffer.toString();
  }

  void handleSendQuote() {
    final store = Provider.of<QuoteStore>(context, listen: false);

    if (mode == 'quick') {
      // Quick quote validation
      if (jobDescriptionController.text.trim().isEmpty) {
        _showAlert('Please describe the job');
        return;
      }
      final price = double.tryParse(totalPriceController.text);
      if (price == null || price <= 0) {
        _showAlert('Please enter a valid price');
        return;
      }

      final newQuote = Quote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        clientName:
            selectedContact?['name'] ??
            (clientContactController.text.contains('@')
                ? 'Client'
                : clientContactController.text),
        jobDescription: jobDescriptionController.text.trim(),
        lineItems: [
          LineItem(
            id: '1',
            description: jobDescriptionController.text.trim(),
            price: price,
          ),
        ],
        total: price,
        status: 'Draft',
        createdAt: DateTime.now().toIso8601String(),
      );

      store.addQuote(newQuote);
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SendQuoteScreen(quoteId: newQuote.id),
          ),
        );
      }
    } else {
      // Detailed quote validation
      if (clientNameController.text.trim().isEmpty ||
          jobDescriptionController.text.trim().isEmpty) {
        _showAlert('Please fill in client name and job description');
        return;
      }

      final validLineItems = lineItems
          .where((item) => item.description.trim().isNotEmpty && item.price > 0)
          .toList();
      if (validLineItems.isEmpty) {
        _showAlert('Please add at least one line item');
        return;
      }

      final newQuote = Quote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        clientName: clientNameController.text.trim(),
        jobDescription: jobDescriptionController.text.trim(),
        lineItems: validLineItems,
        total: detailedTotal,
        status: 'Draft',
        createdAt: DateTime.now().toIso8601String(),
      );

      store.addQuote(newQuote);
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SendQuoteScreen(quoteId: newQuote.id),
          ),
        );
      }
    }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: AppIconButton(
          icon: Icons.close,
          color: const Color(0xFF111827),
          onTap: () => Navigator.of(context).pop(),
        ),
        actions: [
          AppButton(
            label: mode == 'quick' ? 'Detailed mode' : 'Quick mode',
            onTap: () {
              setState(() {
                mode = mode == 'quick' ? 'detailed' : 'quick';
              });
            },
            variant: ButtonVariant.link,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: mode == 'quick' ? _buildQuickMode() : _buildDetailedMode(),
          ),
          // Sticky Send Button
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
                  label: 'Send Quote',
                  onTap: handleSendQuote,
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

  Widget _buildQuickMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step 1: Job
          _buildStep(
            title: "What's the job?",
            child: TextField(
              controller: jobDescriptionController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Kitchen sink replacement',
                hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
                border: InputBorder.none,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 2),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF111827), width: 2),
                ),
                contentPadding: const EdgeInsets.only(bottom: 12),
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(height: 48),
          _buildStep(
            title: 'How much?',
            child: Row(
              children: [
                const Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: totalPriceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
                      border: InputBorder.none,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 2,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF111827),
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          _buildStep(
            title: 'Who\'s it for?',
            child: TextField(
              controller: clientContactController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter phone/email',
                hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
                border: InputBorder.none,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 2),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF111827), width: 2),
                ),
                contentPadding: const EdgeInsets.only(bottom: 12),
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(height: 48),
          // Add breakdown button
          TextButton(
            onPressed: () {
              setState(() {
                mode = 'detailed';
                clientNameController.text = selectedContact?['name'] ?? '';
                lineItems = [
                  LineItem(
                    id: '1',
                    description: jobDescriptionController.text,
                    price: double.tryParse(totalPriceController.text) ?? 0,
                  ),
                ];
              });
            },
            child: const Text(
              '+ Add cost breakdown',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client Info
          TextField(
            controller: clientNameController,
            decoration: InputDecoration(
              hintText: 'Client name',
              hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
              border: InputBorder.none,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 2),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF111827), width: 2),
              ),
              contentPadding: const EdgeInsets.only(bottom: 12),
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: jobDescriptionController,
            decoration: InputDecoration(
              hintText: 'Job description',
              hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
              border: InputBorder.none,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 2),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF111827), width: 2),
              ),
              contentPadding: const EdgeInsets.only(bottom: 12),
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 32),
          // Line Items Section
          _buildLineItemsSection(),
          const SizedBox(height: 32),
          // Total
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatCurrency(detailedTotal),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildCustomAccordion() {
    return GestureDetector(
      onTap: () =>
          setState(() => showDetailedBreakdown = !showDetailedBreakdown),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cost Breakdown',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            AnimatedRotation(
              turns: showDetailedBreakdown ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.expand_more, color: Color(0xFF374151)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomAccordion(),
        if (showDetailedBreakdown) ...[
          const SizedBox(height: 16),
          ...lineItems.asMap().entries.map((entry) {
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) =>
                              updateLineItem(item.id, 'description', value),
                          decoration: InputDecoration(
                            hintText: 'Item description',
                            hintStyle: const TextStyle(
                              color: Color(0xFFD1D5DB),
                            ),
                            border: InputBorder.none,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF111827),
                                width: 1,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      if (lineItems.length > 1)
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF6B7280),
                          ),
                          onPressed: () => removeLineItem(item.id),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        '\$',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TextField(
                          onChanged: (value) => updateLineItem(
                            item.id,
                            'price',
                            double.tryParse(value) ?? 0,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: const TextStyle(
                              color: Color(0xFFD1D5DB),
                            ),
                            border: InputBorder.none,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF111827),
                                width: 1,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(17, 24, 39, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: addLineItem,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add item'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF4B5563),
            ),
          ),
        ],
      ],
    );
  }
}
