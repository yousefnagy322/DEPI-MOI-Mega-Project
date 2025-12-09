class AnalyticsItem {
  final int year;
  final int month;
  final String category;
  final int count;

  AnalyticsItem({
    required this.year,
    required this.month,
    required this.category,
    required this.count,
  });

  factory AnalyticsItem.fromJson(Map<String, dynamic> json) {
    return AnalyticsItem(
      year: json['year'],
      month: json['month'],
      category: json['category'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'year': year, 'month': month, 'category': category, 'count': count};
  }
}
