import 'package:flutter/material.dart';
import 'package:weather_app/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}



///___******************** WEATHER APP ******************___///
/// In This vide we creating Complete Weather app
/// Free Api use for weather
/// STEPS
/// Step 1
/// Project SetUp => DONE
/// Step 2
/// Find Free API => Done
/// Step 3
/// Get API KEY => DONE
/// Step 4
/// Get Urls and create model => DONE
/// Step 5
/// Api helper create => DONE
/// Step 6
/// Hit the Api => Done
/// Step 7
/// All Current Weather show in home screen And Also UI Create

