import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/officer_reports_list/cubit.dart';
import 'package:migaproject/Logic/officer_reports_list/state.dart';
import 'package:migaproject/presentation/admin/widgets/badges/status_badge.dart';
import 'package:migaproject/presentation/admin/widgets/users/pagination_widget.dart';
import 'package:migaproject/presentation/admin/utils/date_formatter.dart';
import 'report_details_page.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String search = '';
  String? selectedStatus;
  int currentPage = 1;
  final int itemsPerPage = 5;

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

        if (state is! OfficerReportsSuccessState) {
          return const SizedBox.shrink();
        }

        final reports = state.reports;
        final filteredReports = _applyFilters(reports);
        final paginationData = _calculatePagination(filteredReports);
        final paginatedReports =
            paginationData['paginatedReports'] as List<dynamic>;
        final totalItems = paginationData['totalItems'] as int;
        final totalPages = paginationData['totalPages'] as int;
        final startIndex = paginationData['startIndex'] as int;
        final endIndex = paginationData['endIndex'] as int;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 1200;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All Reports (${filteredReports.length})",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFiltersBar(isSmallScreen),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
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
                      children: [
                        Expanded(
                          child: isSmallScreen
                              ? _buildMobileList(context, paginatedReports)
                              : _buildTable(context, paginatedReports),
                        ),
                        SafeArea(
                          top: false,
                          child: PaginationWidget(
                            currentPage: currentPage,
                            totalPages: totalPages,
                            totalItems: totalItems,
                            startIndex: startIndex,
                            endIndex: endIndex,
                            onPageChanged: (page) =>
                                setState(() => currentPage = page),
                            itemLabelPlural: 'reports',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List _applyFilters(List reports) {
    final lowerSearch = search.toLowerCase();

    return reports.where((report) {
      final matchesSearch =
          search.isEmpty ||
          report.title.toLowerCase().contains(lowerSearch) ||
          (report.reportId ?? '').toLowerCase().contains(lowerSearch) ||
          report.categoryId.toLowerCase().contains(lowerSearch);

      final matchesStatus =
          selectedStatus == null ||
          (report.status ?? '').toLowerCase() == selectedStatus!.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Widget _buildFiltersBar(bool isSmallScreen) {
    final dropdown = Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          dropdownColor: Colors.white,
          value: selectedStatus,
          hint: const Text("Status"),
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          isExpanded: true,
          items: const [
            DropdownMenuItem<String?>(value: null, child: Text("All Statuses")),
            DropdownMenuItem<String?>(
              value: "Submitted",
              child: Text("Submitted"),
            ),
            DropdownMenuItem<String?>(
              value: "InProgress",
              child: Text("InProgress"),
            ),
            DropdownMenuItem<String?>(
              value: "Assigned",
              child: Text("Assigned"),
            ),
            DropdownMenuItem<String?>(
              value: "Resolved",
              child: Text("Resolved"),
            ),
            DropdownMenuItem<String?>(
              value: "Rejected",
              child: Text("Rejected"),
            ),
          ],
          onChanged: (value) => setState(() {
            selectedStatus = value;
            currentPage = 1;
          }),
        ),
      ),
    );

    final searchBar = Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        onChanged: (value) => setState(() {
          search = value;
          currentPage = 1;
        }),
        decoration: const InputDecoration(
          hintText: "Search by title, ID, or category...",
          prefixIcon: Icon(Icons.search, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );

    if (isSmallScreen) {
      return Column(
        children: [searchBar, const SizedBox(height: 12), dropdown],
      );
    }

    return Row(
      children: [
        Expanded(child: searchBar),
        const SizedBox(width: 12),
        SizedBox(width: 200, child: dropdown),
      ],
    );
  }

  Map<String, dynamic> _calculatePagination(List filteredReports) {
    final totalItems = filteredReports.length;
    final totalPages = totalItems > 0 ? (totalItems / itemsPerPage).ceil() : 1;

    // Clamp current page when filters or data change
    final safeCurrentPage = currentPage.clamp(1, totalPages);
    if (safeCurrentPage != currentPage && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => currentPage = safeCurrentPage);
      });
    }

    final startIndex = totalItems > 0
        ? (safeCurrentPage - 1) * itemsPerPage
        : 0;
    final endIndex = (startIndex + itemsPerPage).clamp(0, totalItems);

    final paginatedReports = totalItems > 0
        ? filteredReports
              .skip(startIndex)
              .take(itemsPerPage)
              .toList(growable: false)
        : <dynamic>[];

    return {
      'paginatedReports': paginatedReports,
      'totalItems': totalItems,
      'totalPages': totalPages,
      'startIndex': startIndex,
      'endIndex': endIndex,
    };
  }

  Widget _buildTable(BuildContext context, List reports) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth > 0 ? constraints.maxWidth : 800,
            ),
            child: DataTable(
              columnSpacing: 24,
              headingRowHeight: 48,
              dataRowMinHeight: 64,
              dataRowMaxHeight: 72,
              headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
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
                    "TITLE",
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
                final createdAt = report.createdAt;
                final date = createdAt != null
                    ? DateTime.tryParse(createdAt) ?? DateTime.now()
                    : DateTime.now();
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
                      SizedBox(
                        width: 200,
                        child: Text(
                          report.title,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        report.categoryId,
                        style: TextStyle(color: Colors.grey[800], fontSize: 13),
                      ),
                    ),
                    DataCell(
                      Text(
                        report.userId ?? '—',
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ),
                    DataCell(
                      Text(
                        DateFormatter.formatRelativeDate(date),
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
    );
  }

  Widget _buildMobileList(BuildContext context, List reports) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: reports.length,
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
                        report.title,
                        style: TextStyle(color: Colors.grey[800], fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
