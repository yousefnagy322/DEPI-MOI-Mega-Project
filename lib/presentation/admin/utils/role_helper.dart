import 'package:flutter/material.dart';

class RoleInfo {
  final Color color;
  final IconData icon;

  RoleInfo({required this.color, required this.icon});
}

class RoleHelper {
  static RoleInfo getRoleInfo(String role) {
    switch (role) {
      case "Admin":
        return RoleInfo(
          color: Colors.purple,
          icon: Icons.admin_panel_settings,
        );
      case "Officer":
        return RoleInfo(
          color: Colors.blue,
          icon: Icons.badge,
        );
      case "Citizen":
        return RoleInfo(
          color: Colors.green,
          icon: Icons.person,
        );
      default:
        return RoleInfo(
          color: Colors.grey,
          icon: Icons.person_outline,
        );
    }
  }
}

