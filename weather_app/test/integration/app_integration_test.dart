import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/main.dart' as app;
import 'package:weather_app/providers/MockWeatherProvider%20.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/add_city_screen.dart';
import 'package:weather_app/screens/city_weather_screen.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/screens/splash_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize the sqflite_common_ffi database factory
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Splash screen navigates to Home screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that the SplashScreen is displayed
      expect(find.byType(SplashScreen), findsOneWidget);

      // Wait for the splash screen to navigate to the home screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify that the HomeScreen is displayed
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Add a city and verify it appears in the list',
        (WidgetTester tester) async {
      // Create a mock WeatherProvider
      final mockWeatherProvider = MockWeatherProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherProvider>.value(
                value: mockWeatherProvider),
          ],
          child: MaterialApp(
            home: HomeScreen(),
            routes: {
              '/add-city': (context) => AddCityScreen(),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the floating action button to navigate to the AddCityScreen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify that the AddCityScreen is displayed
      expect(find.byType(AddCityScreen), findsOneWidget);

      // Enter a city name in the text field
      await tester.enterText(find.byType(TextField), 'New York');
      await tester.pump();

      // Tap the "Add City" button
      await tester.tap(find.text('Add City'));
      await tester.pumpAndSettle();

      // Verify that the HomeScreen is displayed and the city is added
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(mockWeatherProvider.cities.length, 1);
      expect(mockWeatherProvider.cities.first.name, 'New York');
    });

    testWidgets('Tap on a city to view its weather details',
        (WidgetTester tester) async {
      // Create a mock WeatherProvider
      final mockWeatherProvider = MockWeatherProvider();
      await mockWeatherProvider.addCity('London');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherProvider>.value(
                value: mockWeatherProvider),
          ],
          child: MaterialApp(
            home: HomeScreen(),
            routes: {
              '/city-weather': (context) =>
                  CityWeatherScreen(weather: mockWeatherProvider.cities.first),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the city item
      await tester.tap(find.text('London'));
      await tester.pumpAndSettle();

      // Verify that the CityWeatherScreen is displayed with the correct weather details
      expect(find.byType(CityWeatherScreen), findsOneWidget);
    });

    testWidgets('Delete a city from the list', (WidgetTester tester) async {
      // Create a mock WeatherProvider
      final mockWeatherProvider = MockWeatherProvider();
      await mockWeatherProvider.addCity('Paris');

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherProvider>.value(
                value: mockWeatherProvider),
          ],
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the city appears in the list
      expect(find.text('Paris'), findsOneWidget);

      // Ensure that the Dismissible widget is ready
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Check if the city exists before trying to swipe it
      mockWeatherProvider.cities.firstWhere(
        (city) => city.name == 'Paris',
        orElse: () => throw Exception('City not found'),
      );

      // Swipe to delete the city (assuming a Dismissible is used)
      await tester.drag(find.text('Paris'), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      // Verify that the city has been removed
      expect(find.text('Paris'), findsNothing);
      expect(mockWeatherProvider.cities.isEmpty, true);
    });
  });
}
