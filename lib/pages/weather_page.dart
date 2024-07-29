import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/components/my_appbar.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

// ignore: must_be_immutable
class WeatherPage extends StatefulWidget {
  final WeatherService weatherService;

  const WeatherPage({super.key, required this.weatherService});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _currentWeather;

  // fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await widget.weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await widget.weatherService.getWeather(cityName);
      setState(() {
        _currentWeather = weather;
      });
    }
    // any error
    catch (e) {
      print(e.toString());
    }
  }

  // refresh weather
  _updateWeather(Weather newWeather) {
    setState(() {
      _currentWeather = newWeather;
    });
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  String getWeatherTranslation(String? mainCondition) {
    if (mainCondition == null) return 'Procurando tempo...'; // default

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
        return 'Nuvens';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'Chuva';
      case 'thunderstorm':
        return 'Trovões';
      case 'clear':
      default:
        return 'Limpo';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: MyAppBar(
        onWeatherSelected: _updateWeather,
        weatherService: widget.weatherService,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // city
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _currentWeather?.cityName ?? "loading city..",
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontFamily: 'arial',
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.push_pin, size: 32, color: Colors.white),
                  ],
                ),

                // animation
                Lottie.asset(
                    getWeatherAnimation(_currentWeather?.mainCondition)),

                // temperature
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_currentWeather?.temperature.round().toString()}°C',
                          style: const TextStyle(
                            fontSize: 32,
                            fontFamily: 'arial',
                            color: Colors.white,
                          ),
                        ),
                        // condition
                        Text(
                            getWeatherTranslation(
                                _currentWeather?.mainCondition),
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'arial',
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
