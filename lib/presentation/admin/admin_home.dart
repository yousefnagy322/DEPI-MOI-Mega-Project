import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/analytic_line_chart/cubit.dart';
import 'package:migaproject/Logic/login/cubit.dart';
import 'package:migaproject/Logic/login/state.dart';
import 'package:migaproject/Logic/officer_reports_list/cubit.dart';
import 'package:migaproject/Logic/user_data_list/cubit.dart';
import 'package:migaproject/Logic/analytics/cubit.dart';
import 'package:migaproject/presentation/admin/dashboard_page.dart';
import 'package:migaproject/presentation/admin/reports_page.dart';
import 'package:migaproject/presentation/admin/users_page.dart';
import 'package:migaproject/presentation/admin/analytics_page.dart';
import 'package:migaproject/presentation/admin/widgets/layout/admin_sidebar.dart';
import 'package:migaproject/presentation/admin/widgets/layout/admin_header.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // Use enum for better type safety and performance
  int _currentPageIndex = 0;
  static const String _dashboardPageName = "Dashboard";
  static const String _reportsPageName = "Reports";
  static const String _usersPageName = "User Management";
  static const String _analyticsPageName = "Analytics";

  // Pre-build all pages once to avoid recreation
  late final List<Widget> _pages = const [
    DashboardPage(),
    ReportsPage(),
    UsersPage(),
    AnalyticsPage(),
  ];

  late final List<String> _pageNames = const [
    _dashboardPageName,
    _reportsPageName,
    _usersPageName,
    _analyticsPageName,
  ];

  String get currentPageName => _pageNames[_currentPageIndex];

  void _onPageChanged(int index) {
    if (_currentPageIndex != index) {
      setState(() {
        _currentPageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide OfficerReportsCubit for the entire admin area
        BlocProvider(create: (_) => OfficerReportsCubit()..fetchOfficerdata()),

        BlocProvider(
          create: (context) {
            final loginState = context.read<LoginCubit>().state;
            if (loginState is LoginSuccessState) {
              return UserDataCubit()..fetchUserData();
            }
            // Fallback: create cubit without immediately fetching
            return UserDataCubit();
          },
        ),
        // Provide AnalyticsCubit and fetch analytics data
        BlocProvider(create: (_) => AnalyticsCubit()..fetchAnalytics()),

        BlocProvider(create: (_) => AnalyticsLineCubit()..fetchLineAnalytics()),
      ],
      child: Scaffold(
        body: Row(
          children: [
            // LEFT SIDEBAR
            AdminSidebar(
              currentPageName: currentPageName,
              onPageChanged: (pageName, page) {
                final index = _pageNames.indexOf(pageName);
                if (index != -1) {
                  _onPageChanged(index);
                }
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

                    // MAIN CONTENT - Use IndexedStack to keep pages in memory
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: IndexedStack(
                          index: _currentPageIndex,
                          children: _pages,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
