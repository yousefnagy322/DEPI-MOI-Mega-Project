import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/user_reports_list/cubit.dart';
import 'package:migaproject/Logic/user_reports_list/state.dart';
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

  String getCategoryImage(String category) {
    if (category == "traffic") {
      return 'assets/images/Traffic.png';
    } else if (category == "crime") {
      return 'assets/images/Theft.png';
    } else if (category == "environmental") {
      return 'assets/images/enviroment.png';
    } else if (category == "Public_Nuisance") {
      return 'assets/images/Noise.png';
    } else if (category == "Utilities") {
      return 'assets/images/Utilities.png';
    } else if (category == "Infrastructure") {
      return 'assets/images/Missing.png';
    } else if (category == "Other") {
      return 'assets/images/Other.png';
    } else {
      return 'assets/images/Other.png';
    }
  }

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

                              if (reports.isEmpty) {
                                return const Center(
                                  child: Text('No reports available.'),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: reports.length,
                                  itemBuilder: (context, index) {
                                    final report = reports[index];
                                    return ReportCard(
                                      icon: getCategoryImage(report.categoryId),

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
                              }
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
