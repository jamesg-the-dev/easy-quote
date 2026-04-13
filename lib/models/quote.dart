class LineItem {
  final String id;
  final String description;
  final double price;

  LineItem({required this.id, required this.description, required this.price});
}

class Quote {
  String id;
  String clientName;
  String jobDescription;
  List<LineItem> lineItems;
  double total;
  String status; // Sent, Viewed, Accepted, Rejected
  String createdAt;
  String? viewedAt;
  String? respondedAt;

  Quote({
    required this.id,
    required this.clientName,
    required this.jobDescription,
    required this.lineItems,
    required this.total,
    required this.status,
    required this.createdAt,
    this.viewedAt,
    this.respondedAt,
  });
}
