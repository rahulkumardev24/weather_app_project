import 'package:flutter/material.dart';
import 'package:weather_app/constant/utils.dart';
import 'package:weather_app/widgets/my_details_card.dart';
import 'package:weather_app/widgets/my_icon_button.dart';

class HourlyDetailsScreen extends StatefulWidget {
  /// here we create constructor
  dynamic temp;
  dynamic snowChance;
  dynamic snowCm;
  dynamic cloud;
  dynamic windChill;
  dynamic feelLike;
  dynamic heatIndex;
  dynamic visual;
  dynamic uv;
  dynamic condition;
  dynamic icon;
  dynamic time;
  dynamic wind;
  dynamic windDegree;
  dynamic rainChance;
  dynamic humidity;
  dynamic location;
  dynamic date;

  HourlyDetailsScreen({
    super.key,
    required this.temp,
    required this.snowChance,
    required this.snowCm,
    required this.cloud,
    required this.windChill,
    required this.feelLike,
    required this.heatIndex,
    required this.visual,
    required this.uv,
    required this.condition,
    required this.icon,
    required this.wind,
    required this.windDegree,
    required this.rainChance,
    required this.humidity,
    required this.time,
    required this.location,
    required this.date,
  });

  @override
  State<HourlyDetailsScreen> createState() => _HourlyDetailsScreenState();
}

class _HourlyDetailsScreenState extends State<HourlyDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mqData = MediaQuery.of(context);
    final mqHeight = mqData.size.width;
    final mqWidth = mqData.size.width;

    return Scaffold(
      /// _______________________Appbar________________________///
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.orange.shade300, Colors.orange.shade200],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        ),
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/assets/images/map.png",
                  height: mqHeight * 0.04,
                ),
                Text(
                  "${widget.location}",
                  style: myTextStyle18(),
                )
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.black54)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
                  child: Text(
                    "${widget.date} ${widget.time}",
                    style: myTextStyle18(),
                  ),
                )),
          ],
        ),
        toolbarHeight: mqHeight * 0.2,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12),
          child: MyIconButton(
            buttonIcon: Icons.backspace_outlined,
            buttonColor: Colors.blue.shade200,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Image.asset("lib/assets/images/storm.png"),
          const SizedBox(width: 6)
        ],
      ),

      backgroundColor: Colors.white,

      ///______________________BODY____________________________///

      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.orange.shade200, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                child: SizedBox(
                  height: mqHeight * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Humidity
                      MyDetailsCard(
                        imagePath: "lib/assets/images/humidity.png",
                        title: "Humidity",
                        value: "${widget.humidity}%",
                        cardColor: Colors.blue.shade100,
                        borderColor: Colors.blue,
                      ),

                      /// pressure
                      MyDetailsCard(
                        imagePath: "lib/assets/images/air.png",
                        title: "Pressure",
                        value: "${widget.wind}Kph",
                        cardColor: Colors.yellow.shade100,
                        borderColor: Colors.yellow,
                      ),

                      /// Wind Degree
                      MyDetailsCard(
                        imagePath: "lib/assets/images/angle.png",
                        title: "Wind Deg",
                        value: "${widget.windDegree}°",
                        cardColor: Colors.red.shade100,
                        borderColor: Colors.red,
                      ),

                      /// index
                      MyDetailsCard(
                        imagePath: "lib/assets/images/temprature.png",
                        title: "Heat index",
                        value: "${widget.heatIndex}°",
                        cardColor: Colors.greenAccent.shade100,
                        borderColor: Colors.greenAccent,
                      ),
                      MyDetailsCard(
                        imagePath: "lib/assets/icons/uv.png",
                        title: "Uv index",
                        value: "${widget.uv}",
                        cardColor: Colors.pink.shade100,
                        borderColor: Colors.pink,
                      ),
                    ],
                  ),
                ),
              ),

              ///________________________Align___________________________///
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: mqHeight * 1.2,
                  width: mqWidth,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: mqHeight * 0.75,
                      ),

                      /// here we show show other data
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 3, color: Colors.orange),
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(22),
                                      topLeft: Radius.circular(22))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "lib/assets/images/wind.png",
                                      height: 80,
                                    ),
                                    Text(
                                      "${widget.wind} Kph",
                                      style: myTextStyle22(
                                          fontColor: Colors.black87,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text(
                                      "Wind",
                                      style: myTextStyle18(
                                          fontColor: Colors.black54),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 3, color: Colors.orange),
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(22),
                                      topLeft: Radius.circular(22))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "lib/assets/icons/windchill.png",
                                      height: 80,
                                    ),
                                    Text(
                                      "${widget.windChill} Kph",
                                      style: myTextStyle22(
                                          fontColor: Colors.black87,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text(
                                      "Chill Wind",
                                      style: myTextStyle18(
                                          fontColor: Colors.black54),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 3, color: Colors.orange),
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(22),
                                      topLeft: Radius.circular(22))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "lib/assets/images/eye.png",
                                      height: 80,
                                    ),
                                    Text(
                                      "${widget.visual} Km",
                                      style: myTextStyle22(
                                          fontColor: Colors.black87,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text(
                                      "Visual",
                                      style: myTextStyle18(
                                          fontColor: Colors.black54),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              /// Main Card
              Positioned(
                  top: mqHeight * 0.5,
                  left: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: mqWidth * 0.8,
                      height: mqHeight * 0.8,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.blue.shade400],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, blurRadius: 3)
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          /// Temp
                          Padding(
                            padding: const EdgeInsets.only(right: 22.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.temp}°",
                                      style: myTextStyle56(),
                                    ),
                                    Text(
                                      "Feel like : ${widget.feelLike}°",
                                      style: myTextStyle18(),
                                    ),

                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.orange),
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 1),
                                      child: Text(
                                        "${widget.condition}",
                                        style: myTextStyle18(),
                                      ),
                                    ))),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              /// Chance of rain
                              Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(
                                          "lib/assets/icons/rainy-day.png",
                                          height: mqData.size.height * 0.08,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      "Chance of rain",
                                      style: myTextStyle12(
                                          fontColor: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    "${widget.rainChance!}%",
                                    style:
                                        myTextStyle22(fontColor: Colors.white),
                                  ),
                                ],
                              ),

                              /// chance of snow
                              Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(
                                          "lib/assets/icons/snow.png",
                                          height: mqData.size.height * 0.08,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      "Chance of snow",
                                      style: myTextStyle12(
                                          fontColor: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    "${widget.snowChance!}%",
                                    style:
                                        myTextStyle22(fontColor: Colors.white),
                                  ),
                                ],
                              ),

                              /// Cloud
                              Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(
                                          "lib/assets/icons/cloud.png",
                                          height: mqData.size.height * 0.08,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      "Cloud",
                                      style: myTextStyle12(
                                          fontColor: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    "${widget.cloud!}%",
                                    style:
                                        myTextStyle22(fontColor: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
              Positioned(
                  top: mqHeight * 0.35,
                  left: 20,
                  child: Image.asset(
                    "lib/assets/images/sun.png",
                    height: mqHeight * 0.4,
                  )),
            ],
          )),
    );
  }
}

/// Hourly Details Screen => DONE
/// Check
