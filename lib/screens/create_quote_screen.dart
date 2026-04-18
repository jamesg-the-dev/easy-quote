import 'package:easy_quote/screens/send_quote_screen.dart';
import 'package:easy_quote/ui/components/icon_button.dart';
import 'package:easy_quote/ui/components/text_button.dart';
import 'package:easy_quote/ui/theme/app_colors.dart';
import 'package:easy_quote/ui/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_quote/models/quote.dart';
import 'package:easy_quote/services/quote_store.dart';

class CreateQuoteScreen extends StatefulWidget {
  const CreateQuoteScreen({super.key});

  @override
  State<CreateQuoteScreen> createState() => _CreateQuoteScreenState();
}

class _CreateQuoteScreenState extends State<CreateQuoteScreen> {
  bool openBreakDown = false;
  // Controllers
  late TextEditingController jobDescriptionController;
  late TextEditingController totalPriceController;
  late TextEditingController clientNameController;

  // Detailed quote fields
  List<LineItem> lineItems = [LineItem(id: '1', description: '', price: 0)];
  bool showDetailedBreakdown = false;

  @override
  void initState() {
    super.initState();
    jobDescriptionController = TextEditingController();
    totalPriceController = TextEditingController();
    clientNameController = TextEditingController();
  }

  @override
  void dispose() {
    jobDescriptionController.dispose();
    totalPriceController.dispose();
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

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
  }

  void handleSendQuote() {
    final store = Provider.of<QuoteStore>(context, listen: false);

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

    // Detailed quote validation
    if (clientNameController.text.trim().isEmpty ||
        jobDescriptionController.text.trim().isEmpty) {
      _showAlert('Please fill in client name and job description');
      return;
    }

    List<LineItem> lineItems = [
      LineItem(
        id: '1',
        description: jobDescriptionController.text.trim(),
        price: price,
      ),
    ];

    if (lineItems.isNotEmpty) {
      lineItems = lineItems
          .where((item) => item.description.trim().isNotEmpty && item.price > 0)
          .toList();
    }

    final newQuote = Quote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clientName: clientNameController.text.trim(),
      jobDescription: jobDescriptionController.text.trim(),
      lineItems: lineItems,
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: AppIconButton(
            icon: Icons.close,
            color: const Color(0xFF111827),
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: _buildQuoteForm(),
            ),
            // Sticky Send Button with Total
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
                    label: 'Share Quote ${_formatCurrency(detailedTotal)}',
                    onTap: handleSendQuote,
                    size: ButtonSize.lg,
                    variant: ButtonVariant.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            title: 'Who\'s it for?',
            child: TextField(
              controller: clientNameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter client name',
                hintStyle: TextStyle(color: context.colors.inputHint),
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
          const SizedBox(height: 32),
          _buildLineItemsSection(),
          const SizedBox(height: 32),
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

  Widget _buildLineItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and Add button
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cost breakdown',
                style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
              ),
              AppButton(
                onTap: addLineItem,
                leftIcon: const Icon(Icons.add),
                label: 'Add item',
                variant: ButtonVariant.ghost,
                size: ButtonSize.sm,
              ),
            ],
          ),
        ),
        // Line items list
        Column(
          children: lineItems.asMap().entries.map((entry) {
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description input with delete button
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) =>
                                updateLineItem(item.id, 'description', value),
                            decoration: const InputDecoration(
                              hintText: 'Labor, materials, etc.',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        if (lineItems.length > 1)
                          AppIconButton(
                            icon: Icons.delete_outline,
                            color: context.colors.danger,
                            onTap: () => removeLineItem(item.id),
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Price input
                    Row(
                      children: [
                        const Text(
                          '\$',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
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
                            decoration: const InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
