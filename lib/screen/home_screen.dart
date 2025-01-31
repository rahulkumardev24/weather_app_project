import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/constant/utils.dart';
import 'package:weather_app/data/api/api_helper.dart';
import 'package:weather_app/screen/alert_message_screen.dart';
import 'package:weather_app/screen/day_forecast_screen.dart';
import 'package:weather_app/screen/forecat_details_screen.dart';
import 'package:weather_app/widgets/my_details_card.dart';
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

  /// here we create function for greeting
  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 20) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
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
  void _search() async {
    String userSearch = locationController.text.trim();
    if (userSearch.isNotEmpty) {
      setState(() {
        currentLocation = userSearch;
        _currentWeather =
            ApiHelper.fetchWeatherForecast(location: currentLocation);
      });
      try {
        await _currentWeather;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Enter valid address",
              style: myTextStyle18(fontColor: Colors.white),
            )));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Plz enter address",
            style: myTextStyle18(fontColor: Colors.white),
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.orange.shade100, Colors.blue.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
        ),
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
                  style: myTextStyle18(fontColor: Colors.black54),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),

            /// here we show day status current we showing Good morning
            Text(
              getGreeting(),
              style: myTextStyle28(fontColor: Colors.black),
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
                          buttonColor: Colors.blue.shade200,
                          iconSize: 35,
                          onTap: () {
                            setState(() {
                              searchShow = false;
                              locationController.clear();
                              _getCurrentLocation();
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
                          buttonColor: Colors.blue.shade300,
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

      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.orange.shade100, Colors.blue.shade100])),
        child: Center(
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
                            /// current weather
                            final currentWeatherData = snapshot.data;

                            /// hourly forecast
                            final currentHourlyData =
                                snapshot.data!.forecast!.forecastday![0].hour ??
                                    [];

                            /// days foreCast
                            List<Forecastday> daysForecastData =
                                snapshot.data!.forecast!.forecastday!;
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
                                              color: Colors.black,
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
                                          "${currentWeatherData!.current!.tempC}°",
                                          style: myTextStyle72(),
                                        ),
                                        Text(
                                          "${currentWeatherData.current!.condition!.text}",
                                          style: myTextStyle25(),
                                        ),

                                        /// updated date show
                                        Text(
                                          DateFormat("dd MMM yyyy, hh:mm a")
                                              .format(DateTime.parse(
                                                  currentWeatherData
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
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          "lib/assets/images/temprature.png",
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Text(
                                                          "${currentWeatherData.current!.feelslikeC}°C",
                                                          style:
                                                              myTextStyle25(),
                                                        ),
                                                        Text(
                                                          "Feel Like",
                                                          style:
                                                              myTextStyle18(),
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
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          "lib/assets/images/humidity.png",
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Text(
                                                          "${currentWeatherData.current!.humidity}%",
                                                          style:
                                                              myTextStyle25(),
                                                        ),
                                                        Text(
                                                          "Humidity",
                                                          style:
                                                              myTextStyle18(),
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
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          "lib/assets/images/wind.png",
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Text(
                                                          "${currentWeatherData.current!.windKph} kph",
                                                          style:
                                                              myTextStyle25(),
                                                        ),
                                                        Text(
                                                          "Wind",
                                                          style:
                                                              myTextStyle18(),
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
                                        color: Colors.black26,
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
                                                    "${currentWeatherData.forecast!.forecastday![0].astro!.sunrise}",
                                                    style: myTextStyle18(
                                                        fontColor:
                                                            Colors.white),
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
                                                    "${currentWeatherData.forecast!.forecastday![0].astro!.sunset}",
                                                    style: myTextStyle18(
                                                        fontColor:
                                                            Colors.white),
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
                                        color: Colors.black26,
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
                                                    "${currentWeatherData.forecast!.forecastday![0].astro!.moonrise}",
                                                    style: myTextStyle18(
                                                        fontColor:
                                                            Colors.white),
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
                                                    "${currentWeatherData.forecast!.forecastday![0].astro!.moonset}",
                                                    style: myTextStyle18(
                                                        fontColor:
                                                            Colors.white),
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

                                /// other details part 3
                                /// here we call my details card
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyDetailsCard(
                                          imagePath: "lib/assets/icons/uv.png",
                                          value: currentWeatherData.current!.uv
                                              .toString(),
                                          title: "UV Index",
                                          cardColor: Colors.blue.shade200),
                                      MyDetailsCard(
                                        imagePath:
                                            "lib/assets/icons/hurricane.png",
                                        value:
                                            "${currentWeatherData.current!.gustKph}Kph",
                                        title: "Gust",
                                        cardColor: Colors.orange.shade200,
                                      ),
                                      MyDetailsCard(
                                        imagePath:
                                            "lib/assets/icons/windchill.png",
                                        value:
                                            "${currentWeatherData.current!.windchillC}°",
                                        title: "Windchill",
                                        cardColor: Colors.blue.shade200,
                                      ),
                                      MyDetailsCard(
                                        imagePath:
                                            "lib/assets/icons/windDir.png",
                                        value:
                                            "${currentWeatherData.current!.windDir}",
                                        title: "Direction",
                                        cardColor: Colors.orange.shade200,
                                      ),
                                      MyDetailsCard(
                                        imagePath: "lib/assets/icons/water.png",
                                        value:
                                            "${currentWeatherData.current!.dewpointC}°",
                                        title: "Dew point",
                                        cardColor: Colors.blue.shade200,
                                      ),
                                    ],
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
                                                  width: 3,
                                                  color: Colors.white),
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
                                                  "${currentWeatherData.current!.pressureMb}Mb",
                                                  style: myTextStyle22(
                                                      fontColor: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                                Text(
                                                  "Pressure",
                                                  style: myTextStyle18(
                                                      fontColor:
                                                          Colors.black54),
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
                                                    Colors.black12,
                                                    Colors.black87
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(22),
                                                    topLeft:
                                                        Radius.circular(22))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${currentWeatherData.current!.visKm} Km",
                                                        style: myTextStyle28(
                                                            fontColor:
                                                                Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      Text(
                                                        "Visibility",
                                                        style: myTextStyle22(
                                                            fontColor:
                                                                Colors.white70),
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
                                                    Colors.black12,
                                                    Colors.black87
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(22),
                                                    topLeft:
                                                        Radius.circular(22))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${currentWeatherData.current!.cloud} %",
                                                        style: myTextStyle28(
                                                            fontColor:
                                                                Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                      Text(
                                                        "Cloud Cover",
                                                        style: myTextStyle22(
                                                            fontColor:
                                                                Colors.white70),
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
                                                  width: 3,
                                                  color: Colors.white),
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
                                                  "${currentWeatherData.current!.heatindexC}°C",
                                                  style: myTextStyle22(
                                                      fontColor: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                                Text(
                                                  "Heat index",
                                                  style: myTextStyle18(
                                                      fontColor:
                                                          Colors.black54),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                /// here we show forecast data
                                /// ____________ Hourly foreCast_____________///
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white60,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Text(
                                          "Hourly Forecast",
                                          style: myTextStyle22(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: mqData!.size.height * 0.18,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: currentHourlyData.length,
                                            itemBuilder: (contex, index) {
                                              final hourData =
                                                  currentHourlyData[index];
                                              DateTime time = DateTime.parse(
                                                  hourData.time!);
                                              String formatTime =
                                                  DateFormat("hh:mm a")
                                                      .format(time);
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: RadialGradient(
                                                        colors: [
                                                          Colors.white,
                                                          Colors.blue.shade100
                                                        ],
                                                        tileMode:
                                                            TileMode.repeated,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          formatTime,
                                                          style: myTextStyle12(
                                                              fontColor:
                                                                  Colors.black),
                                                        ),
                                                        Image.network(
                                                            "https:${hourData.condition!.icon}"),
                                                        Text(
                                                          "${hourData.tempC.toString().split(".").take(1).join()}°",
                                                          style: myTextStyle22(
                                                              fontColor:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Center(
                                          child: ActionSlider.standard(
                                            width: mqData!.size!.width * 0.9,
                                            height: mqData!.size.height * 0.06,
                                            rolling: true,
                                            icon: const Icon(
                                              Icons.navigate_next_rounded,
                                              size: 40,
                                              color: Colors.white70,
                                            ),
                                            toggleColor: Colors.orange.shade800,
                                            backgroundColor:
                                                Colors.orange.shade300,
                                            successIcon:
                                                const Icon(Icons.verified_user),
                                            child: Text(
                                              "Slide to More Detail\'s",
                                              style: myTextStyle18(),
                                            ),
                                            action: (controller) async {
                                              controller.loading();
                                              await Future.delayed(
                                                  const Duration(seconds: 1));

                                              /// when slide the hourly slider
                                              /// navigate to forecast details screen
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ForecastDetailsScreen(
                                                            location:
                                                                currentLocation,
                                                            date: "Today",
                                                            avgTemp:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .avgtempC,
                                                            humidity:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .avghumidity,
                                                            maxTemp:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .maxtempC,
                                                            minTemp:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .mintempC,
                                                            maxWind:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .maxtempC,
                                                            visual:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .avgvisKm,
                                                            moonRiseTime:
                                                                daysForecastData[
                                                                        0]
                                                                    .astro!
                                                                    .moonrise,
                                                            moonSetTime:
                                                                daysForecastData[
                                                                        0]
                                                                    .astro!
                                                                    .moonset,
                                                            sunRiseTime:
                                                                daysForecastData[
                                                                        0]
                                                                    .astro!
                                                                    .sunrise,
                                                            sunSetTime:
                                                                daysForecastData[
                                                                        0]
                                                                    .astro!
                                                                    .sunset,
                                                            // pass 0
                                                            index: 0,
                                                            rainChance:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .dailyChanceOfRain,
                                                            snowChance:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .dailyChanceOfSnow,
                                                            totalSnow:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .totalsnowCm,
                                                            uvIndex:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .uv,
                                                            avgVis:
                                                                daysForecastData[
                                                                        0]
                                                                    .day!
                                                                    .avgvisKm,
                                                          )));
                                              setState(() {
                                                /// only this line add
                                                controller.reset();

                                                /// add
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 21,
                                ),

                                /// here we show days forecast data
                                /// ____________ Days foreCast_____________///
                                /// _____________ 15 Day's forecast
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white60,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Text(
                                          "15 day\'s Forecast",
                                          style: myTextStyle22(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: mqData!.size.height * 0.18,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: daysForecastData.length,
                                            itemBuilder: (contex, index) {
                                              /// here we write code to format date , like , today . tomorrow , ...............
                                              var dayData =
                                                  daysForecastData[index];
                                              DateTime parsedDate =
                                                  DateTime.parse(
                                                      dayData.date ?? "");
                                              DateTime now = DateTime.now();
                                              DateTime tomorrow = now
                                                  .add(const Duration(days: 1));
                                              String formattedDate;
                                              if (parsedDate.year == now.year &&
                                                  parsedDate.month ==
                                                      now.month &&
                                                  parsedDate.day == now.day) {
                                                formattedDate = "Today";
                                              } else if (parsedDate.year ==
                                                      tomorrow.year &&
                                                  parsedDate.month ==
                                                      tomorrow.month &&
                                                  parsedDate.day ==
                                                      tomorrow.day) {
                                                formattedDate = "Next";
                                              } else {
                                                formattedDate =
                                                    DateFormat("d MMM")
                                                        .format(parsedDate);
                                              }

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: RadialGradient(
                                                        colors: [
                                                          Colors.white,
                                                          Colors.orange.shade100
                                                        ],
                                                        tileMode:
                                                            TileMode.repeated,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          formattedDate,
                                                          style: myTextStyle12(
                                                              fontColor:
                                                                  Colors.black),
                                                        ),
                                                        Image.network(
                                                            "https:${dayData.day!.condition!.icon}"),
                                                        Text(
                                                          "${dayData.day!.avgtempC.toString().split(".").take(1).join()}°",
                                                          style: myTextStyle22(
                                                              fontColor:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Center(
                                          child: ActionSlider.standard(
                                            width: mqData!.size!.width * 0.9,
                                            height: mqData!.size.height * 0.06,
                                            rolling: true,
                                            icon: const Icon(
                                              Icons.navigate_next_rounded,
                                              size: 40,
                                              color: Colors.white70,
                                            ),
                                            toggleColor: Colors.blue.shade800,
                                            backgroundColor:
                                                Colors.blue.shade300,
                                            successIcon:
                                                const Icon(Icons.verified_user),
                                            child: Text(
                                              "Slide to More Detail\'s",
                                              style: myTextStyle18(),
                                            ),
                                            action: (controller) async {
                                              controller.loading();
                                              await Future.delayed(
                                                  const Duration(seconds: 1));

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
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          } else {
                            return const Center(
                                child: Text("No data available"));
                          }
                        },
                      ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: mqData!.size.width * 0.9,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlertMessageScreen(
                                    location: currentLocation)));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: const BorderSide(
                                  width: 2, color: Colors.red))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "lib/assets/images/warning.png",
                            height: mqData!.size.height * 0.05,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Alert",
                            style: myTextStyle25(fontFamily: "secondary"),
                          )
                        ],
                      )),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
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
/// Step 5 => DONE
/// show next day information
/// create screen all date temperature
/// show date wise data
///
/// Step 6
/// Search functionality perform => DONE
///
/// Step 7
/// Solve some basic problem => DONE
///
/// Step 8
/// Forecast Details Screen => DONE
///
/// Step 9
/// According to time we show greeting => DONE
///
/// Step 10
/// add more data in home screen => DONE
///
/// Step 11
/// Show Hourly forecast in home screen => DONE
///
/// Steps 12
/// show Days Forecast in home screen => DONE
///
/// Step 13
/// background color change => DONE
///
/// Step 14
/// Alert message Screen and Show Alert Message => DONE
///
/// Step 15
/// Create Hourly Forecast details Screen => DONE
///
/// Step 16
/// Add Alert button in home screen => DONE
///
/// Step 17
/// Create Splash screen => DONE
///
/// Step 18
/// App Icon Change => Done
///
/// Step 19
/// Final Test
///
/// Thanks For Watching
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
