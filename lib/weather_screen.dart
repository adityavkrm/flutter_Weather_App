import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:weather_app/secrets.dart';
import 'package:weather_app/widgets/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  final String cityName;
  const WeatherScreen({
    Key? key,
    required this.cityName,
  }) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/forecast?q=${widget.cityName}&APPID=$openWeatherApiKey"));
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw "An unexpected error occured !";
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather | ${widget.cityName}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh))
        ],
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentWeatherIndex = data['list'][0];

          final currentTemp =
              (currentWeatherIndex['main']['temp'] - 273.15).toStringAsFixed(0);

          final currentSky = currentWeatherIndex['weather'][0]['main'];
          final currentHumidity =
              currentWeatherIndex['main']['humidity'].toString();
          final currentWindSpeed =
              currentWeatherIndex['wind']['speed'].toString();
          final currentPressure =
              currentWeatherIndex['main']['pressure'].toString();

          Icon MyIcon() {
            if (currentSky == "Clouds") {
              return const Icon(CupertinoIcons.cloud_fill, size: 60);
            } else if (currentSky == "Rain") {
              return const Icon(CupertinoIcons.cloud_rain, size: 60);
            } else {
              return const Icon(CupertinoIcons.sun_max, size: 60);
            }
          }

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp°C',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              MyIcon(),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 110,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyIndex = data['list'][index + 1];
                        final hourlyTime =
                            DateTime.parse(hourlyIndex['dt_txt']);
                        final hourlyTemp =
                            '${(hourlyIndex['main']['temp'] - 273.15).toStringAsFixed(0)}°C';

                        return HourlyForecastItem(
                            time: DateFormat.jm().format(hourlyTime),
                            icon: hourlyIndex['weather'][0]['main'] ==
                                        'Clouds' ||
                                    hourlyIndex['weather'][0]['main'] == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            temperature: hourlyTemp);
                      }),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    additionalInfo(
                        Icons.water_drop, "Humidity", currentHumidity),
                    additionalInfo(
                        CupertinoIcons.wind, "Wind Speed", currentWindSpeed),
                    additionalInfo(
                        Icons.beach_access, "Pressure", currentPressure),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget additionalInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 30,
        ),
        SizedBox(
          height: 8,
        ),
        Text(label),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
