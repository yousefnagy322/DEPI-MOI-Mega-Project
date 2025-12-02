import 'package:flutter/material.dart';

class UserActionMenu extends StatelessWidget {
  final Function(String) onActionSelected;

  const UserActionMenu({super.key, required this.onActionSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: onActionSelected,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Row(
              children: [
                Icon(Icons.visibility, size: 20, color: Colors.blue),
                SizedBox(width: 12),
                Text('View Profile', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Row(
              children: [
                Icon(Icons.edit, size: 20, color: Colors.blue),
                SizedBox(width: 12),
                Text('Edit User', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem(
          value: 'delete',
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Row(
              children: [
                Icon(Icons.delete, size: 20, color: Colors.red),
                SizedBox(width: 12),
                Text(
                  'Delete User',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

