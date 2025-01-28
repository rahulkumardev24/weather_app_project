import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/utils.dart';

class MyDetailsCard extends StatelessWidget {
  /// create constructor
  Color? cardColor;
  Color? borderColor;
  String? title;
  dynamic value;
  String imagePath;

  MyDetailsCard({
    super.key,
    this.borderColor = Colors.black,
    this.title = "title",
    this.value = "0",
    this.cardColor = Colors.blue,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor ?? Colors.greenAccent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2, color: borderColor ?? Colors.orange),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 40,
            ),
            Text(
              title ?? "Title",
              style: myTextStyle12(),
            ),
            Text(
              value ?? "0",
              style: myTextStyle15(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/// complete card
