import 'package:flutter/material.dart';
import 'package:weather_app/constant/utils.dart';
import 'package:weather_app/widgets/my_details_card.dart';
import 'package:weather_app/widgets/my_icon_button.dart';

import '../widgets/my_astro_card.dart';

class ForecastDetailsScreen extends StatefulWidget {
  /// here we create constructor
  dynamic location;
  dynamic date;
  dynamic avgTemp;
  dynamic minTemp;
  dynamic maxTemp;
  dynamic humidity;
  dynamic maxWind;
  dynamic visual;
  dynamic sunRiseTime ;
  dynamic sunSetTime ;
  dynamic moonRiseTime ;
  dynamic moonSetTime ;


  ForecastDetailsScreen(
      {super.key,
      required this.location,
      required this.date,
      required this.avgTemp,
      required this.humidity,
      required this.maxTemp,
      required this.minTemp,
      required this.maxWind,
      required this.visual ,
      required this.moonRiseTime ,
      required this.moonSetTime ,
      required this.sunRiseTime ,
      required this.sunSetTime ,

      });

  @override
  State<ForecastDetailsScreen> createState() => _ForecatDetailsScreenState();
}

class _ForecatDetailsScreenState extends State<ForecastDetailsScreen> {
  MediaQueryData? mqData;
  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    return Scaffold(
      ///_______________________________________APPBAR__________________________________///
      appBar: AppBar(
        toolbarHeight: mqData!.size.height * 0.08,
        centerTitle: true,
        title: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white60),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6),
              child: Text(widget.date),
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue.shade200, Colors.blue.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
          child: MyIconButton(
              buttonIcon: Icons.backspace_outlined,
              buttonColor: Colors.orange.shade200,
              onTap: () {
                Navigator.pop(context);
              }),
        ),
        actions: [
          Image.asset("lib/assets/icons/cloudy.png"),
          const SizedBox(
            width: 8,
          )
        ],
      ),

      ///____________________________BODY____________________________________///
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.orange.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: mqData!.size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 4)]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "lib/assets/images/map.png",
                            height: 20,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(widget.location)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Avg temp
                          Text(
                            "${widget.avgTemp}°",
                            style: myTextStyle36(),
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      width: 2, color: Colors.red),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "lib/assets/images/warning.png",
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "Alert Message",
                                    style: myTextStyle15(),
                                  )
                                ],
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyDetailsCard(
                            imagePath: "lib/assets/images/minremp.png",
                            cardColor: Colors.blue.shade100,
                            title: "Min Temp",
                            value: "${widget.minTemp}°C",
                          ),
                          MyDetailsCard(
                            imagePath: "lib/assets/images/maxtemp.png",
                            cardColor: Colors.orange.shade100,
                            title: "Max Temp",
                            value: "${widget.maxTemp}°C",
                          ),
                          MyDetailsCard(
                            imagePath: "lib/assets/images/humidity.png",
                            cardColor: Colors.greenAccent.shade100,
                            title: "Humidity",
                            value: "${widget.humidity}%",
                          ),
                          MyDetailsCard(
                            imagePath: "lib/assets/images/wind.png",
                            cardColor: Colors.red.shade100,
                            title: "Max Wind",
                            value: "${widget.maxWind}Kph",
                          ),
                          MyDetailsCard(
                            imagePath: "lib/assets/images/eye.png",
                            cardColor: Colors.blue.shade100,
                            title: "Visual",
                            value: "${widget.visual}Km",
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12,),

            /// astro details show
            /// here we call astro card
            /// Sun
            MyAstroCard(
              firstImage: "lib/assets/icons/sun.png",
              secondImage: "lib/assets/images/sunset-.png",
              startTitle: "Sunrise",
              endTitle: "Sunset",
              endTime: widget.sunSetTime,
              startTime: widget.sunRiseTime,
            ) ,
            const SizedBox(height: 12,),
            /// moon
            MyAstroCard(
              startTitle: "Moonrise",
              endTitle: "Moonset",
              endTime: widget.moonSetTime,
              startTime: widget.moonRiseTime,
            ) ,

            /// here we show Hourly Data


          ],
        ),
      ),
    );
  }
}

/// this is my Forecast Details screen
/// this is screen is use for all dates details show
/// create custom card to display other details
