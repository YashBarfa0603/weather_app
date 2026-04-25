🌤️ SkyCast Pro — AI Powered Weather App

A modern Flutter Weather Application that delivers real-time weather updates with AI-based insights, smart recommendations, and enhanced UI using Stitch.

🚀 Features
🌍 Search weather by city or location
📡 Real-time weather data using API
📊 5-day forecast with charts & hourly data
🤖 AI-powered weather briefing
👕 Outfit & activity recommendations
🌗 Dark / Light mode toggle
✨ Glassmorphism UI with gradients
🎨 UI enhanced using Stitch (AI UI optimization tool)
🔄 Pull-to-refresh functionality
🧠 Smart AI Features
Generates natural language weather summaries
Provides:
👕 Clothing suggestions
🎯 Activity recommendations
Displays mood & comfort insights

These features are implemented using rule-based intelligence in the model layer

🎨 UI & Design
🧊 Glassmorphism design using BackdropFilter
🌈 Dynamic gradients based on weather conditions
🎯 Clean, modern, and responsive layout
⚡ Improved UI/UX using Stitch for better visual consistency and layout refinement
🛠️ Tech Stack
Flutter (Dart)
REST API — OpenWeatherMap
Custom UI system (Glass + Gradients)
fl_chart for data visualization
📂 Project Structure
lib/
├── main.dart
├── theme.dart
├── model/
│   ├── weather_model.dart
│   └── forecast_model.dart
├── services/
│   └── weather_servic.dart
├── widgets/
│   ├── glass_card.dart
│   ├── weather_metric_card.dart
│   ├── hourly_forecast.dart
│   ├── sun_arc.dart
│   ├── temperature_chart.dart
│   └── outfit_card.dart
└── screens/
    ├── homepage.dart
    ├── search_screen.dart
    └── insights_screen.dart
⚙️ How It Works
User opens the app
App fetches weather data via API
JSON is parsed into Dart models
UI updates dynamically with:
Weather info
Forecast
AI insights
🔧 Installation & Setup
git clone https://github.com/YashBarfa0603/weather_app.git
cd weather_app
flutter pub get
flutter run
🔑 API Setup
Get API key from OpenWeatherMap
Add inside:
weather_servic.dart
final String apiKey = "YOUR_API_KEY";
📊 Core Modules
Module	Description
WeatherServices	API integration
WeatherModel	Data + AI logic
ForecastModel	Forecast processing
Homepage	Main UI
InsightsScreen	AI insights
Widgets	Reusable components
🔮 Future Improvements
📍 Auto location detection
🔔 Weather alerts
🗺️ Map integration
📅 Extended forecasts
👨‍💻 Author

Yash Barfa
GitHub: https://github.com/YashBarfa0603

⭐ Support

If you like this project, give it a ⭐ on GitHub!
