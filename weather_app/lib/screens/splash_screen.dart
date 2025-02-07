import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> navigateToHome() async {
      // Ensure any initialization is complete before navigating
      final weatherProvider =
          Provider.of<WeatherProvider>(context, listen: false);
      await weatherProvider.fetchAndSetCities();

      Navigator.pushReplacementNamed(context, '/home');
    }

    // Navigate after a delay and initialization
    Future.delayed(Duration(seconds: 3), navigateToHome);

    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 248, 220, 129),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/spashIcon.svg',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Weather App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
