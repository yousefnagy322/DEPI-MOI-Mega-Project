import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  final String currentPageName;

  const AdminHeader({super.key, required this.currentPageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          // Page Title
          Text(
            _getPageTitle(currentPageName),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(String pageName) {
    switch (pageName) {
      case "Dashboard":
        return "Dashboard Overview";
      case "User Management":
        return "User Management";
      default:
        return pageName;
    }
  }
}
