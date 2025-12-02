import 'package:flutter/material.dart';

class ReportDetailsPage extends StatelessWidget {
  final int reportId;
  const ReportDetailsPage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report #$reportId Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Category: Traffic", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const Text(
              "Description:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              "User reported a traffic violation at the intersection...",
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: () {}, child: const Text("Approve")),
            TextButton(onPressed: () {}, child: const Text("Reject")),
          ],
        ),
      ),
    );
  }
}
