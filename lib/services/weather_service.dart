import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  static const BASE_URL_GOOGLE =
      'https://maps.googleapis.com/maps/api/geocode/json';
  final String apiKey;
  final String googleApiKey;

  WeatherService(this.apiKey, this.googleApiKey);

  Future<Weather> getWeather(String latlon) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?$latlon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String? latlon = "lat=${position.latitude}&lon=${position.longitude}";
    // convert the location into a list of placemark objects
    //List<Placemark> placemarks =
    //await placemarkFromCoordinates(position.latitude, position.longitude);
    // extract the city name from the first placemark
    //String? city = placemarks[0].locality;

    return latlon;
  }

  Future<Weather>? getSearchQuery(String query) async {
    query = query.replaceAll(" ", "+");
    final response = await http
        .get(Uri.parse('$BASE_URL_GOOGLE?address=$query&key=$googleApiKey'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      var position = jsonResponse['results'][0]['geometry']['location'];
      String? latlon = "lat=${position['lat']}&lon=${position['lng']}";
      return getWeather(latlon);
    } else {
      throw Exception('Failed to localize weather data');
    }
  }
}
