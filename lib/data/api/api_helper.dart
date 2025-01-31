/// here we craete Api Helper "

/// here we import http
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/data/api/urls.dart';

import '../../model/alert_data_model.dart';
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

  /// Fetch weather forecast data
  static Future<weatherData> fetchWeatherForecast({
    String? location,
    String? latitude,
    String? longitude,
  }) async {
    String url;
    if (latitude != null && longitude != null) {
      url = Urls.getForecastByLatLong(latitude, longitude);
    } else if (location != null) {
      url = Urls.getForecast(location);
    } else {
      throw Exception("Either location or latitude.longitude must be provided");
    }

    final response = await getAPI(url);
    return weatherData.fromJson(response);
  }

  /// here we create for others
  /// create method for fetch Alert Message
  static Future<AlertMessageData> fetchAlertMessage({
    String? location,
  }) async {
    String? url;
    if (location != null) {
      url = Urls.getWeatherAlert(location);
    }
    final response = await getAPI(url!);
    return AlertMessageData.fromJson(response);
  }
}

/// now we update api method
/// update forecast method
