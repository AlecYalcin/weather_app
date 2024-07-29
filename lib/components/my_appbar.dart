import 'package:flutter/material.dart';
import 'package:weather_app/components/my_searchdelegate.dart';
import 'package:weather_app/services/weather_service.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function onWeatherSelected;
  final WeatherService weatherService;

  const MyAppBar(
      {super.key,
      required this.onWeatherSelected,
      required this.weatherService});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[400],
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            await showSearch(
              context: context,
              delegate: MySearchDelegate(
                hintText: "Procure por uma cidade",
                onWeatherSelected: onWeatherSelected,
                weatherService: weatherService,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
