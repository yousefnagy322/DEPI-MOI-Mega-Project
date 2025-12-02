import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Data/report_model.dart';
import 'package:migaproject/Logic/officer_report_details/cubit.dart';
import 'package:migaproject/Logic/officer_report_details/state.dart';
import 'package:migaproject/presentation/screens/officer_dashboard/attachment_screens/full_image_screen.dart';
import 'package:migaproject/presentation/screens/officer_dashboard/attachment_screens/videoplayer_screen.dart';
import 'package:migaproject/presentation/widgets/loading_snackbar.dart';
import 'package:migaproject/presentation/widgets/success_snackbar.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ReportDetailScreen extends StatefulWidget {
  final String mapUrl;
  Report report;
  ReportDetailScreen({super.key, required this.report, required this.mapUrl});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  String currentStatus = "Pending";

  String? newStatus;
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.report.attachments[1].downloadUrl);
  }

  Future<Uint8List?> generateThumbnail(String videoUrl) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 150, // thumbnail width
      quality: 75,
    );
    return uint8list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Stack(
        children: [
          // Background Map Placeholder
          Container(
            height: 300,
            color: Colors.blueGrey[100],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 48, color: Colors.grey),
                  Text("Map Integration Here"),
                ],
              ),
            ),
          ),

          // Draggable Sheet for Details
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.6,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  controller: scrollController,
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "High Priority",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          'ID: ${widget.report.reportId!}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.report.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.blue),
                        SizedBox(width: 4),

                        if (widget.report.location.startsWith('https://')) ...[
                          Text(
                            'Google maps link',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ] else
                          Text(
                            widget.report.location,
                            style: TextStyle(color: Colors.black87),
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // AI Insights Block
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.indigo.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 18,
                                color: Colors.indigo,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "AI Analysis",
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Confidence Score: 94%",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Detected: Red light running. Vehicle Plate: ABC-1234. No collision detected.",
                            style: TextStyle(
                              color: Colors.indigo[900],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      "Evidence",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Mock Evidence Images
                    if (widget.report.attachments.isNotEmpty) ...[
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.report.attachments.length,
                          itemBuilder: (context, index) {
                            final attachment = widget.report.attachments[index];
                            final isVideo = attachment.fileType == 'video';
                            final url = attachment.downloadUrl;

                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (isVideo) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            VideoPlayerScreen(videoUrl: url),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            FullScreenImage(url: url),
                                      ),
                                    );
                                  }
                                },
                                child: isVideo
                                    ? FutureBuilder<Uint8List?>(
                                        future: generateThumbnail(url),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.memory(
                                                  snapshot.data!,
                                                  width: 100,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                                const Icon(
                                                  Icons.play_circle_fill,
                                                  color: Colors.white70,
                                                  size: 30,
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.black12,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : Image.network(
                                        url,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, progress) {
                                              if (progress == null)
                                                return child;
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ] else
                      const Center(
                        child: Text('No report Evidence available.'),
                      ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    BlocConsumer<
                      OfficerReportDetailsCubit,
                      OfficerReportDetailsState
                    >(
                      listener: (context, state) {
                        if (state is OfficerReportDetailsErrorState) {
                          print(state.error);
                        } else if (state is OfficerReportDetailsSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SuccessSnackBar(message: "Report Status Updated"),
                          );
                        } else if (state is OfficerReportDetailsLoadingState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            LoadingSnackBar(
                              message: "Updating report status...",
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  context
                                      .read<OfficerReportDetailsCubit>()
                                      .reportStatusUpdate(
                                        reportid: widget.report.reportId!,
                                        status: 'Rejected',
                                        notes: 'Rejected by officer',
                                      );
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text("Reject (False Alarm)"),
                              ),
                            ),
                            const SizedBox(width: 16),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final cubit = context
                                      .read<OfficerReportDetailsCubit>();
                                  showUpdateStatusSheet(
                                    context,
                                    cubit,
                                    widget.report.reportId!,
                                  );
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F2C59),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Update Status"),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showUpdateStatusSheet(
  BuildContext context,
  OfficerReportDetailsCubit cubit,
  String reportid,
) {
  String? newStatus;
  TextEditingController notesController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Update Report Status",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "New Status",
                border: OutlineInputBorder(),
              ),
              items: [
                "InProgress",
                "Resolved",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) {
                newStatus = val!;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: "Officer Notes (Internal)",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // use the cubit passed in
                  cubit.reportStatusUpdate(
                    reportid: reportid,
                    status: newStatus!,
                    notes: notesController.text.isNotEmpty
                        ? notesController.text
                        : 'Resolved by officer',
                  );
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F2C59),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Confirm Update"),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    },
  );
}
