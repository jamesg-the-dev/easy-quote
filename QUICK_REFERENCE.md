# Easy Quote Flutter - Quick Reference Guide

## 🎯 Quick Start

### Run the App
```bash
flutter run
```

### Build for Production
```bash
flutter build apk      # Android
flutter build ios      # iOS
flutter build web      # Web
```

---

## 📱 Screen Navigation

### HomeScreen
- **Path**: `/home`
- **Entry Point**: App starts here
- **Actions**:
  - Tap quote card → ReviewQuoteScreen
  - Tap "+ Create Quote" → CreateQuoteScreen

### CreateQuoteScreen
- **Path**: Dialog/Modal from HomeScreen
- **Modes**: Quick (3-step) or Detailed (line items)
- **Actions**:
  - Complete form → Send → Returns to HomeScreen

### ReviewQuoteScreen
- **Path**: `Quote/{id}/review`
- **Parameters**: `quoteId` (String)
- **Actions**:
  - Tap "Send Quote" → SendQuoteScreen
  - Tap delete icon → Delete confirmation → HomeScreen
  - Tap back → HomeScreen

### SendQuoteScreen
- **Path**: `Quote/{id}/send`
- **Parameters**: `quoteId` (String)
- **Actions**:
  - Select method → Tap "Send Secure Link" → Success → HomeScreen (auto after 2s)

---

## 🔧 Common Tasks

### Add a New Quote
```dart
final store = Provider.of<QuoteStore>(context, listen: false);
store.addQuote(Quote(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  clientName: 'Client Name',
  jobDescription: 'Job details',
  lineItems: [LineItem(id: '1', description: 'Item', price: 100)],
  total: 100,
  status: 'Draft',
  createdAt: DateTime.now().toIso8601String(),
));
```

### Update Quote Status
```dart
store.updateQuote(quoteId, {
  'status': 'Sent',
  'sentAt': DateTime.now().toIso8601String(),
});
```

### Delete a Quote
```dart
store.deleteQuote(quoteId);
```

### Get a Quote
```dart
final quote = store.getQuote(quoteId);
```

### Get All Quotes
```dart
final quotes = store.quotes;
```

---

## 🎨 Styling Guide

### Dark Theme Primary Color
```dart
const Color(0xFF111827)  // #111827
```

### Secondary Gray
```dart
const Color(0xFF6B7280)  // #6B7280
```

### Light Background
```dart
const Color(0xFFF9FAFB)  // #F9FAFB
```

### Status Colors
```dart
// Sent - Blue
'background': Color(0xFFEFF6FF),
'text': Color(0xFF0369A1),
'border': Color(0xFFBFDBFE),

// Viewed - Purple
'background': Color(0xFFFAF5FF),
'text': Color(0xFF7E22CE),
'border': Color(0xFFE9D5FF),

// Accepted - Green
'background': Color(0xFFF0FDF4),
'text': Color(0xFF16A34A),
'border': Color(0xFFBBF7D0),

// Rejected - Red
'background': Color(0xFFFEF2F2),
'text': Color(0xFFDC2626),
'border': Color(0xFFFECACA),
```

---

## 📊 Data Models

### Quote
```dart
Quote(
  id: String,                    // Unique identifier
  clientName: String,            // Client name
  jobDescription: String,        // Job details
  lineItems: List<LineItem>,     // Cost breakdown
  total: double,                 // Total amount
  status: String,                // 'Draft', 'Sent', 'Viewed', 'Accepted', 'Rejected'
  createdAt: String,             // ISO 8601 timestamp
  viewedAt: String?,             // Optional viewed timestamp
  respondedAt: String?,          // Optional response timestamp
)
```

### LineItem
```dart
LineItem(
  id: String,            // Unique identifier
  description: String,   // Item description
  price: double,         // Item price
)
```

---

## 🔄 State Management (Provider)

### Setup in main.dart
```dart
ChangeNotifierProvider(
  create: (_) => QuoteStore(),
  child: MaterialApp(
    // ... app config
  ),
)
```

