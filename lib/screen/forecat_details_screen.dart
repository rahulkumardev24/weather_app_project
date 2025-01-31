import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constant/utils.dart';
import 'package:weather_app/data/api/api_helper.dart';
import 'package:weather_app/model/weather_data_model.dart';
import 'package:weather_app/screen/alert_message_screen.dart';
import 'package:weather_app/screen/day_forecast_screen.dart';
import 'package:weather_app/screen/hourly_details_screen.dart';
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
  dynamic sunRiseTime;
  dynamic sunSetTime;
  dynamic moonRiseTime;
  dynamic moonSetTime;
  dynamic index;
  dynamic rainChance;
  dynamic snowChance;
  dynamic totalSnow;
  dynamic uvIndex;
  dynamic avgVis;

  ForecastDetailsScreen(
      {super.key,
      required this.location,
      required this.date,
      required this.avgTemp,
      required this.humidity,
      required this.maxTemp,
      required this.minTemp,
      required this.maxWind,
      required this.visual,
      required this.moonRiseTime,
      required this.moonSetTime,
      required this.sunRiseTime,
      required this.sunSetTime,
      required this.index,
      required this.rainChance,
      required this.snowChance,
      required this.totalSnow,
      required this.uvIndex,
      required this.avgVis});

  @override
  State<ForecastDetailsScreen> createState() => _ForecatDetailsScreenState();
}

class _ForecatDetailsScreenState extends State<ForecastDetailsScreen> {
  late Future<weatherData> _forecastWeather;

