import 'package:flutter/material.dart';
import 'package:migaproject/presentation/admin/dashboard_page.dart';
import 'package:migaproject/presentation/admin/widgets/layout/admin_sidebar.dart';
import 'package:migaproject/presentation/admin/widgets/layout/admin_header.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // Change pages with setState (not routing)
  Widget currentPage = const DashboardPage();
  String currentPageName = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // LEFT SIDEBAR
          AdminSidebar(
            currentPageName: currentPageName,
            onPageChanged: (pageName, page) {
              setState(() {
                currentPage = page;
                currentPageName = pageName;
              });
            },
          ),

          // RIGHT CONTENT AREA
          Expanded(
            child: Container(
              color: const Color(0xFFF5F6FA),
              child: Column(
                children: [
                  // TOP HEADER BAR
                  AdminHeader(currentPageName: currentPageName),

                  // MAIN CONTENT
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: currentPage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
