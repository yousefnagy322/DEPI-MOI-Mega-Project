import 'package:flutter/material.dart';
import 'report_details_page.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "All Reports",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: ListView.builder(
            itemCount: 10, // replace with Firestore data
            itemBuilder: (_, i) {
              return Card(
                child: ListTile(
                  title: Text("Report #$i"),
                  subtitle: const Text("Traffic violation"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReportDetailsPage(reportId: i),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
