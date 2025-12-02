import 'package:flutter/material.dart';

class UserFiltersBar extends StatelessWidget {
  final String search;
  final String? selectedRole;
  final Function(String) onSearchChanged;
  final Function(String?) onRoleChanged;

  const UserFiltersBar({
    super.key,
    required this.search,
    required this.selectedRole,
    required this.onSearchChanged,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search bar
        Expanded(
          flex: 3,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                hintText: "Search by name or email...",
                prefixIcon: Icon(Icons.search, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Role dropdown
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              value: selectedRole,
              hint: const Text("Role"),
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              isExpanded: false,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text("All Roles"),
                ),
                ...["Admin", "Officer", "Citizen"].map((role) {
                  return DropdownMenuItem(value: role, child: Text(role));
                }),
              ],
              onChanged: onRoleChanged,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Download icon
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: IconButton(
            icon: const Icon(Icons.download, size: 20),
            onPressed: () {},
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(width: 12),

        // Filter icon
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, size: 20),
            onPressed: () {},
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

