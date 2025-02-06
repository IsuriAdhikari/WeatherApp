import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import './add_city_screen.dart';
import './city_weather_screen.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure cities are fetched once the frame is built
      Provider.of<WeatherProvider>(context, listen: false).fetchAndSetCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('City Weather')),
      body: weatherProvider.cities.isEmpty
          ? const Center(child: Text('No cities added yet.'))
          : ListView.builder(
              itemCount: weatherProvider.cities.length,
              itemBuilder: (context, index) {
                final city = weatherProvider.cities[index];

                return Dismissible(
                  key: Key(city.name),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Only proceed if there are cities in the list
                    if (weatherProvider.cities.isNotEmpty) {
                      weatherProvider.removeCity(index);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${city.name} deleted!')),
                      );
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (weatherProvider.cities.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CityWeatherScreen(
                              weather: city,
                            ),
                          ),
                        );
                      }
                    },
                    child: WeatherCard(weather: city),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 248, 220, 129),
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to AddCityScreen when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCityScreen()),
          );
        },
      ),
    );
  }
}
