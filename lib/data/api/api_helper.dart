/// here we craete Api Helper "

/// here we import http
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/data/api/urls.dart';

import '../../model/weather_data_model.dart';

class ApiHelper {
  /// BASE GET Request method
  static Future<Map<String, dynamic>> getAPI(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            "Failed to load data . Status Code : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during API call $e");
    }
  }

  /// Fetch current weather data
  static Future<weatherData> fetchWeatherData(
      {String? location, String? latitude, String? longitude}) async {
    String url;
    if (latitude != null && longitude != null) {
      url = Urls.getWeatherByLatLong(latitude, longitude);
    } else if (location != null) {
      url = Urls.getWeatherUrl(location);
    } else {
      throw Exception("Either location or latitude.longitude must be provide");
    }
    final response = await getAPI(url);
    return weatherData.fromJson(response);
  }

  /// here we create for others
}
