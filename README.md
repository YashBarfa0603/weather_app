# 🌤️ SkyCast Pro — AI Powered Weather App

A modern Flutter Weather Application that delivers real-time weather updates with AI-based insights, smart recommendations, and enhanced UI using Stitch.

---

## 🚀 Features

- 🌍 Search weather by city or location  
- 📡 Real-time weather data using API  
- 📊 5-day forecast with charts & hourly data  
- 🤖 AI-powered weather briefing  
- 👕 Outfit & activity recommendations  
- 🌗 Dark / Light mode toggle  
- ✨ Glassmorphism UI with gradients  
- 🎨 UI enhanced using Stitch (AI UI optimization tool)  
- 🔄 Pull-to-refresh functionality  

---

## 🧠 Smart AI Features

- Generates natural language weather summaries  
- 👕 Clothing suggestions  
- 🎯 Activity recommendations  
- 😊 Mood & comfort insights  

> These features are implemented using rule-based intelligence in the model layer  

---

## 🎨 UI & Design

- 🧊 Glassmorphism using `BackdropFilter`  
- 🌈 Dynamic gradients based on weather  
- 📱 Clean and responsive layout  
- ⚡ Improved UI/UX using Stitch  

---

## 📸 App Screenshots

<p align="center">
  <img src="assets/screenshots/home.png" width="300"/><br/>
  <b>🏠 Home Screen</b>
</p>

<p align="center">
  <img src="assets/screenshots/forecast.png" width="300"/><br/>
  <b>📊 Forecast & Weather Details</b>
</p>

<p align="center">
  <img src="assets/screenshots/search.png" width="300"/><br/>
  <b>🔍 Search Screen</b>
</p>

<p align="center">
  <img src="assets/screenshots/insights.png" width="300"/><br/>
  <b>🤖 AI Insights</b>
</p>

<p align="center">
  <img src="assets/screenshots/details.png" width="300"/><br/>
  <b>📅 Detailed Forecast</b>
</p>

---

## 🛠️ Tech Stack

- Flutter (Dart)  
- OpenWeatherMap API  
- fl_chart (for graphs)  

---

## 📂 Project Structure

```bash
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

 ## ⚙️ How It Works
User opens the app
App fetches weather data from API
JSON is converted into Dart models
UI updates with:
Weather data
Forecast
AI insights

🔧 Installation
git clone https://github.com/YashBarfa0603/weather_app.git
cd weather_app
flutter pub get
flutter run
🔑 API Setup

Add your API key in:

weather_servic.dart
final String apiKey = "YOUR_API_KEY";
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
