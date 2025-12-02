import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/user_reports/cubit.dart';
import 'package:migaproject/Logic/user_reports/state.dart';
import 'package:migaproject/presentation/screens/Report_Form/select_category_screen.dart';
import 'package:migaproject/presentation/widgets/nav_item.dart';
import 'package:migaproject/presentation/widgets/report_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  static String id = "ReportsScreen";

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int selectedIndex = 0; // Reports tab selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: selectedIndex == 0
          ? SelectCategoryScreen()
          : BlocProvider(
              create: (context) => MyReportsCubit()..fetchMyReports(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Text(
                        'My Reports',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Track all your Submissions',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 24),

                      // Reports List
                      // Expanded(
                      //   child: ListView(
                      //     children: [
                      //       _ReportCard(
                      //         icon: Icons.directions_car,
                      //         iconColor: Colors.blue,
                      //         title: 'Traffic violation\nat intersection',
                      //         trackingId: 'MOI-2025-2216',
                      //         status: 'In Progress',
                      //         statusColor: Colors.blue,
                      //       ),
                      //       const SizedBox(height: 12),
                      //       _ReportCard(
                      //         icon: Icons.warning_amber_rounded,
                      //         iconColor: Colors.blue,
                      //         title: 'Stolen Vehicle report',
                      //         trackingId: 'MOI-2025-2216',
                      //         status: 'Under Review',
                      //         statusColor: Colors.orange,
                      //       ),
                      //       const SizedBox(height: 12),
                      //       _ReportCard(
                      //         icon: Icons.directions_car,
                      //         iconColor: Colors.blue,
                      //         title: 'Traffic violation\nat intersection',
                      //         trackingId: 'MOI-2025-2216',
                      //         status: 'Resolved',
                      //         statusColor: Colors.green,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Expanded(
                        child: BlocBuilder<MyReportsCubit, MyReportsState>(
                          builder: (context, state) {
                            if (state is MyReportsLoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff1A73E8),
                                ),
                              );
                            } else if (state is MyReportsSuccessState) {
                              final reports = state.reports;
                              return ListView.builder(
                                itemCount: reports.length,
                                itemBuilder: (context, index) {
                                  final report = reports[index];
                                  return ReportCard(
                                    icon: Icons.report,
                                    iconColor: Colors.blue,
                                    title: report.title,
                                    trackingId: report.reportId!,
                                    status: report.status!,
                                    statusColor: report.status == 'Resolved'
                                        ? Colors.green
                                        : report.status == 'Under Review'
                                        ? Colors.orange
                                        : Colors.blue,
                                  );
                                },
                              );
                            } else if (state is MyReportsErrorState) {
                              return Center(
                                child: Text('Error: ${state.error}'),
                              );
                            }
                            return const Center(
                              child: Text('No reports available.'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => setState(() => selectedIndex = 0),
              ),
              NavItem(
                icon: Icons.description_outlined,
                label: 'Reports',
                isSelected: selectedIndex == 1,
                onTap: () => setState(() => selectedIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bottom Navigation Item
