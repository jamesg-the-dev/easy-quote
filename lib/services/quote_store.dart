import 'package:flutter/foundation.dart';
import '../models/quote.dart';

class QuoteStore extends ChangeNotifier {
  final Map<String, Quote> _quotes = {};

  List<Quote> get quotes => _quotes.values.toList();

  Quote? getQuote(String id) => _quotes[id];

  void addQuote(Quote q) {
    _quotes[q.id] = q;
    notifyListeners();
  }

  void updateQuote(String id, Map<String, dynamic> patch) {
    final q = _quotes[id];
    if (q == null) return;
    if (patch.containsKey('status')) q.status = patch['status'] as String;
    if (patch.containsKey('viewedAt')) q.viewedAt = patch['viewedAt'] as String;
    if (patch.containsKey('respondedAt')) q.respondedAt = patch['respondedAt'] as String;
    notifyListeners();
  }

  void deleteQuote(String id) {
    _quotes.remove(id);
    notifyListeners();
  }
}
