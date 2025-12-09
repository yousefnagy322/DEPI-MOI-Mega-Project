import 'package:flutter/material.dart';
import 'package:migaproject/presentation/admin/admin_login_screen.dart';
import 'package:migaproject/presentation/admin/analytics_page.dart';
import 'package:migaproject/presentation/admin/dashboard_page.dart';
import 'package:migaproject/presentation/admin/reports_page.dart';
import 'package:migaproject/presentation/admin/users_page.dart';

class AdminSidebar extends StatelessWidget {
  final String currentPageName;
  final Function(String, Widget) onPageChanged;

  const AdminSidebar({
    super.key,
    required this.currentPageName,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 30),
          // App Logo
          Center(
            child: Image(
              image: AssetImage("assets/images/image 2.png"),
              height: 130,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40),

          // Navigation items
          _MenuItem(
            icon: Icons.dashboard,
            text: "Dashboard",
            page: const DashboardPage(),
            pageName: "Dashboard",
            isActive: currentPageName == "Dashboard",
            onTap: () => onPageChanged("Dashboard", const DashboardPage()),
          ),
          _MenuItem(
            icon: Icons.folder,
            text: "Reports",
            page: const ReportsPage(),
            pageName: "Reports",
            isActive: currentPageName == "Reports",
            onTap: () => onPageChanged("Reports", const ReportsPage()),
          ),
          _MenuItem(
            icon: Icons.people,
            text: "User Management",
            page: UsersPage(),
            pageName: "User Management",
            isActive: currentPageName == "User Management",
            onTap: () => onPageChanged("User Management", UsersPage()),
          ),

          _MenuItem(
            icon: Icons.bar_chart,
            text: "Analytics",
            page: const AnalyticsPage(),
            pageName: "Analytics",
            isActive: currentPageName == "Analytics",
            onTap: () => onPageChanged("Analytics", const AnalyticsPage()),
          ),

          // _MenuItem(
          //   icon: Icons.settings,
          //   text: "Settings",
          //   page: const SettingsPage(),
          //   pageName: "Settings",
          //   isActive: currentPageName == "Settings",
          //   onTap: () => onPageChanged("Settings", const SettingsPage()),
          // ),
          const Spacer(),

          // Support and Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // ListTile(
                //   leading: const Icon(Icons.help_outline, color: Colors.grey),
                //   title: const Text(
                //     "Support",
                //     style: TextStyle(color: Colors.grey),
                //   ),
                //   onTap: () {
                //     // Handle support
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.grey),
                  title: const Text(
                    "Log out",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    _showLogoutConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminLoginScreen(),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget page;
  final String pageName;
  final bool isActive;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.text,
    required this.page,
    required this.pageName,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.blue : Colors.grey[600],
          size: 20,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.black87,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
