import 'package:flutter/cupertino.dart';

/// website Link : https://www.weatherapi.com/
/// Link in the description Box

class Urls {
  /// THis is my API KEY
  static String API_KEY = "30160328e4774b77a1c81934252601";
  static String BASE_URL = "http://api.weatherapi.com/v1";

  /// get weather location
  static String getWeatherUrl(String location) {
    return "$BASE_URL/current.json?key=$API_KEY&q=$location";
  }

  /// get current location by latitude and longitude
  static String getWeatherByLatLong(String latitude, String longitude) {
    return "$BASE_URL/current.json?key=$API_KEY&q=$latitude,$longitude";
  }

  /// get forecast for a location
  static String getForecast(String location) {
    return "$BASE_URL/forecast.json?key=$API_KEY&q=$location&days=15";
  }

  /// Get forecast by latitude and longitude
  static String getForecastByLatLong(String latitude, String longitude) {
    return "$BASE_URL/forecast.json?key=$API_KEY&q=$latitude,$longitude&days=15";
  }

  /// Search or autocomplete for a location
  static String searchLocation(String query) {
    return "$BASE_URL/search.json?key=$API_KEY&q=$query";
  }

  /// Get Historical Weather data
  static String getHistoryWeather(String location, String date) {
    return "$BASE_URL/history.json?key=$API_KEY&q=$location&dt=$date";
  }

  /// Get Weather alert for a location
  static String getWeatherAlert(String location) {
    return "$BASE_URL/alerts.json?key=$API_KEY&q=$location";
  }

  /// Get Marine Weather data
  static String getMarineData(String location, String date) {
    return "$BASE_URL/marine.json?key=$API_KEY&q=$location&dt=$date";
  }

  /// Get astronomy data for a location
  static String getAstronomyData(String location, String date) {
    return "$BASE_URL/astronomy.json?key=$API_KEY&q=$location&dt=$date";
  }
}

/// you can also try other weather
///
///
/// URLS part complete
