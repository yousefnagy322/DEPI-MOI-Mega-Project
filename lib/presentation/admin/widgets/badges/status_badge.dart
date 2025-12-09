import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusInfo.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusInfo.color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (statusInfo.icon != null) ...[
            Icon(statusInfo.icon, size: 14, color: statusInfo.color),
            const SizedBox(width: 4),
          ],
          Text(
            status,
            style: TextStyle(
              color: statusInfo.color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(String status) {
    switch (status) {
      case "InProgress":
        return _StatusInfo(Colors.blue, Icons.sync);
      case "Submitted":
        return _StatusInfo(Colors.orange, Icons.visibility);
      case "Resolved":
        return _StatusInfo(Colors.green, Icons.check_circle);
      case "Rejected":
        return _StatusInfo(Colors.red, Icons.new_releases);
      case "Assigned":
        return _StatusInfo(Colors.purple, Icons.badge);
      default:
        return _StatusInfo(Colors.grey, null);
    }
  }
}

class _StatusInfo {
  final Color color;
  final IconData? icon;

  _StatusInfo(this.color, this.icon);
}
