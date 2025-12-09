import 'package:flutter/material.dart';
import 'package:migaproject/Data/report_model.dart';
import 'package:migaproject/presentation/admin/utils/date_formatter.dart';
import 'package:migaproject/presentation/admin/widgets/badges/status_badge.dart';
import 'package:url_launcher/link.dart';

class ReportDetailsPage extends StatelessWidget {
  final Report report;
  const ReportDetailsPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final createdAt = report.createdAt != null
        ? DateTime.tryParse(report.createdAt!) ?? DateTime.now()
        : DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          "Report #${report.reportId ?? '-'}",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 768;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row: title + status
                  isSmallScreen
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.label_outline,
                                        size: 14,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        report.categoryId,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormatter.formatDate(createdAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatusBadge(status: report.status ?? ''),
                                if (report.aiConfidence != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    "AI confidence: ${(report.aiConfidence! * 100).toStringAsFixed(1)}%",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.title,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(999),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.label_outline,
                                              size: 14,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              report.categoryId,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormatter.formatDate(createdAt),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                StatusBadge(status: report.status ?? ''),
                                const SizedBox(height: 8),
                                if (report.aiConfidence != null)
                                  Text(
                                    "AI confidence: ${(report.aiConfidence! * 100).toStringAsFixed(1)}%",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Meta info grid
              Wrap(
                spacing: isSmallScreen ? 16 : 32,
                runSpacing: 12,
                children: [
                  _metadataItem(
                    label: "Report ID",
                    value: report.reportId ?? '—',
                    isSmallScreen: isSmallScreen,
                  ),
                  _metadataItem(
                    label: "User ID",
                    value:
                        report.userId ??
                        (report.isAnonymous ? "Anonymous" : '—'),
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildLocationMeta(report.location, isSmallScreen),
                  _metadataItem(
                    label: "Created at",
                    value: DateFormatter.formatDate(createdAt),
                    isSmallScreen: isSmallScreen,
                  ),
                  _metadataItem(
                    label: "Anonymous",
                    value: report.isAnonymous ? "Yes" : "No",
                    isSmallScreen: isSmallScreen,
                  ),
                  if (report.updatedAt != null)
                    _metadataItem(
                      label: "Last updated",
                      value: report.updatedAt!,
                      isSmallScreen: isSmallScreen,
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Description
              const Text(
                "Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                report.descriptionText,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  height: 1.4,
                ),
              ),

              if (report.transcribedVoiceText != null &&
                  report.transcribedVoiceText!.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  "Transcribed Voice Note",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    report.transcribedVoiceText!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Attachments
              const Text(
                "Attachments",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (report.attachments.isEmpty)
                Text(
                  "No attachments",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                )
              else
                Column(
                  children: report.attachments
                      .map(
                        (att) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.attach_file,
                                size: 20,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      att.fileType,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      att.mimeType,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Link(
                                uri: Uri.tryParse(att.downloadUrl),
                                target: LinkTarget.blank,
                                builder: (ctx, followLink) => TextButton.icon(
                                  onPressed: followLink,
                                  icon: const Icon(Icons.open_in_new, size: 16),
                                  label: const Text("Open"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    ),
    );
  }

  Widget _metadataItem({
    required String label,
    required String value,
    bool isSmallScreen = false,
  }) {
    return SizedBox(
      width: isSmallScreen ? double.infinity : 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// If the location looks like a Google Maps / URL, show a button to open it,
  /// otherwise keep it as plain text.
  Widget _buildLocationMeta(String location, bool isSmallScreen) {
    final trimmed = location.trim();
    final isUrl =
        trimmed.startsWith('http://') || trimmed.startsWith('https://');

    if (!isUrl) {
      return _metadataItem(
        label: 'Location',
        value: trimmed,
        isSmallScreen: isSmallScreen,
      );
    }

    final uri = Uri.tryParse(trimmed);

    return SizedBox(
      width: isSmallScreen ? double.infinity : 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LOCATION',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Google Maps link',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (uri != null)
                Link(
                  uri: uri,
                  target: LinkTarget.blank,
                  builder: (ctx, followLink) => TextButton(
                    onPressed: followLink,
                    child: const Text('Open'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
