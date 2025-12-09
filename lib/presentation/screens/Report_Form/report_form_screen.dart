import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:migaproject/presentation/screens/report_review/reportReviewScreen.dart';
import 'package:migaproject/presentation/widgets/success_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ReportFormScreen extends StatefulWidget {
  String category;
  ReportFormScreen({super.key, required this.category});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  String? locationLink;
  List<File>? selectedimages = [];
  List<File>? selectedVideos = [];

  List<File> selectedFiles = [];

  Map<File, Uint8List?> videoThumbnails = {}; // store thumbnails globally

  String? userId;

  @override
  void initState() {
    super.initState();
    getLocationLink();
    getuserid();
  }

  void pickImages() async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedimages!.addAll(pickedFiles.map((x) => File(x.path)));
        selectedFiles.addAll(selectedimages!);
        selectedimages = [];
      });
    }
  }

  // void pickVideos() async {
  //   final List<XFile>? pickedVideos = await ImagePicker().pickMultiVideo();

  //   if (pickedVideos != null && pickedVideos.isNotEmpty) {
  //     setState(() {
  //       selectedVideos!.addAll(pickedVideos.map((x) => File(x.path)));
  //       selectedFiles.addAll(selectedVideos!);
  //       selectedVideos = [];
  //     });
  //   }
  // }

  void pickVideos() async {
    final List<XFile>? pickedVideos = await ImagePicker().pickMultiVideo();

    if (pickedVideos != null && pickedVideos.isNotEmpty) {
      for (var xfile in pickedVideos) {
        File file = File(xfile.path);

        // Generate thumbnail
        final Uint8List? thumb = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.PNG,
          maxWidth: 100,
          quality: 75,
        );

        videoThumbnails[file] = thumb; // store thumbnail

        selectedFiles.add(file); // add video to combined list
      }

      setState(() {
        selectedVideos!.clear(); // clear temp list if needed
      });
    }
  }

  Future getuserid() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');

    userId = id;
  }

  Future<void> getLocationLink() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      locationLink =
          "https://www.google.com/maps/search/?api=1&query=${pos.latitude},${pos.longitude}";
    });
  }

  final formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  int selectedLocation = 0; // 0 = Use Current, 1 = Select Manually
  bool isRecording = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
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
                    child: const Icon(Icons.arrow_back, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Report Form',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Category : ${widget.category}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Title',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                fontFamily: 'inter',
                                color: Color(0xff424242),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "This field is required";
                                }
                                if (value.trim().length < 3) {
                                  return "Must be at least 3 characters";
                                }
                                if (value.trim().length > 500) {
                                  return "Cannot exceed 500 characters";
                                }
                                return null;
                              },
                              controller: titleController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffF3F3F5),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xffCFCFCF),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xffCFCFCF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description Section
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                fontFamily: 'inter',
                                color: Color(0xff424242),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "This field is required";
                                }
                                if (value.trim().length < 10) {
                                  return "Must be at least 10 characters";
                                }
                                return null;
                              },
                              controller: descriptionController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffF3F3F5),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xffCFCFCF),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xffCFCFCF),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 62,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  int selectedLanguage =
                                      0; // 0 English - 1 Arabic

                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Header
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Voice to Text',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 20),

                                                // Language buttons
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => setState(
                                                        () => selectedLanguage =
                                                            0,
                                                      ),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 24,
                                                              vertical: 10,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              selectedLanguage ==
                                                                  0
                                                              ? Color(
                                                                  0xff1A73E8,
                                                                )
                                                              : Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          border: Border.all(
                                                            color:
                                                                selectedLanguage ==
                                                                    0
                                                                ? Color(
                                                                    0xff1A73E8,
                                                                  )
                                                                : Colors
                                                                      .grey[300]!,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "English",
                                                          style: TextStyle(
                                                            color:
                                                                selectedLanguage ==
                                                                    0
                                                                ? Colors.white
                                                                : Color(
                                                                    0xff424242,
                                                                  ),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    GestureDetector(
                                                      onTap: () => setState(
                                                        () => selectedLanguage =
                                                            1,
                                                      ),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 24,
                                                              vertical: 10,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              selectedLanguage ==
                                                                  1
                                                              ? Color(
                                                                  0xff1A73E8,
                                                                )
                                                              : Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          border: Border.all(
                                                            color:
                                                                selectedLanguage ==
                                                                    1
                                                                ? Color(
                                                                    0xff1A73E8,
                                                                  )
                                                                : Colors
                                                                      .grey[300]!,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "Arabic",
                                                          style: TextStyle(
                                                            color:
                                                                selectedLanguage ==
                                                                    1
                                                                ? Colors.white
                                                                : Colors
                                                                      .grey[700],
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 24),

                                                // Mic
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: isRecording
                                                        ? Colors.red
                                                        : Color(0xff1A73E8),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.mic,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                ),

                                                const SizedBox(height: 12),

                                                if (!isRecording)
                                                  Text(
                                                    'Tap to Start recording',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                else
                                                  Image.asset(
                                                    'assets/images/recording.png',
                                                  ),

                                                const SizedBox(height: 20),

                                                // Start Recording Button
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isRecording =
                                                            !isRecording;
                                                      });
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          isRecording
                                                          ? Color(0xff8CB9F3)
                                                          : Color(0xff1A73E8),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 14,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      isRecording
                                                          ? 'Recording .....'
                                                          : 'Start Recording',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: Image.asset('assets/images/mic.png'),
                                label: const Text(
                                  'Record Voice Instead',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xff1A73E8),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  side: const BorderSide(
                                    color: Color(0xff1A73E8),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Location Section
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff424242),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Location Box
                            Container(
                              height: 70,
                              width: 281,
                              decoration: BoxDecoration(
                                color: Color(0xffD2E1F8),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/location.png',
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Location Buttons
                            Text(
                              'Current Location',
                              style: TextStyle(
                                color: Color(0xff424242),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _LocationButton(
                                  label: 'Use Current',
                                  isSelected: selectedLocation == 0,
                                  onTap: () =>
                                      setState(() => selectedLocation = 0),
                                ),
                                const SizedBox(width: 12),
                                _LocationButton(
                                  label: 'Select Manually',
                                  isSelected: selectedLocation == 1,
                                  onTap: () =>
                                      setState(() => selectedLocation = 1),
                                ),
                              ],
                            ),

                            if (selectedLocation == 1) ...[
                              const SizedBox(height: 12),
                              TextField(
                                controller: locationController,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xffF3F3F5),
                                  hintText: 'Enter Location Manually',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Color(0xffCFCFCF),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Color(0xffCFCFCF),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Attachments Section
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Attachments',
                              style: TextStyle(
                                color: Color(0xff424242),
                                fontFamily: 'inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    pickImages();
                                  },
                                  child: _AttachmentButton(
                                    icon: Icons.image_outlined,
                                    label: 'Photo',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    pickVideos();
                                  },
                                  child: _AttachmentButton(
                                    icon: Icons.videocam_outlined,
                                    label: 'Video',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     _AttachmentButton(
                            //       icon: Icons.graphic_eq,
                            //       label: 'Audio',
                            //     ),
                            //     const SizedBox(width: 12),
                            //     _AttachmentButton(
                            //       icon: Icons.description_outlined,
                            //       label: 'Document',
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),

                      if (selectedFiles.isNotEmpty) ...[
                        _SectionCard(
                          child: SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedFiles.length,
                              itemBuilder: (context, index) {
                                final file = selectedFiles[index];
                                final isVideo = file.path.endsWith('.mp4');

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedFiles.removeAt(index);
                                        videoThumbnails.remove(file);
                                      });
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[200],
                                      child: isVideo
                                          ? (videoThumbnails[file] != null
                                                ? Image.memory(
                                                    videoThumbnails[file]!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ))
                                          : Image.file(file, fit: BoxFit.cover),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // AI Assistance Section
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI Assistance',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 18,
                                color: Color(0xff424242),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: 292,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Title
                                            const Text(
                                              'AI Suggested Improvement',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 16),

                                            // Suggestion Text Box
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '"I witnessed a traffic violation at the intersection of Sheikh Zayed Road and Al Wasl Road. A vehicle with license plate ABC-1234 ran a red light at approximately 3:45 PM, nearly causing a collision with pedestrians crossing the street. This is a serious safety concern that requires immediate attention."',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[700],
                                                  height: 1.5,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 20),

                                            // Buttons Row
                                            Row(
                                              children: [
                                                // Reject Button
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    style: OutlinedButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.grey[700],
                                                      side: BorderSide(
                                                        color:
                                                            Colors.grey[300]!,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              24,
                                                            ),
                                                      ),
                                                    ),
                                                    child: const Text('Reject'),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),

                                                // Accept Button
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Color(
                                                        0xff1A73E8,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              24,
                                                            ),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'Accept',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff1A73E8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'AI: Improve Description',
                                  style: TextStyle(
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate() &&
                        selectedFiles.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportReviewScreen(
                            userid: userId!,
                            title: titleController.text,
                            categoryId: widget.category,
                            description: descriptionController.text,
                            selectedFiles: selectedFiles,
                            videoThumbnails: videoThumbnails,
                            location: selectedLocation == 0
                                ? locationLink!
                                : locationController.text,
                          ),
                        ),
                      );
                    } else if (formkey.currentState!.validate() &&
                        selectedFiles.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SuccessSnackBar(
                          message: 'Please upload at least one image or video',
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1A73E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continue to Review',
                    style: TextStyle(
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

// Location Button Widget
class _LocationButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 126,
        height: 62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xff0D47A1) : Color(0xffBDBDBD),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              const SizedBox(width: 15),
              Image.asset(
                'assets/images/location.png',
                color: Color(0xff1A73E8),
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Color(0xff1A73E8) : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Attachment Button Widget
class _AttachmentButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AttachmentButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 62,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffBDBDBD)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xff424242),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
