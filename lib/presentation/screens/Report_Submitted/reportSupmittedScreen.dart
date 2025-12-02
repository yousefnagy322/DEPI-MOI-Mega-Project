import 'package:flutter/material.dart';
import 'package:migaproject/presentation/screens/my_reports/my_reports_screen.dart';

class ReportSubmittedScreen extends StatelessWidget {
  String reportId;
  ReportSubmittedScreen({super.key, required this.reportId});
  static String id = "ReportSubmittedScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 124,
                  height: 124,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffEAF6ED),
                  ),
                  child: Container(
                    width: 103,
                    height: 103,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 5),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 70,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Report Submitted!',
                  style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Your report has been successfully\nsubmitted and is now being\nreviewed by our team.',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    height: 1.3,
                    fontFamily: 'inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,

                    color: Color(0xff424242),
                  ),
                ),
                const SizedBox(height: 32),

                // Tracking ID Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Tracking ID',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reportId,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff1A73E8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Track Report Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1A73E8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Track Report',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Back to Home Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportsScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xff424242),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
