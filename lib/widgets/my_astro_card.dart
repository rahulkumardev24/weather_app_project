import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/utils.dart';

class MyAstroCard extends StatelessWidget {
  String? firstImage;
  String? secondImage;
  String? startTitle;
  String? endTitle;
  String? startTime;
  String? endTime;
  Color? cardColor ;
  Color? titleColor ;
  Color? subTitleColor ;
  MyAstroCard({
    super.key,
    this.firstImage,
    this.secondImage,
    this.startTime,
    this.endTime,
    this.startTitle,
    this.endTitle,
    this.cardColor = Colors.blue,
    this.titleColor = Colors.black54,
    this.subTitleColor = Colors.black87,
  });

  MediaQueryData? mqData;
  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(8)),
        width: mqData!.size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    firstImage ?? "lib/assets/images/moonrise.png",
                    height: 50,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Column(
                    children: [
                      Text(
                        startTitle ?? "Moonrise",
                        style: myTextStyle15(fontColor: titleColor!),
                      ),
                      Text(
                        startTime ?? "0.0",
                        style: myTextStyle18(fontColor: subTitleColor!),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    secondImage ?? "lib/assets/images/moonset.png",
                    height: 50,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Column(
                    children: [
                      Text(
                        endTitle ?? "Moonset",
                        style: myTextStyle15(fontColor: titleColor!),
                      ),
                      Text(
                        endTime ?? "0.0",
                        style: myTextStyle18(fontColor: subTitleColor!),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// astro card complete
