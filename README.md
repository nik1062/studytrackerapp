# 📚 FocusFlow - Study Tracker App

A beautiful, modern Flutter application for tracking your study sessions, goals, and achievements with gamification features.

![FocusFlow Banner](https://via.placeholder.com/800x200/667eea/ffffff?text=FocusFlow)

---

## ✨ Features

### 📊 Dashboard
- Real-time study session tracking
- Total study hours display
- Current streak counter
- Quick access to start/stop sessions

### 📚 Subject Management
- Add custom subjects with personalized colors
- Track study time per subject
- Easy subject editing and deletion

### 🎯 Goal Tracking
- Set study goals with target minutes
- Track goal progress with visual indicators
- Mark goals as completed
- Due date management

### 🔥 Heatmap Calendar (GitHub Style)
- Visual representation of daily study intensity
- Color-coded study hours
- Full month view with easy navigation
- Track your consistency over time

### 🧠 Focus Mode
- Full-screen minimal timer interface
- Motivational quotes display
- Soft gradient backgrounds
- Back button disabled during session
- Distraction-free environment

### 🎵 Ambient Sounds
- Rain sound
- Café ambient noise
- White noise option
- Simple toggle controls

### 📈 Smart Insights
- Best study day analysis
- Most studied subject tracking
- Average daily hours calculation
- Detailed streak history

### 🏆 XP & Level System
- 1 hour = 10 XP
- Level up every 100 XP
- Level badge display
- Gamification progress tracking

### 📅 Weekly Challenges
- Set weekly study goals
- Progress tracking
- Badge unlocking system
- Duolingo-style motivation

### 🎨 Beautiful UI
- ✨ Glassmorphism cards with blur effects
- 🌈 Vibrant gradient backgrounds
- 🪄 Smooth animations and transitions
- 🌙 Dark mode support
- 📱 Fully responsive design

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.8 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd application_1
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run -d chrome     # Run on Chrome (Web)
flutter run               # Run on connected device/emulator
```

### Building

```bash
# Build for Android
flutter build apk --release

# Build for Web
flutter build web

# Build for iOS
flutter build ios
```

---

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── achievement.dart     # Achievement model
│   ├── goal.dart            # Goal model
│   ├── study_session.dart   # Study session model
│   ├── subject.dart         # Subject model
│   └── weekly_challenge.dart # Weekly challenge model
├── providers/                # State management
│   ├── achievement_provider.dart
│   ├── app_theme_provider.dart
│   ├── goal_provider.dart
│   ├── study_provider.dart
│   ├── subject_provider.dart
│   └── weekly_challenge_provider.dart
├── screens/                  # App screens
│   ├── achievements_list_screen.dart
│   ├── dashboard_screen.dart
│   ├── focus_screen.dart
│   ├── goal_form_screen.dart
│   ├── goals_list_screen.dart
│   ├── heatmap_screen.dart
│   ├── home_screen.dart
│   ├── insights_screen.dart
│   ├── settings_screen.dart
│   ├── stats_screen.dart
│   ├── subject_form_screen.dart
│   └── subjects_list_screen.dart
├── services/                 # Services
│   ├── audio_service.dart   # Ambient sounds
│   └── hive_service.dart    # Local storage
├── utils/                    # Utilities
└── widgets/                  # Reusable widgets
    ├── glassmorphic_card.dart
    ├── gradient_background.dart
    ├── level_badge.dart
    ├── timer_widget.dart
    └── weekly_challenge_card.dart
```

---

## 🛠️ Tech Stack

- **Framework**: Flutter 3.10.8+
- **State Management**: Provider
- **Local Storage**: Hive (NoSQL database)
- **Charts**: fl_chart
- **Icons**: Material Icons
- **Animations**: Built-in Flutter animations

---

## 📱 Screenshots

| Dashboard | Subjects | Goals | Heatmap |
|-----------|----------|-------|---------|
| ![Dashboard](https://via.placeholder.com/200/667eea/ffffff?text=Dashboard) | ![Subjects](https://via.placeholder.com/200/764ba2/ffffff?text=Subjects) | ![Goals](https://via.placeholder.com/200/f093fb/ffffff?text=Goals) | ![Heatmap](https://via.placeholder.com/200/1a1a2e/ffffff?text=Heatmap) |

---

## 🎯 Key Features Implementation

### Study Session Tracking
```dart
// Start a session
await studyProvider.startStudySession(subjectId);

// End a session
await studyProvider.endStudySession();

// Get total hours
final totalHours = studyProvider.totalStudyHours;
```

### XP & Level System
```dart
// Calculate XP
int xp = (studyHours * 10).toInt();

// Calculate Level
int level = (xp / 100).floor();
```

### Heatmap Data
```dart
// Get daily study hours
Map<DateTime, double> dailyHours = studyProvider.getWeeklyStudyHours(weekStart);
```

---

## 🎨 Customization

### Theme Colors

Modify in `lib/main.dart`:
```dart
ThemeData(
  primarySwatch: Colors.deepPurple,
  // ... other properties
)
```

### Glassmorphism Cards

Use the `GlassmorphicCard` widget:
```dart
GlassmorphicCard(
  child: YourContent(),
)
```

### Gradient Backgrounds

Use the `GradientBackground` widget:
```dart
GradientBackground(
  child: YourScreenContent(),
)
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

---

## 📄 License

This project is licensed under the MIT License.

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📧 Contact

- **Developer**: [Your Name]
- **Email**: [your.email@example.com]
- **GitHub**: [github.com/yourusername]

---

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [Hive Database](https://pub.dev/packages/hive)
- [fl_chart](https://pub.dev/packages/fl_chart)

---

**⭐ Star this repo if you found it helpful!**
