class ReportCountsResponse {
  final Counts counts;

  ReportCountsResponse({required this.counts});

  factory ReportCountsResponse.fromJson(Map<String, dynamic> json) {
    return ReportCountsResponse(counts: Counts.fromJson(json['counts']));
  }

  Map<String, dynamic> toJson() {
    return {'counts': counts.toJson()};
  }
}

class Counts {
  final int submitted;
  final int assigned;
  final int inProgress;
  final int resolved;
  final int rejected;

  Counts({
    required this.submitted,
    required this.assigned,
    required this.inProgress,
    required this.resolved,
    required this.rejected,
  });

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
      submitted: json['Submitted'] ?? 0,
      assigned: json['Assigned'] ?? 0,
      inProgress: json['InProgress'] ?? 0,
      resolved: json['Resolved'] ?? 0,
      rejected: json['Rejected'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Submitted': submitted,
      'Assigned': assigned,
      'Inprogress': inProgress,
      'Resolved': resolved,
      'Rejected': rejected,
    };
  }
}
