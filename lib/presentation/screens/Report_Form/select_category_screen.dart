import 'package:flutter/material.dart';
import 'package:migaproject/presentation/screens/Auth_screens/login_screen.dart';
import 'package:migaproject/presentation/widgets/category_widget.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 125,
            decoration: BoxDecoration(color: Color(0xffF5F5F5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                // const Icon(Icons.arrow_back, color: Colors.grey),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Choose the type of report',
                      style: TextStyle(
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color(0xffBDBDBD),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 232, 73, 71),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: GridView(
                padding: EdgeInsets.only(top: 10),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 20,
                  childAspectRatio: 157 / 146,
                ),
                children: [
                  categorywidget(
                    image: 'assets/images/Traffic.png',
                    title: 'Traffic',
                  ),
                  categorywidget(
                    image: 'assets/images/Theft.png',
                    title: 'Crime',
                  ),
                  categorywidget(
                    image: 'assets/images/Noise.png',
                    title: 'Public Nuisance',
                  ),
                  categorywidget(
                    image: 'assets/images/Utilities.png',
                    title: 'Utilities',
                  ),
                  categorywidget(
                    image: 'assets/images/Missing.png',
                    title: 'Infrastructure',
                  ),
                  categorywidget(
                    image: 'assets/images/enviroment.png',
                    title: 'Environmental',
                  ),
                  categorywidget(
                    image: 'assets/images/Other.png',
                    title: 'Other',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