  @override
  void initState() {
    super.initState();
    _forecastWeather =
        ApiHelper.fetchWeatherForecast(location: widget.location);
  }

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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DayForecastScreen(location: widget.location)));
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: mqData!.size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, blurRadius: 4)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4),
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

                                /// when click to Alert Message button Navigate to Alert Message Screen
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AlertMessageScreen(
                                                location: widget.location,
                                              )));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                        width: 2, color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
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
              const SizedBox(
                height: 12,
              ),

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
              ),
              const SizedBox(
                height: 12,
              ),

              /// moon
              MyAstroCard(
                startTitle: "Moonrise",
                endTitle: "Moonset",
                endTime: widget.moonSetTime,
                startTime: widget.moonRiseTime,
              ),
              const SizedBox(
                height: 12,
              ),

              /// here we show some other data
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// rain
                    MyDetailsCard(
                      imagePath: "lib/assets/icons/rainy-day.png",
                      title: "Rain",
                      value: "${widget.rainChance}%",
                      cardColor: Colors.blue.shade100,
                      borderColor: Colors.blue.shade100,
                    ),

                    /// snow
                    MyDetailsCard(
                      imagePath: "lib/assets/icons/snow.png",
                      title: "Snow",
                      value: "${widget.snowChance}%",
                      cardColor: Colors.blue.shade200,
                      borderColor: Colors.blue.shade200,
                    ),

                    /// snow
                    MyDetailsCard(
                      imagePath: "lib/assets/icons/snow.png",
                      title: "Snow",
                      value:
                          "${widget.totalSnow.toString().split(".").take(1).join()}Cm",
                      cardColor: Colors.blue.shade300,
                      borderColor: Colors.blue.shade300,
                    ),

                    /// Uv index
                    MyDetailsCard(
                      imagePath: "lib/assets/icons/uv.png",
                      title: "Uv Index",
                      value: "${widget.uvIndex}",
                      cardColor: Colors.blue.shade400,
                      borderColor: Colors.blue.shade400,
                    ),

                    /// Avg wind
                    MyDetailsCard(
                      imagePath: "lib/assets/images/eye.png",
                      title: "Avg Wind",
                      value: "${widget.avgVis}",
                      cardColor: Colors.blue.shade500,
                      borderColor: Colors.blue.shade500,
                    ),
                  ],
                ),
              ),

              /// here we show Hourly Data
              /// ______________________________HOURLY____________________________///
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Text(
                  "Hourly Forecast",
                  style: myTextStyle22(),
                ),
              ),
              FutureBuilder<weatherData>(
                future: _forecastWeather,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    /// here we pass the index
                    final List<Hour> hourlyForecast = snapshot
                            .data?.forecast?.forecastday?[widget.index].hour ??
                        [];
                    return SizedBox(
                      height: mqData!.size.height * 0.31,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hourlyForecast.length,
                        itemBuilder: (context, index) {
                          final hourData = hourlyForecast[index];
                          DateTime time = DateTime.parse(hourData.time!);
                          String formattedTime =
                              DateFormat("hh:mm a").format(time);
                          return SizedBox(
                            width: mqData!.size.width * 0.6,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Card(
                                color: Colors.blue.shade100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: mqData!.size.width,
                                      height: mqData!.size.height * 0.05,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: Colors.blue.shade800),
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10))),
                                      child: Center(
                                          child: Text(
                                        formattedTime,
                                        style: myTextStyle18(),
                                      )),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${hourData.tempC}°",
                                                style: myTextStyle25(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "Feels like ${hourData.feelslikeC}° ",
                                                style: myTextStyle15(),
                                              ),
                                              Text(
                                                hourData.condition!.text.toString().split(" ").take(2).join(" "),
                                                style: myTextStyle15(),
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Image.network(
                                              "https:${hourData.condition!.icon}",
                                              fit: BoxFit.cover,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        /// humidity
                                        Column(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white38,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Image.asset(
                                                    "lib/assets/images/humidity.png",
                                                    height:
                                                        mqData!.size.height *
                                                            0.04,
                                                  ),
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: Text(
                                                "${hourData.humidity!}%",
                                                style: myTextStyle15(),
                                              ),
                                            ),
                                          ],
                                        ),

                                        /// pressure
                                        Column(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white38,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Image.asset(
                                                    "lib/assets/images/air.png",
                                                    height:
                                                        mqData!.size.height *
                                                            0.04,
                                                  ),
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: Text(
                                                "${hourData.pressureIn!.toString().split(".").take(1).join()} In",
                                                style: myTextStyle15(),
                                              ),
                                            ),
                                          ],
                                        ),

                                        /// chance of rain
                                        Column(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white38,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Image.asset(
                                                    "lib/assets/icons/rainy-day.png",
                                                    height:
                                                        mqData!.size.height *
                                                            0.04,
                                                  ),
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: Text(
                                                "${hourData.chanceOfRain!}%",
                                                style: myTextStyle15(),
                                              ),
                                            ),
                                          ],
                                        ),

                                        /// chance of snow
                                        Column(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white38,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Image.asset(
                                                    "lib/assets/icons/snow.png",
                                                    height:
                                                        mqData!.size.height *
                                                            0.04,
                                                  ),
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: Text(
                                                "${hourData.chanceOfSnow!}%",
                                                style: myTextStyle15(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(),

                                    /// view more button
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "View Details",
                                          style: myTextStyle18(),
                                        ),
                                        SizedBox(
                                            height: mqData!.size.height * 0.04,
                                            width: mqData!.size.height * 0.04,
                                            child: MyIconButton(
                                                buttonColor: Colors.orange,
                                                iconColor: Colors.white,
                                                buttonIcon:
                                                    Icons.navigate_next_rounded,
                                                onTap: () {
                                                  /// Navigate to Hourly details screen
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => HourlyDetailsScreen(
                                                              temp: hourData
                                                                  .tempC,
                                                              snowChance: hourData
                                                                  .chanceOfSnow,
                                                              snowCm: hourData
                                                                  .snowCm,
                                                              cloud: hourData
                                                                  .cloud,
                                                              windChill: hourData
                                                                  .windchillC,
                                                              feelLike: hourData
                                                                  .feelslikeC,
                                                              heatIndex: hourData
                                                                  .heatindexC,
                                                              visual: hourData
                                                                  .visKm,
                                                              uv: hourData.uv,
                                                              condition: hourData
                                                                  .condition!
                                                                  .text,
                                                              icon: hourData
                                                                  .condition!
                                                                  .icon,
                                                              wind: hourData
                                                                  .windKph,
                                                              windDegree: hourData
                                                                  .windDegree,
                                                              rainChance: hourData
                                                                  .chanceOfRain,
                                                              humidity: hourData
                                                                  .humidity,
                                                            time: formattedTime,
                                                            location: widget.location ,
                                                            date: widget.date,

                                                          )));
                                                }))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: Text("No Data Found"));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// this is my Forecast Details screen
/// this is screen is use for all dates details show
/// create custom card to display other details
/// _________________Hourly Data______________________//
/// hourly data is not updated according to days
/// Complete Details screen
/// solve this Navigation problem
/// Solve
