import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String url;
  FullScreenImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Image.network(url, fit: BoxFit.contain)),
    );
  }
}
