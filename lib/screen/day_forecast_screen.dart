import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:weather_app/constant/utils.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: FutureBuilder<weatherData>(
        future: _forecastData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Forecastday> forecastDays =
                snapshot.data!.forecast!.forecastday!;
            return Column(
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
                Expanded(
                  child: ListView.builder(
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
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Date
                                  Text(
                                    formattedDate,
                                    style: myTextStyle18(),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                        Image.network("https:${day.day?.condition?.icon}" , height: 50, ),
                                        Text("${day!.day!.condition!.text}" , style: myTextStyle15(),),
                                      ],
                                    ),
                                  ) ,
                                  Text("${day.day!.avgtempC}°" , style: myTextStyle32(fontWeight: FontWeight.bold),)

                                ],
                              ),
                            ) ,
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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
    );
  }
}
