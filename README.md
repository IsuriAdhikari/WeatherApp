# WeatherApp
Weather Application for interview

Weather application for displaying current weather conditions of added cities

email - isuriadhikari@gmail.com
API key for weather API = '87507141cb9843fb9ec135229250502'

# Weather App
A Flutter application that fetches and displays the current weather of cities using data from a weather API.

## 🛠️ Features
- **Current Weather Display:** Allows users to view the current weather of any city.

- **Add Cities:** Users can add a city to display its current weather.

- **City Deletion:** Allows users to delete any of the cities they’ve added.

- **Sliding View to Delete:** Swipe left on a city to delete it from the list.

- **Weather Forecast:** Displays a weather forecast for the next few days for each city added.

- **API Integration:** Fetches live weather data from WeatherAPI.

- **UI:** Uses Material UI for the application's design.

- **State Management:** Manages state using the Provider package for consistent data across the app.

- **Local Persistence**: Saves the list of added cities locally for offline access.

- **User-Friendly UI**: Simple and intuitive interface for users to add, view, and remove cities.

## 📝 Getting Started
Follow these instructions to set up and run the project on your local machine.

### 🎯 Prerequisites
- **Flutter SDK:** Ensure you have Flutter installed. [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Dart SDK:** Comes bundled with Flutter.
- **CocoaPods:** Required for iOS builds.

### 🛠️ Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/IsuriAdhikari/WeatherApp.git
   cd weather_app

2. For iOS get install  PODS before run the application
   cd iOS
   pod install


### 🧪 Tests
Unit Tests: Implements unit tests to verify the correctness of weather data fetching and UI updates.
Widget Tests: Ensures the UI responds properly to user actions like adding and deleting cities.