### Access in Widget
```dart
// Listen to changes
Consumer<QuoteStore>(
  builder: (context, quoteStore, _) {
    // Use quoteStore
  },
)

// One-time access
final store = Provider.of<QuoteStore>(context, listen: false);
```

---

## 📝 Formatting Utilities

### Currency
```dart
String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2).replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]},'
  )}';
}
```

### Relative Time
```dart
String _formatDate(String dateString) {
  final date = DateTime.parse(dateString);
  final diff = DateTime.now().difference(date);
  
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  // ... handle older dates
}
```

---

## 🚀 Performance Tips

1. **Use Consumer instead of Provider.of** when you need reactive updates
2. **Use `listen: false`** when you don't need to rebuild on changes
3. **Lazy load images** with cached_network_image package
4. **Batch UI updates** in setState when possible
5. **Use const constructors** for StatelessWidget performance

---

## 🐛 Debugging

### Enable debug output
```bash
flutter run -v  # Verbose output
```

### Check widget tree
```dart
debugPrintBeginFrameBanner = true;
debugPrintEndFrameBanner = true;
```

### Inspect QuoteStore
```dart
// In any widget
final store = Provider.of<QuoteStore>(context, listen: false);
print('All quotes: ${store.quotes}');
print('Quote count: ${store.quotes.length}');
```

---

## 📦 Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── quote.dart             # Quote data models
├── services/
│   └── quote_store.dart       # State management
└── screens/
    ├── home_screen.dart
    ├── create_quote_screen.dart
    ├── review_quote_screen.dart
    └── send_quote_screen.dart
```

---

## 🔐 Status Values

Valid quote status values:
- `'Draft'` - Quote created but not sent
- `'Sent'` - Quote sent to client
- `'Viewed'` - Client viewed the quote
- `'Accepted'` - Client accepted the quote
- `'Rejected'` - Client rejected the quote

---

## 📞 Mock Contacts

8 pre-loaded contacts available in CreateQuoteScreen:
1. John Smith - 0412 345 678
2. Sarah Johnson - 0423 456 789
3. Mike Chen - 0434 567 890
4. Emma Wilson - 0445 678 901
5. David Brown - 0456 789 012
6. Lisa Anderson - 0467 890 123
7. Tom Garcia - 0478 901 234
8. Rachel Martinez - 0489 012 345

---

## 🎓 Key Concepts

### Widget Lifecycle
1. `StatelessWidget` - No state, immutable
2. `StatefulWidget` - Has state, mutable
3. `Consumer` - Rebuilds when Provider notifies
4. `build()` - Called on rebuild, should be pure

### Provider Pattern
1. Create: `ChangeNotifier` class (QuoteStore)
2. Provide: Wrap app with `ChangeNotifierProvider`
3. Consume: Use `Consumer` or `Provider.of()`
4. Notify: Call `notifyListeners()` on changes

### Navigation
1. `Navigator.push()` - Add route
2. `Navigator.pop()` - Remove route
3. `Navigator.pushReplacement()` - Replace route
4. Named routes - Setup in MaterialApp

---

## ⚠️ Common Mistakes

1. ❌ Forgetting `notifyListeners()` - Provider won't update
2. ❌ Modifying state without rebuilding - UI won't update
3. ❌ Using `Provider.of()` in build() - Performance issue
4. ❌ Not disposing controllers - Memory leak
5. ❌ Mixing sync/async - Race conditions

---

## 🎯 Next Integration Steps

1. Add backend API calls to Quote CRUD operations
2. Integrate Firebase for real-time updates
3. Add local persistence with Hive or SQLite
4. Implement email/SMS sending
5. Add push notifications
6. Setup user authentication
7. Add analytics tracking

---

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design 3](https://m3.material.io/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

---

**Last Updated**: April 5, 2026
**Flutter Version**: 3.x+
**Dart Version**: 3.x+
