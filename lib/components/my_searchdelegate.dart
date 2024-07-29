import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
//import 'package:weather_app/services/weather_service.dart';

class MySearchDelegate extends SearchDelegate<String> {
  final Function onWeatherSelected;
  final WeatherService weatherService;

  MySearchDelegate(
      {String hintText = "",
      required this.onWeatherSelected,
      required this.weatherService})
      : super(searchFieldLabel: hintText);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            Navigator.of(context).pop();
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<Weather>(
        future: weatherService.getSearchQuery(query),
        builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum dado encontrado'));
          } else {
            // Aqui você já tem os dados do Weather e pode construir sua página
            final weather = snapshot.data;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              onWeatherSelected(weather); // Use o callback para enviar os dados
              Navigator.pop(context); // Volte para a tela anterior
            });
            return Container();
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(color: Colors.grey[900]);
  }
}
