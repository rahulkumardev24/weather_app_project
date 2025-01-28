import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/constant/utils.dart';
import 'package:weather_app/data/api/api_helper.dart';
import 'package:weather_app/screen/day_forecast_screen.dart';
import 'package:weather_app/widgets/my_icon_button.dart';
import '../model/weather_data_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController locationController = TextEditingController();

  Future<weatherData>? _currentWeather;
  String currentLocation = "";
  PermissionStatus? locationPermission;
  bool searchShow = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _getCurrentLocation();
    setState(() {});
  }

  /// Check location permission and fetch location
  Future<void> _checkPermission() async {
    locationPermission = await Permission.location.request();
    if (locationPermission!.isGranted) {
      await _getCurrentLocation();
    } else if (locationPermission!.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Permission is permanently denied"),
        action: SnackBarAction(
          label: "Settings",
          onPressed: () async {
            await openAppSettings();
          },
        ),
      ));
    } else if (locationPermission!.isDenied) {
      locationPermission = await Permission.location.request();
    }
  }

  /// Fetch current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placeMark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMark[0];

      String location = "${place.locality}";
      currentLocation = location;

      setState(() {
        _currentWeather =
            ApiHelper.fetchWeatherForecast(location: currentLocation);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to get location: $e")),
      );
    }
  }

  /// here we create function for searching
  void _search() {
    String userSearch = locationController.text.trim();
    if (userSearch.isNotEmpty) {
      setState(() {
        currentLocation = userSearch;
        _currentWeather =
            ApiHelper.fetchWeatherForecast(location: currentLocation);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Enter Valid address",
        style: myTextStyle18(),
      )));
    }
  }

  MediaQueryData? mqData;

  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    return Scaffold(
      /// __________________________APPBAR__________________________________________///
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "lib/assets/images/map.png",
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  currentLocation,
                  style: myTextStyle18(fontColor: Colors.white70),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),

            /// here we show day status current we showing Good morning
            Text(
              "Good Morning",
              style: myTextStyle28(fontColor: Colors.white),
            )
          ],
        ),
        toolbarHeight: mqData!.size.height * 0.1,
        actions: [
          /// search button
          searchShow
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: MyIconButton(
                          buttonIcon: Icons.close_rounded,
                          buttonColor: Colors.blue.shade100,
                          iconSize: 35,
                          onTap: () {
                            setState(() {
                              searchShow = false;
                            });
                          })),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: MyIconButton(
                          buttonIcon: Icons.search_outlined,
                          buttonColor: Colors.blue.shade100,
                          iconSize: 35,
                          onTap: () {
                            setState(() {
                              searchShow = true;
                            });
                          })),
                )
        ],
      ),
      backgroundColor: Colors.black12,

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// search box
              searchShow
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: locationController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue.shade200,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Search location",
                          hintStyle: myTextStyle18(fontColor: Colors.black45),
                          suffixIcon: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16),
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(8))),
                                child: IconButton(

                                    /// in this search icon button search operation perform
                                    onPressed: () {
                                      _search();
                                    },
                                    icon: const Icon(
                                      Icons.search_outlined,
                                      color: Colors.white,
                                      size: 28,
                                    ))),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              _currentWeather == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<weatherData>(
                      future: _currentWeather,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        } else if (snapshot.hasData) {
                          final weatherData = snapshot.data;
                          return Column(
                            children: [
                              /// main card
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: mqData!.size.width,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.blue,
                                        Colors.orange.shade200
                                      ], begin: Alignment.topCenter),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 4,
                                            spreadRadius: 1)
                                      ]),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "lib/assets/icons/cloud weather.png",
                                        height: mqData!.size.height * 0.4,
                                        fit: BoxFit.cover,
                                      ),

                                      Text(
                                        "${weatherData!.current!.tempC}°",
                                        style: myTextStyle72(),
                                      ),
                                      Text(
                                        "${weatherData.current!.condition!.text}",
                                        style: myTextStyle28(),
                                      ),

                                      /// updated date show
                                      Text(
                                        DateFormat("dd MMM yyyy, hh:mm a")
                                            .format(DateTime.parse(weatherData
                                                .current!.lastUpdated
                                                .toString())),
                                        style: myTextStyle18(),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),

                                      /// ______________________Action Slider___________________________///
                                      ///
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
                                          'Slide to Next Day\'s',
                                          style: myTextStyle15(),
                                        ),
                                        action: (controller) async {
                                          controller.loading();
                                          await Future.delayed(
                                              const Duration(seconds: 1));
                                          controller.success();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DayForecastScreen(
                                                        location:
                                                            currentLocation,
                                                      )));
                                          setState(() {
                                            /// only this line add
                                            controller.reset();

                                            /// add
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8),
                                        child: Row(
                                          children: [
                                            /// feel like
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white38,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        "lib/assets/images/temprature.png",
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        "${weatherData.current!.feelslikeC}°C",
                                                        style: myTextStyle25(),
                                                      ),
                                                      Text(
                                                        "Feel Like",
                                                        style: myTextStyle18(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),

                                            /// Humidity
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white38,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        "lib/assets/images/humidity.png",
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        "${weatherData.current!.humidity}%",
                                                        style: myTextStyle25(),
                                                      ),
                                                      Text(
                                                        "Humidity",
                                                        style: myTextStyle18(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),

                                            /// Wind
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white38,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        "lib/assets/images/wind.png",
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Text(
                                                        "${weatherData.current!.windKph} kph",
                                                        style: myTextStyle25(),
                                                      ),
                                                      Text(
                                                        "Wind",
                                                        style: myTextStyle18(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              /// _________________SUN_________________///
                              /// here we show sunset and sunrise status
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(8)),
                                  width: mqData!.size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "lib/assets/icons/sun.png",
                                              height: 50,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Sunrise",
                                                  style: myTextStyle15(
                                                      fontColor:
                                                          Colors.white70),
                                                ),
                                                Text(
                                                  "${weatherData.forecast!.forecastday![0].astro!.sunrise}",
                                                  style: myTextStyle18(
                                                      fontColor: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "lib/assets/images/sunset-.png",
                                              height: 50,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Sunset",
                                                  style: myTextStyle15(
                                                      fontColor:
                                                          Colors.white70),
                                                ),
                                                Text(
                                                  "${weatherData.forecast!.forecastday![0].astro!.sunset}",
                                                  style: myTextStyle18(
                                                      fontColor: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              ///_________________MOON_________________///
                              ///here we show moonSet and moonRise
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(8)),
                                  width: mqData!.size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "lib/assets/images/moonrise.png",
                                              height: 50,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Moonrise",
                                                  style: myTextStyle15(
                                                      fontColor:
                                                          Colors.white70),
                                                ),
                                                Text(
                                                  "${weatherData.forecast!.forecastday![0].astro!.moonrise}",
                                                  style: myTextStyle18(
                                                      fontColor: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "lib/assets/images/moonset.png",
                                              height: 50,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Moonset",
                                                  style: myTextStyle15(
                                                      fontColor:
                                                          Colors.white70),
                                                ),
                                                Text(
                                                  "${weatherData.forecast!.forecastday![0].astro!.moonset}",
                                                  style: myTextStyle18(
                                                      fontColor: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// other details show
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: mqData!.size.height * 0.2,
                                  child: Row(
                                    children: [
                                      /// Pressure
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(22),
                                                    topLeft:
                                                        Radius.circular(22))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "lib/assets/images/air.png",
                                                height: 80,
                                              ),
                                              Text(
                                                "${weatherData.current!.pressureMb}Mb",
                                                style: myTextStyle22(
                                                    fontColor: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              Text(
                                                "Pressure",
                                                style: myTextStyle18(
                                                    fontColor: Colors.white70),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),

                                      /// Visibility
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.greenAccent,
                                                  Colors.blueAccent
                                                ],
                                              ),
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(22),
                                                  topLeft:
                                                      Radius.circular(22))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${weatherData.current!.visKm} Km",
                                                      style: myTextStyle28(
                                                          fontColor:
                                                              Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    Text(
                                                      "Visibility",
                                                      style: myTextStyle22(
                                                          fontColor:
                                                              Colors.black87),
                                                    )
                                                  ],
                                                ),
                                                Image.asset(
                                                  "lib/assets/images/eye.png",
                                                  height: 90,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// other details part 2
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SizedBox(
                                  height: mqData!.size.height * 0.2,
                                  child: Row(
                                    children: [
                                      /// Cloud Cover
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.greenAccent,
                                                  Colors.blueAccent
                                                ],
                                              ),
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(22),
                                                  topLeft:
                                                      Radius.circular(22))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${weatherData.current!.cloud} %",
                                                      style: myTextStyle28(
                                                          fontColor:
                                                              Colors.black,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    Text(
                                                      "Cloud Cover",
                                                      style: myTextStyle22(
                                                          fontColor:
                                                              Colors.black87),
                                                    )
                                                  ],
                                                ),
                                                Image.asset(
                                                  "lib/assets/icons/cloud.png",
                                                  height: 90,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),

                                      /// Heat index
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(22),
                                                    topLeft:
                                                        Radius.circular(22))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "lib/assets/icons/temperature.png",
                                                height: 80,
                                              ),
                                              Text(
                                                "${weatherData.current!.heatindexC}° C",
                                                style: myTextStyle22(
                                                    fontColor: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              Text(
                                                "Heat index",
                                                style: myTextStyle18(
                                                    fontColor: Colors.white70),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                      /// other details part 3
                                    ],
                                  ),
                                ),
                              ),

                              /// here we show forecast data
                            ],
                          );
                        } else {
                          return const Center(child: Text("No data available"));
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

/// Steps
/// Step 1
/// Fetch user current location => Done
/// current location check on realDevice
/// here we change something check complete code
/// Step 2
/// create custom text style => DONE
/// Step 3
/// app bar create => DONE
/// create icon button
/// Step 4
/// data show => DONE
///
/// FLOW THE STEPS FOR SHOW FORECAST DATA
/// FIRE GET JSON FILE
/// THEN CONVERT JSON TO MODEL THEN CREATE FUNCTION IN API API HELPER CALL
///
/// Step 5 => DONE
/// show next day information
/// create screen all date temperature
/// show date wise data
///
/// Step 6
/// Search functionality perform => DONE
///
