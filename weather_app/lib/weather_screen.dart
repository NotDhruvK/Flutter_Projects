import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart' show AdditionalInfoItem;
import 'package:weather_app/hourly_forecast_item.dart' show HourlyForecastItem;
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Mumbai';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
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
        title: const Text(
          "Weather",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (asyncSnapshot.hasError) {
            return Center(
              child: Text(
                asyncSnapshot.error.toString(),
              ),
            );
          }
          final data = asyncSnapshot.data!;
          final currentWeatherData = data['list'][0];

          final currentTemp = ((currentWeatherData['main']['temp'] - 273.15)
              .toStringAsFixed(2));
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                //top widget
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp °C",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //spacer
                const SizedBox(
                  height: 20,
                ),

                // Middle Text
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Weather Forecast",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                //spacer
                const SizedBox(
                  height: 8,
                ),

                //Middle Row
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                        time: DateFormat.j().format(time),
                        temperature:
                            "${((hourlyForecast['main']['temp']) - 273.25).toStringAsFixed(2)} °C",
                        icon:
                            hourlyForecast['weather'][0]['main'] == "Clouds" ||
                                hourlyForecast['weather'][0]['main'] == "Rain"
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),

                //spacer
                const SizedBox(
                  height: 20,
                ),

                // Bottom Text
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                //spacer
                const SizedBox(
                  height: 16,
                ),

                // Bottom List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
