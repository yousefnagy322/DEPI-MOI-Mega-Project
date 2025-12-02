import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Data/report_model.dart';
import 'package:migaproject/Logic/new_report/cubit.dart';
import 'package:migaproject/Logic/new_report/state.dart';
import 'package:migaproject/presentation/screens/Report_Submitted/reportSupmittedScreen.dart';

class ReportReviewScreen extends StatefulWidget {
  String title;
  String categoryId;
  String description;
  String location;
  List<File> selectedFiles;
  Map<File, Uint8List?> videoThumbnails;
  String userid;

  ReportReviewScreen({
    super.key,
    required this.title,
    required this.categoryId,
    required this.description,
    required this.location,
    required this.selectedFiles,
    required this.videoThumbnails,
    required this.userid,
  });

  @override
  State<ReportReviewScreen> createState() => _ReportReviewScreenState();
}

class _ReportReviewScreenState extends State<ReportReviewScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewReportCubit(),
      child: BlocConsumer<NewReportCubit, NewReportState>(
        listener: (context, state) {
          if (state is NewReportErrorState) {
            print(state.error);
          } else if (state is NewReportLoadingState) {
            setState(() {
              isLoading = true;
            });
          } else if (state is NewReportSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ReportSubmittedScreen(reportId: state.id),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            body: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Review Report',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Category Section
                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Category',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.categoryId,
                                    style: TextStyle(color: Colors.blue[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Title',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Description Section
                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Location Section
                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Location',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.blue[400],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.location,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Attachments Section
                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Attachments',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 12),

                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.selectedFiles.length,
                                    itemBuilder: (context, index) {
                                      final file = widget.selectedFiles[index];
                                      final isVideo = file.path.endsWith(
                                        '.mp4',
                                      ); // or other video extensions

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[200],
                                          child: isVideo
                                              ? Image.memory(
                                                  widget
                                                      .videoThumbnails[file]!, // use passed thumbnails
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  file,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // AI Classification Section
                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AI Classification',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Traffic Violation-Red Light Running',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '94%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Buttons
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Edit Button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xff424242),
                              side: BorderSide(color: Color(0xffBDBDBD)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Submit Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Report report = Report(
                                userId: widget.userid,
                                title: widget.title,
                                descriptionText: widget.description,
                                categoryId: widget.categoryId.toLowerCase(),
                                location: widget.location,
                                hashedDeviceId: null,
                                transcribedVoiceText: null,
                                attachments: [],
                                filesToUpload: widget.selectedFiles,
                              );

                              context.read<NewReportCubit>().createNewReport(
                                report,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff1A73E8),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading
                                ? const Text(
                                    'Submitting...',
                                    style: TextStyle(
                                      fontFamily: 'inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,

                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Submit Report',
                                    style: TextStyle(
                                      fontFamily: 'inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,

                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Section Card Widget
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

// Attachment Chip Widget
class _AttachmentChip extends StatelessWidget {
  final String label;
  const _AttachmentChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
      ),
    );
  }
}
