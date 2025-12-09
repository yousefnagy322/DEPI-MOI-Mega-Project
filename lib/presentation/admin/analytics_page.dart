import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:migaproject/Logic/analytic_line_chart/cubit.dart';
import 'package:migaproject/Logic/analytic_line_chart/state.dart';
import 'package:migaproject/Logic/analytics/cubit.dart';
import 'package:migaproject/Logic/analytics/state.dart';
import 'package:migaproject/Data/analytics_model.dart';
import 'package:migaproject/presentation/admin/test%20widgets/linechart.dart';
import 'package:migaproject/presentation/admin/widgets/cards/metric_card.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AnalyticsErrorState) {
          return Center(
            child: Text(
              "Error: ${state.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is! AnalyticsSuccessState) {
          return const SizedBox.shrink();
        }

        final data = state.data;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 1200;
            final isMobile = constraints.maxWidth < 768;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION 1: SUMMARY CARDS
                  _buildSummaryCards(data, isSmallScreen, isMobile),
                  const SizedBox(height: 30),

                  // SECTION 2: PIE CHART (STATUS DISTRIBUTION)
                  RepaintBoundary(
                    child: _StatusDistributionChart(
                      data: data,
                      isMobile: isMobile,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // SECTION 3: BAR CHART (CATEGORIES)
                  RepaintBoundary(
                    child: _CategoryBarChart(data: data, isMobile: isMobile),
                  ),

                  const SizedBox(height: 30),

                  RepaintBoundary(
                    child: _CategoryTrendsChart(isMobile: isMobile),
                  ),

                  const SizedBox(height: 30),

                  // SECTION 4: CATEGORY DETAILS TABLE
                  _CategoryDetailsTable(data: data),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCards(
    AnalyticsResponse data,
    bool isSmallScreen,
    bool isMobile,
  ) {
    if (isMobile) {
      // Mobile: 2 columns
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: "Total Reports",
                  value: data.totalReports.toString(),
                  subtitle: "",
                  icon: Icons.report_problem,
                  iconColor: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "Submitted",
                  value: data.totalSubmitted.toString(),
                  subtitle: "",
                  icon: Icons.send,
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
                  title: "Assigned",
                  value: data.totalAssigned.toString(),
                  subtitle: "",
                  icon: Icons.assignment,
                  iconColor: Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "In Progress",
                  value: data.totalInprogress.toString(),
                  subtitle: "",
                  icon: Icons.more_horiz,
                  iconColor: Colors.amber,
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
                  value: data.totalResolved.toString(),
                  subtitle: "",
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "Rejected",
                  value: data.totalRejected.toString(),
                  subtitle: "",
                  icon: Icons.cancel,
                  iconColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (isSmallScreen) {
      // Tablet: 3 columns
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: "Total Reports",
                  value: data.totalReports.toString(),
                  subtitle: "",
                  icon: Icons.report_problem,
                  iconColor: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "Submitted",
                  value: data.totalSubmitted.toString(),
                  subtitle: "",
                  icon: Icons.send,
                  iconColor: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "Assigned",
                  value: data.totalAssigned.toString(),
                  subtitle: "",
                  icon: Icons.assignment,
                  iconColor: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: "In Progress",
                  value: data.totalInprogress.toString(),
                  subtitle: "",
                  icon: Icons.more_horiz,
                  iconColor: Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "Resolved",
                  value: data.totalResolved.toString(),
                  subtitle: "",
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: "Rejected",
                  value: data.totalRejected.toString(),
                  subtitle: "",
                  icon: Icons.cancel,
                  iconColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      );
    }
    // Desktop: 6 columns in one row
    return Row(
      children: [
        Expanded(
          child: MetricCard(
            title: "Total Reports",
            value: data.totalReports.toString(),
            subtitle: "",
            icon: Icons.report_problem,
            iconColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "Submitted",
            value: data.totalSubmitted.toString(),
            subtitle: "",
            icon: Icons.send,
            iconColor: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "Assigned",
            value: data.totalAssigned.toString(),
            subtitle: "",
            icon: Icons.assignment,
            iconColor: Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "In Progress",
            value: data.totalInprogress.toString(),
            subtitle: "",
            icon: Icons.more_horiz,
            iconColor: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "Resolved",
            value: data.totalResolved.toString(),
            subtitle: "",
            icon: Icons.check_circle,
            iconColor: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MetricCard(
            title: "Rejected",
            value: data.totalRejected.toString(),
            subtitle: "",
            icon: Icons.cancel,
            iconColor: Colors.red,
          ),
        ),
      ],
    );
  }
}

// Extracted widgets for better performance

class _StatusDistributionChart extends StatelessWidget {
  final AnalyticsResponse data;
  final bool isMobile;

  const _StatusDistributionChart({required this.data, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Status Distribution",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1),
          Container(
            height: isMobile ? 300 : 400,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: _PieChartContent(data: data, isMobile: isMobile),
          ),
        ],
      ),
    );
  }
}

class _PieChartContent extends StatelessWidget {
  final AnalyticsResponse data;
  final bool isMobile;

  const _PieChartContent({required this.data, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final total = data.totalReports;
    if (total == 0) {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final submitted = data.totalSubmitted;
    final assigned = data.totalAssigned;
    final inProgress = data.totalInprogress;
    final resolved = data.totalResolved;
    final rejected = data.totalRejected;

    // Memoize percentage calculations
    final submittedPercent = ((submitted / total) * 100).toStringAsFixed(1);
    final assignedPercent = ((assigned / total) * 100).toStringAsFixed(1);
    final inProgressPercent = ((inProgress / total) * 100).toStringAsFixed(1);
    final resolvedPercent = ((resolved / total) * 100).toStringAsFixed(1);
    final rejectedPercent = ((rejected / total) * 100).toStringAsFixed(1);

    final pieChartSections = [
      PieChartSectionData(
        value: submitted.toDouble(),
        title: '$submittedPercent%',
        color: Colors.orange,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: assigned.toDouble(),
        title: '$assignedPercent%',
        color: Colors.purple,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: inProgress.toDouble(),
        title: '$inProgressPercent%',
        color: Colors.amber,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: resolved.toDouble(),
        title: '$resolvedPercent%',
        color: Colors.green,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: rejected.toDouble(),
        title: '$rejectedPercent%',
        color: Colors.red,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: pieChartSections,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _LegendItem("Submitted", Colors.orange, submitted),
              _LegendItem("Assigned", Colors.purple, assigned),
              _LegendItem("In Progress", Colors.amber, inProgress),
              _LegendItem("Resolved", Colors.green, resolved),
              _LegendItem("Rejected", Colors.red, rejected),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sections: pieChartSections,
              sectionsSpace: 2,
              centerSpaceRadius: 60,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendItem("Submitted", Colors.orange, submitted),
              const SizedBox(height: 12),
              _LegendItem("Assigned", Colors.purple, assigned),
              const SizedBox(height: 12),
              _LegendItem("In Progress", Colors.amber, inProgress),
              const SizedBox(height: 12),
              _LegendItem("Resolved", Colors.green, resolved),
              const SizedBox(height: 12),
              _LegendItem("Rejected", Colors.red, rejected),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final int value;

  const _LegendItem(this.label, this.color, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(width: 8),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

class _CategoryBarChart extends StatelessWidget {
  final AnalyticsResponse data;
  final bool isMobile;

  const _CategoryBarChart({required this.data, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Reports per Category",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1),
          Container(
            height: isMobile ? 300 : 400,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: _BarChartContent(data: data, isMobile: isMobile),
          ),
        ],
      ),
    );
  }
}

class _BarChartContent extends StatelessWidget {
  final AnalyticsResponse data;
  final bool isMobile;

  const _BarChartContent({required this.data, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    if (data.matrix.isEmpty) {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Memoize categories list and maxTotal calculation
    final categories = data.matrix.keys.toList();
    final maxTotal = data.matrix.values
        .map((stats) => stats.total)
        .reduce((a, b) => a > b ? a : b);

    // Pre-calculate bar groups
    final barGroups = categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final stats = data.matrix[category]!;
      final total = stats.total;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total.toDouble(),
            color: _getCategoryColor(index),
            width: isMobile ? 20 : 30,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxTotal > 0 ? maxTotal.toDouble() + (maxTotal * 0.1) : 10,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.grey[800]!,
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < categories.length) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      isMobile
                          ? (category.length > 8
                                ? '${category.substring(0, 8)}...'
                                : category)
                          : (category.length > 10
                                ? '${category.substring(0, 10)}...'
                                : category),
                      style: TextStyle(
                        fontSize: isMobile ? 9 : 11,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: isMobile ? 40 : 50,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: isMobile ? 35 : 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 11,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            left: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxTotal > 0
              ? (maxTotal / 5).ceil().toDouble()
              : 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[200]!, strokeWidth: 1);
          },
        ),
        barGroups: barGroups,
      ),
    );
  }

  Color _getCategoryColor(int index) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }
}

class _CategoryTrendsChart extends StatelessWidget {
  final bool isMobile;

  const _CategoryTrendsChart({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Category Trends Chart",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1),
          Container(
            constraints: BoxConstraints(
              minHeight: isMobile ? 300 : 400,
              maxHeight: isMobile ? 600 : 800,
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<AnalyticsLineCubit, AnalyticsLineState>(
              builder: (context, state) {
                if (state is AnalyticsLineLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AnalyticsLineLoaded) {
                  return AnalyticsLineChart(items: state.items);
                } else if (state is AnalyticsLineError) {
                  return Center(child: Text("Error: ${state.message}"));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDetailsTable extends StatelessWidget {
  final AnalyticsResponse data;

  const _CategoryDetailsTable({required this.data});

  @override
  Widget build(BuildContext context) {
    // Pre-compute table rows for better performance
    final tableRows = data.matrix.entries.map((entry) {
      final name = entry.key;
      final stats = entry.value;
      return DataRow(
        key: ValueKey(name), // Add key for better performance
        cells: [
          DataCell(
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          DataCell(
            Text(
              "${stats.submitted}",
              style: TextStyle(color: Colors.grey[800], fontSize: 13),
            ),
          ),
          DataCell(
            Text(
              "${stats.assigned}",
              style: TextStyle(color: Colors.grey[800], fontSize: 13),
            ),
          ),
          DataCell(
            Text(
              "${stats.inprogress}",
              style: TextStyle(color: Colors.grey[800], fontSize: 13),
            ),
          ),
          DataCell(
            Text(
              "${stats.resolved}",
              style: TextStyle(color: Colors.grey[800], fontSize: 13),
            ),
          ),
          DataCell(
            Text(
              "${stats.rejected}",
              style: TextStyle(color: Colors.grey[800], fontSize: 13),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                "${stats.total}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();

    return Container(
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
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Category Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1),
          LayoutBuilder(
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
                    headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                    columns: [
                      DataColumn(
                        label: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            "CATEGORY",
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
                          "SUBMITTED",
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
                          "ASSIGNED",
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
                          "IN PROGRESS",
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
                          "RESOLVED",
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
                          "REJECTED",
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
                            "TOTAL",
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
                    rows: tableRows,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
