import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/screens/splash_screen.dart';

Future<bool> isFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final firstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  if (firstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
  }
  return firstLaunch;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final WeatherProvider weatherProvider = WeatherProvider();
  final firstLaunch = await isFirstLaunch();

  if (firstLaunch) {
    // Save the API key securely during the first launch
    await weatherProvider.saveApiKey('87507141cb9843fb9ec135229250502');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => weatherProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.amber,
          selectionHandleColor: Colors.amber,
          selectionColor: Colors.amber,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), // Splash screen
        '/home': (context) => const HomeScreen(), // Home screen
      },
    );
  }
}
