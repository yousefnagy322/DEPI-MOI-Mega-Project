import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Data/count_model.dart';
import 'package:migaproject/Logic/officer_reports_list/state.dart';
import 'package:migaproject/Data/report_model.dart';
import 'package:migaproject/Logic/officer_reports_list/cubit.dart';
import 'package:migaproject/presentation/admin/widgets/cards/metric_card.dart';
import 'package:migaproject/presentation/admin/widgets/badges/status_badge.dart';
import 'package:migaproject/presentation/admin/utils/date_formatter.dart';
import 'report_details_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfficerReportsCubit, OfficerReportsState>(
      builder: (context, state) {
        if (state is OfficerReportsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OfficerReportsErrorState) {
          return Center(child: Text(state.error));
        }

        final usercount = state is OfficerReportsSuccessState
            ? state.usercount
            : null;

        final counts = state is OfficerReportsSuccessState
            ? state.counts
            : null;
        final reports = state is OfficerReportsSuccessState
            ? state.reports
            : <Report>[];

        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 1200;
            final isMobile = constraints.maxWidth < 768;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top metrics cards - Responsive, now from API counts
                  _buildResponsiveCards(
                    counts,
                    usercount!,
                    isSmallScreen,
                    isMobile,
                  ),
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
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        _reportsTable(context, isSmallScreen, reports),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildResponsiveCards(
    Counts? counts,
    int usercount,
    bool isSmallScreen,
    bool isMobile,
  ) {
    final submitted = counts?.submitted.toString() ?? '--';
    final inProgress = counts?.inProgress.toString() ?? '--';
    final resolved = counts?.resolved.toString() ?? '--';

    if (isMobile) {
      // Mobile: 2 columns
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: "Submitted",
                  value: submitted,
                  subtitle: "",
                  icon: Icons.report_problem,
                  iconColor: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "In Progress",
                  value: inProgress,
                  subtitle: "",
                  icon: Icons.more_horiz,
                  iconColor: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: "Resolved",
                  value: resolved,
                  subtitle: "",
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "Total Users",
                  value: usercount.toString(),
                  subtitle: "",
                  icon: Icons.people,
                  iconColor: Colors.lightBlue,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (isSmallScreen) {
      // Tablet: 2 rows of 2 cards
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: "Submitted",
                  value: submitted,
                  subtitle: "",
                  icon: Icons.report_problem,
                  iconColor: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "In Progress",
                  value: inProgress,
                  subtitle: "",
                  icon: Icons.more_horiz,
                  iconColor: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: "Resolved",
                  value: resolved,
                  subtitle: "",
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "Total Users",
                  value: usercount.toString(),
                  subtitle: "",
                  icon: Icons.people,
                  iconColor: Colors.lightBlue,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Desktop: 4 cards in one row
    return Row(
      children: [
        Expanded(
          child: MetricCard(
            title: "Submitted",
            value: submitted,
            subtitle: "",
            icon: Icons.report_problem,
            iconColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "In Progress",
            value: inProgress,
            subtitle: "",
            icon: Icons.more_horiz,
            iconColor: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "Resolved",
            value: resolved,
            subtitle: "",
            icon: Icons.check_circle,
            iconColor: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "Total Users",
            value: usercount.toString(),
            subtitle: "",
            icon: Icons.people,
            iconColor: Colors.lightBlue,
          ),
        ),
      ],
    );
  }

  // Recent Reports Table
  Widget _reportsTable(
    BuildContext context,
    bool isSmallScreen,
    List<Report> reports,
  ) {
    // Limit to only the first 4 reports for the dashboard view
    final limitedReports = reports.length > 4 ? reports.sublist(0, 4) : reports;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: isSmallScreen
          ? _buildMobileTable(context, limitedReports)
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
                      rows: limitedReports.map((report) {
                        // adapt to your Report model fields
                        final createdAt = report.createdAt;
                        final date = createdAt != null
                            ? DateTime.tryParse(createdAt) ?? DateTime.now()
                            : DateTime.now(); // fallback
                        return DataRow(
                          cells: [
                            DataCell(
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  report.reportId ?? '—',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                report.categoryId,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                report.userId ?? '—',
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
                            DataCell(StatusBadge(status: report.status ?? '')),
                            DataCell(
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ReportDetailsPage(report: report),
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

  Widget _buildMobileTable(BuildContext context, List<Report> reports) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reports.length > 4 ? 4 : reports.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final report = reports[index];
        final createdAt = report.createdAt;
        final date = createdAt != null
            ? DateTime.tryParse(createdAt) ?? DateTime.now()
            : DateTime.now();
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReportDetailsPage(report: report),
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
                        report.reportId ?? '—',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.categoryId,
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
                            report.userId ?? '—',
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
                    StatusBadge(status: report.status ?? ''),
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
