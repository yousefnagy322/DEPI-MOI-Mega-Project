import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:migaproject/Data/analyricline_model.dart';

class AnalyticsLineChart extends StatefulWidget {
  final List<AnalyticsItem> items;

  const AnalyticsLineChart({super.key, required this.items});

  @override
  State<AnalyticsLineChart> createState() => _AnalyticsLineChartState();
}

class _AnalyticsLineChartState extends State<AnalyticsLineChart> {
  late final Map<String, List<AnalyticsItem>> _grouped;
  late final List<Map<String, int>> _months;
  late final List<Map<String, int>>
  _extendedMonths; // Includes months before first data
  late final List<String> _categories;
  late Set<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _grouped = _groupByCategory(widget.items);
    _months = _getSortedMonths(widget.items);
    _extendedMonths = _getExtendedMonths(_months);
    _categories = _grouped.keys.toList()..sort();
    _selectedCategories = _categories.toSet(); // all selected by default
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(child: Text('No analytics data yet'));
    }

    final hasSelection = _selectedCategories.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TextButton.icon(
                  onPressed: _selectedCategories.length == _categories.length
                      ? null
                      : _selectAll,
                  icon: const Icon(Icons.done_all, size: 18),
                  label: const Text('Select all'),
                ),
                TextButton.icon(
                  onPressed: _selectedCategories.isEmpty ? null : _clearAll,
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text('Clear'),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                final color =
                    Colors.primaries[_categories.indexOf(category) %
                        Colors.primaries.length];
                final selected = _selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category),
                  selected: selected,
                  avatar: CircleAvatar(backgroundColor: color, radius: 6),
                  onSelected: (_) {
                    _toggleCategory(category, selected);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            if (!hasSelection)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Select at least one category to see the chart.'),
              ),
            // Use Expanded to take remaining space with smaller aspect ratio
            Expanded(
              child: LayoutBuilder(
                builder: (context, chartConstraints) {
                  final chartWidth = chartConstraints.maxWidth > 0
                      ? chartConstraints.maxWidth
                      : constraints.maxWidth > 0
                      ? constraints.maxWidth
                      : 400.0;
                  // Smaller height: aspect ratio 4.0 (makes chart much shorter)
                  final chartHeight = chartConstraints.maxHeight > 0
                      ? chartConstraints.maxHeight
                      : chartWidth / 4.0;

                  return SizedBox(
                    height: chartHeight,
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio:
                          4.0, // Increased from 2.5 to 4.0 (wider/shorter)
                      child: LineChart(
                        LineChartData(
                          minX:
                              0, // Start from extended months (includes padding months)
                          maxX: _extendedMonths.length > 0
                              ? (_extendedMonths.length - 1).toDouble()
                              : 0,
                          minY: 0,
                          maxY:
                              _calculateMaxY(), // Static max Y with padding above
                          lineBarsData: _grouped.entries
                              .where(
                                (entry) =>
                                    _selectedCategories.contains(entry.key),
                              )
                              .map((entry) {
                                final category = entry.key;
                                final data = entry.value;

                                final spots = data.map((item) {
                                  // X axis: month index in extended months list
                                  final x = _extendedMonths.indexWhere(
                                    (m) =>
                                        m['year'] == item.year &&
                                        m['month'] == item.month,
                                  );
                                  return FlSpot(
                                    x.toDouble(),
                                    item.count.toDouble(),
                                  );
                                }).toList()..sort((a, b) => a.x.compareTo(b.x));

                                final color =
                                    Colors.primaries[_categories.indexOf(
                                          category,
                                        ) %
                                        Colors.primaries.length];

                                return LineChartBarData(
                                  spots: spots,
                                  isCurved: true,
                                  barWidth: 3,
                                  color: color,
                                  dotData: const FlDotData(show: true),
                                );
                              })
                              .toList(),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) {
                                // Get selected categories in the same order as lineBarsData
                                final selectedCategoriesList = _grouped.entries
                                    .where(
                                      (entry) => _selectedCategories.contains(
                                        entry.key,
                                      ),
                                    )
                                    .map((entry) => entry.key)
                                    .toList();

                                return touchedSpots.map((spot) {
                                  final index = spot.x.toInt();
                                  if (index >= 0 &&
                                      index < _extendedMonths.length &&
                                      spot.barIndex >= 0 &&
                                      spot.barIndex <
                                          selectedCategoriesList.length) {
                                    final month = _extendedMonths[index];
                                    final category =
                                        selectedCategoriesList[spot.barIndex];
                                    return LineTooltipItem(
                                      '$category\n${month['month']}/${month['year']}\nReports: ${spot.y.toInt()}',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  }
                                  return const LineTooltipItem('', TextStyle());
                                }).toList();
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                reservedSize: 60,
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 ||
                                      index >= _extendedMonths.length) {
                                    return const SizedBox();
                                  }
                                  final m = _extendedMonths[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '${m['month']}/${m['year']}',
                                      style: const TextStyle(fontSize: 11),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                reservedSize: 60,
                                showTitles: true,
                                interval:
                                    _calculateYInterval(), // Dynamic interval based on maxY
                                getTitlesWidget: (value, meta) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(fontSize: 11),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: const FlGridData(show: true),
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _toggleCategory(String category, bool currentlySelected) {
    setState(() {
      if (currentlySelected) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedCategories = _categories.toSet();
    });
  }

  void _clearAll() {
    setState(() {
      _selectedCategories.clear();
    });
  }

  /// Group analytics items by category
  Map<String, List<AnalyticsItem>> _groupByCategory(List<AnalyticsItem> items) {
    final Map<String, List<AnalyticsItem>> grouped = {};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    return grouped;
  }

  /// Get a sorted list of unique months from items
  List<Map<String, int>> _getSortedMonths(List<AnalyticsItem> items) {
    final monthSet = <String, Map<String, int>>{};
    for (final item in items) {
      final key = '${item.year}-${item.month}';
      monthSet[key] = {'year': item.year, 'month': item.month};
    }
    final months = monthSet.values.toList();
    months.sort((a, b) {
      if (a['year']! != b['year']!) return a['year']!.compareTo(b['year']!);
      return a['month']!.compareTo(b['month']!);
    });
    return months;
  }

  /// Get extended months list with 1 month before the first data point and 1 month after the last
  List<Map<String, int>> _getExtendedMonths(List<Map<String, int>> months) {
    if (months.isEmpty) return [];

    final extended = <Map<String, int>>[];
    final firstMonth = months.first;
    int startYear = firstMonth['year']!;
    int startMonth = firstMonth['month']!;

    // Add 1 month before the first data point
    for (int i = 1; i > 0; i--) {
      int month = startMonth - i;
      int year = startYear;

      // Handle year rollover
      while (month <= 0) {
        month += 12;
        year -= 1;
      }

      extended.add({'year': year, 'month': month});
    }

    // Add all original months
    extended.addAll(months);

    // Add 1 month after the last data point
    final lastMonth = months.last;
    int endYear = lastMonth['year']!;
    int endMonth = lastMonth['month']!;

    int nextMonth = endMonth + 1;
    int nextYear = endYear;

    // Handle year rollover
    while (nextMonth > 12) {
      nextMonth -= 12;
      nextYear += 1;
    }

    extended.add({'year': nextYear, 'month': nextMonth});

    return extended;
  }

  /// Calculate maximum Y value from all data (static axis) with padding above
  double _calculateMaxY() {
    if (widget.items.isEmpty) return 10.0;

    // Find the maximum count across all items
    final maxCount = widget.items
        .map((item) => item.count)
        .reduce((a, b) => a > b ? a : b);

    // Add 15% padding above and round up to nearest 5 or 10
    final paddedMax = maxCount * 1.15;
    if (paddedMax <= 10) {
      return 10.0;
    } else if (paddedMax <= 50) {
      return (paddedMax / 5).ceil() * 5.0;
    } else {
      return (paddedMax / 10).ceil() * 10.0;
    }
  }

  /// Calculate Y-axis interval based on maxY (for better label spacing)
  double _calculateYInterval() {
    final maxY = _calculateMaxY();
    if (maxY <= 10) {
      return 2.0;
    } else if (maxY <= 50) {
      return 5.0;
    } else if (maxY <= 100) {
      return 10.0;
    } else {
      return (maxY / 10).ceil().toDouble();
    }
  }
}
