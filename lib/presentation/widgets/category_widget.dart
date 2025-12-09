import 'package:flutter/material.dart';
import 'package:migaproject/presentation/screens/Report_Form/report_form_screen.dart';

class categorywidget extends StatelessWidget {
  categorywidget({super.key, required this.image, required this.title});

  String image;
  String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportFormScreen(
              category: title == 'Public Nuisance' ? 'Public_Nuisance' : title,
            ),
          ),
        );
      },
      child: Container(
        width: 157,
        height: 146,
        decoration: BoxDecoration(
          color: Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'inter',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xff424242),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
