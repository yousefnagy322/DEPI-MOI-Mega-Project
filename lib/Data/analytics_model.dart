class AnalyticsResponse {
  final Map<String, CategoryStats> matrix;

  AnalyticsResponse({required this.matrix});

  factory AnalyticsResponse.fromJson(Map<String, dynamic> json) {
    final matrixJson = json['matrix'] as Map<String, dynamic>;

    return AnalyticsResponse(
      matrix: matrixJson.map(
        (key, value) => MapEntry(key, CategoryStats.fromJson(value)),
      ),
    );
  }

  /// Total reports across all categories
  int get totalReports {
    return matrix.values.fold(0, (sum, item) => sum + item.total);
  }

  /// Status totals across all categories
  int get totalSubmitted =>
      matrix.values.fold(0, (sum, item) => sum + item.submitted);

  int get totalAssigned =>
      matrix.values.fold(0, (sum, item) => sum + item.assigned);

  int get totalInprogress =>
      matrix.values.fold(0, (sum, item) => sum + item.inprogress);

  int get totalResolved =>
      matrix.values.fold(0, (sum, item) => sum + item.resolved);

  int get totalRejected =>
      matrix.values.fold(0, (sum, item) => sum + item.rejected);
}

class CategoryStats {
  final int submitted;
  final int assigned;
  final int inprogress;
  final int resolved;
  final int rejected;

  CategoryStats({
    required this.submitted,
    required this.assigned,
    required this.inprogress,
    required this.resolved,
    required this.rejected,
  });

  factory CategoryStats.fromJson(Map<String, dynamic> json) {
    return CategoryStats(
      submitted: json['Submitted'] ?? 0,
      assigned: json['Assigned'] ?? 0,
      inprogress: json['InProgress'] ?? 0,
      resolved: json['Resolved'] ?? 0,
      rejected: json['Rejected'] ?? 0,
    );
  }

  int get total => submitted + assigned + inprogress + resolved + rejected;
}
