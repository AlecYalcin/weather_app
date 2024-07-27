import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:Temporal/models/weather_model.dart';
import 'package:Temporal/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService("6e1a2ede6e5df1929f7400be08805b2d");

  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any error
    catch (e) {
      print(e);
    }
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
      backgroundColor: Colors.grey[800],
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
                      _weather?.cityName ?? "loading city..",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: 'arial',
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.push_pin, size: 24, color: Colors.white),
                  ],
                ),

                // animation
                Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

                // temperature
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_weather?.temperature.round().toString()}°C',
                          style: const TextStyle(
                            fontSize: 32,
                            fontFamily: 'arial',
                            color: Colors.white,
                          ),
                        ),
                        // condition
                        Text(getWeatherTranslation(_weather?.mainCondition),
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
