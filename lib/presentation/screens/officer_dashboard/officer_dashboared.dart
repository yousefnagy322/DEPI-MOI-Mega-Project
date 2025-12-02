import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:migaproject/Logic/officer_report_details/cubit.dart';
import 'package:migaproject/Logic/officer_reports/cubit.dart';
import 'package:migaproject/Logic/officer_reports/state.dart';
import 'package:migaproject/presentation/screens/officer_dashboard/officer_detail_screen.dart';

class OfficerDashboard extends StatelessWidget {
  const OfficerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    String formatDateTime(String isoString) {
      final date = DateTime.parse(isoString);
      return DateFormat('dd MMM • h:mm a').format(date);
    }

    return BlocProvider(
      create: (context) => OfficerReportsCubit()..fetchOfficerReports(),
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffF5F5F5),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Officer Dashboard',
                style: TextStyle(
                  color: Color(0xff424242),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Jurisdiction: District 1',
                style: TextStyle(color: Color(0xffBDBDBD), fontSize: 12),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xff424242),
              ),
              onPressed: () {},
            ),
            const CircleAvatar(
              backgroundColor: Color(0xff424242),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 16),
          ],
        ),

        body: BlocBuilder<OfficerReportsCubit, OfficerReportsState>(
          builder: (context, state) {
            if (state is OfficerReportsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OfficerReportsErrorState) {
              return Center(child: Text(state.error));
            } else if (state is OfficerReportsSuccessState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Stats Row
                    const Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'Submitted',
                            count: '12',
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'In Progress',
                            count: '5',
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'Resolved',
                            count: '28',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 2. Section Header
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Priority Reports",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.filter_list, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 3. Report List (Mock Data)
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.reports.length,
                        itemBuilder: (context, index) {
                          return ReportCard(
                            title: state.reports[index].title,
                            location: state.reports[index].location,
                            time: formatDateTime(
                              state.reports[index].createdAt!,
                            ),
                            category: state.reports[index].categoryId,
                            confidence: index == 0 ? 94 : 88,
                            status: state.reports[index].status!,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (_) => OfficerReportDetailsCubit(),
                                    child: ReportDetailScreen(
                                      mapUrl: state.reports[index].location,
                                      report: state.reports[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No reports found'));
            }
          },
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final String location;
  final String time;
  final String category;
  final int confidence;
  final String status;
  final VoidCallback onTap;

  const ReportCard({
    super.key,
    required this.title,
    required this.location,
    required this.time,
    required this.category,
    required this.confidence,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Box
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.directions_car, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),

                    if (location.startsWith('https://')) ...[
                      Text(
                        'Google maps link',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ] else
                      Text(
                        location,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildTag(
                          category,
                          Colors.grey.shade200,
                          Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        _buildTag(
                          "AI: $confidence%",
                          Colors.green.shade50,
                          Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Time
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Icon(Icons.chevron_right, color: Colors.grey[300]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
