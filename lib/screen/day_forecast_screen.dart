import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:weather_app/constant/utils.dart';
import 'package:weather_app/screen/forecat_details_screen.dart';
import 'package:weather_app/widgets/my_icon_button.dart';
import 'package:weather_app/data/api/api_helper.dart';
import 'package:weather_app/model/weather_data_model.dart';

class DayForecastScreen extends StatefulWidget {
  final String location;

  const DayForecastScreen({super.key, required this.location});

  @override
  State<DayForecastScreen> createState() => _DayForecastScreenState();
}

class _DayForecastScreenState extends State<DayForecastScreen> {
  late Future<weatherData> _forecastData;

  @override
  void initState() {
    super.initState();
    _forecastData = ApiHelper.fetchWeatherForecast(location: widget.location);
  }

  MediaQueryData? mqData;
  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.orange.shade300, Colors.orange.shade200],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        ),
        toolbarHeight: 80,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 6),
          child: MyIconButton(
            buttonIcon: Icons.backspace_outlined,
            buttonColor: Colors.blue.shade200,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Image.asset("lib/assets/icons/cloud weather.png"),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.orange.shade200, Colors.blue.shade200],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: FutureBuilder<weatherData>(
          future: _forecastData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<Forecastday> forecastDays =
                  snapshot.data!.forecast!.forecastday!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Text(
                        "15 Day's Forecast",
                        style: myTextStyle22(),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: forecastDays.length,
                      itemBuilder: (context, index) {
                        /// here we write code to format date , like , today . tomorrow , ...............
                        var day = forecastDays[index];
                        DateTime parsedDate = DateTime.parse(day.date ?? "");
                        DateTime now = DateTime.now();
                        DateTime tomorrow = now.add(const Duration(days: 1));
                        String formattedDate;
                        if (parsedDate.year == now.year &&
                            parsedDate.month == now.month &&
                            parsedDate.day == now.day) {
                          formattedDate = "Today";
                        } else if (parsedDate.year == tomorrow.year &&
                            parsedDate.month == tomorrow.month &&
                            parsedDate.day == tomorrow.day) {
                          formattedDate = "Tomorrow";
                        } else {
                          formattedDate =
                              DateFormat("d MMM").format(parsedDate);
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.white24),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// Date
                                      SizedBox(
                                        width: 90,
                                        child: Text(
                                          formattedDate,
                                          style: myTextStyle18(
                                              fontColor: Colors.black87),
                                        ),
                                      ),

                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              "https:${day.day?.condition?.icon}",
                                              height: 50,
                                            ),
                                            Text(
                                              day!.day!.condition!.text!
                                                  .split(" ")
                                                  .take(2)
                                                  .join(" "),
                                              style: myTextStyle22(),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /// AVG Temp
                                      Container(
                                        height: mqData!.size.width * 0.18,
                                        width: mqData!.size.width * .19,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(5),
                                                topLeft: Radius.circular(5),
                                                bottomLeft: Radius.circular(21),
                                                topRight: Radius.circular(21))),
                                        child: Center(
                                          child: Text(
                                            "${day.day!.avgtempC}°",
                                            style: myTextStyle32(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// min temp
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                width: 2, color: Colors.orange),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.lightBlue.shade200,
                                                  Colors.white
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 8),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "lib/assets/images/minremp.png",
                                                height: 40,
                                              ),
                                              Text(
                                                "Min temp",
                                                style: myTextStyle12(),
                                              ),
                                              Text(
                                                "${day.day!.mintempC}°C",
                                                style: myTextStyle15(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      /// max temp
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                width: 2, color: Colors.blue),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.orange.shade200,
                                                  Colors.white
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 8),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "lib/assets/images/maxtemp.png",
                                                height: 40,
                                              ),
                                              Text(
                                                "Max temp",
                                                style: myTextStyle12(),
                                              ),
                                              Text(
                                                "${day.day!.maxtempC}°C",
                                                style: myTextStyle15(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      /// humidity
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.greenAccent.shade200,
                                                  Colors.white
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 8),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "lib/assets/images/humidity.png",
                                                height: 40,
                                              ),
                                              Text(
                                                "Humidity",
                                                style: myTextStyle12(),
                                              ),
                                              Text(
                                                "${day.day!.avghumidity}%",
                                                style: myTextStyle15(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      /// wind
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                width: 2,
                                                color: Colors.indigoAccent),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.redAccent.shade100,
                                                  Colors.white
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 8),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "lib/assets/images/wind.png",
                                                height: 40,
                                              ),
                                              Text(
                                                "Max Wind",
                                                style: myTextStyle12(),
                                              ),
                                              Text(
                                                "${day.day!.maxwindKph}Kph",
                                                style: myTextStyle15(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),

                                  /// here we show rain possible %
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.white60),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      title: Text(
                                        "Rain",
                                        style: myTextStyle18(),
                                      ),
                                      leading: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white60,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                                "lib/assets/icons/rainy-day.png"),
                                          )),
                                      subtitle: Text(
                                        "Daily chance of rain",
                                        style: myTextStyle15(),
                                      ),
                                      trailing: Text(
                                        "${day.day!.dailyChanceOfRain}%",
                                        style: myTextStyle18(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),

                                  /// View All Button
                                  ActionSlider.standard(
                                    width: mqData!.size!.width * 0.9,
                                    height: mqData!.size.height * 0.06,
                                    rolling: true,
                                    icon: const Icon(
                                      Icons.navigate_next_rounded,
                                      size: 40,
                                      color: Colors.white70,
                                    ),
                                    toggleColor: Colors.blue.shade800,
                                    backgroundColor: Colors.white,
                                    successIcon:
                                        const Icon(Icons.verified_user),
                                    child: Text(
                                      'Slide to View details',
                                      style: myTextStyle15(),
                                    ),
                                    action: (controller) async {
                                      controller.loading();
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      controller.success();

                                      /// After Navigation Show Forecast Details Screen

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForecastDetailsScreen()));

                                      setState(() {
                                        /// only this line add
                                        controller.reset();

                                        /// add
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(
                  "No data available",
                  style: myTextStyle22(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

/// when pop to home screen slider button not reset
/// so first solve the problem => Done
///
/// Day Forecast screen Complete
/// check Complete code
