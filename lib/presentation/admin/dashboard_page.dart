import 'package:flutter/material.dart';
import 'package:migaproject/presentation/admin/widgets/cards/metric_card.dart';
import 'package:migaproject/presentation/admin/widgets/badges/status_badge.dart';
import 'package:migaproject/presentation/admin/utils/date_formatter.dart';
import 'report_details_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 1200;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top metrics cards - Responsive
              _buildResponsiveCards(),
              const SizedBox(height: 30),

              // Recent Reports Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Recent Reports",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              // Navigate to Reports page via menu
                              // User can click Reports in sidebar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Click 'Reports' in the sidebar to view all reports",
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.blue,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward, size: 16),
                            label: const Text(
                              "View all",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    _reportsTable(context, isSmallScreen),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResponsiveCards() {
    return Row(
      children: [
        Expanded(
          child: MetricCard(
            title: "Submitted",
            value: "25",
            subtitle: "↑ +10 today",
            icon: Icons.report_problem,
            iconColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "In Progress",
            value: "12",
            subtitle: "Awaiting action",
            icon: Icons.more_horiz,
            iconColor: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "Resolved",
            value: "153",
            subtitle: "↑ +5% this week",
            icon: Icons.check_circle,
            iconColor: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "Total Users",
            value: "2,453",
            subtitle: "↑ +50 new",
            icon: Icons.people,
            iconColor: Colors.lightBlue,
          ),
        ),
      ],
    );
  }

  // Recent Reports Table
  Widget _reportsTable(BuildContext context, bool isSmallScreen) {
    final reports = [
      {
        "id": "MOI-2025-2216",
        "category": "Traffic Violation",
        "user": "user@example.com",
        "date": DateTime(2024, 7, 28),
        "status": "In Progress",
      },
      {
        "id": "MOI-2025-2215",
        "category": "Stolen Vehicle",
        "user": "guest_user",
        "date": DateTime(2024, 7, 27),
        "status": "Under Review",
      },
      {
        "id": "MOI-2025-2214",
        "category": "Noise Complaint",
        "user": "anonymous",
        "date": DateTime(2024, 7, 26),
        "status": "Resolved",
      },
      {
        "id": "MOI-2025-2213",
        "category": "Theft",
        "user": "user@example.com",
        "date": DateTime(2024, 7, 25),
        "status": "New",
      },
      {
        "id": "MOI-2025-2212",
        "category": "Other",
        "user": "guest_user",
        "date": DateTime(2024, 7, 24),
        "status": "In Progress",
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: isSmallScreen
          ? _buildMobileTable(context, reports)
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth > 0
                          ? constraints.maxWidth
                          : 800,
                    ),
                    child: DataTable(
                      columnSpacing: 24,
                      headingRowHeight: 48,
                      dataRowMinHeight: 64,
                      dataRowMaxHeight: 72,
                      headingRowColor: MaterialStateProperty.all(
                        Colors.grey[50],
                      ),
                      columns: [
                        DataColumn(
                          label: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              "REPORT ID",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.grey[700],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "CATEGORY",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey[700],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "USER",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey[700],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "DATE",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey[700],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "STATUS",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey[700],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Text(
                              "ACTION",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.grey[700],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: reports.map((report) {
                        final date = report["date"] as DateTime;
                        return DataRow(
                          cells: [
                            DataCell(
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  report["id"] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                report["category"] as String,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                report["user"] as String,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                DateFormatter.formatRelativeDate(date),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            DataCell(
                              StatusBadge(status: report["status"] as String),
                            ),
                            DataCell(
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ReportDetailsPage(
                                          reportId: int.parse(
                                            (report["id"] as String)
                                                .split("-")
                                                .last,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    "Details",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMobileTable(
    BuildContext context,
    List<Map<String, dynamic>> reports,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reports.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final report = reports[index];
        final date = report["date"] as DateTime;
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReportDetailsPage(
                  reportId: int.parse((report["id"] as String).split("-").last),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report["id"] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report["category"] as String,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            report["user"] as String,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.formatRelativeDate(date),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    StatusBadge(status: report["status"] as String),
                    const SizedBox(height: 8),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
