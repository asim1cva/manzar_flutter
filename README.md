# 📺 MANZAR - Premium IPTV Player

[![Flutter Version](https://img.shields.io/badge/Flutter-3.9.2-blue.svg)](https://flutter.dev)
[![GetX State Management](https://img.shields.io/badge/State-GetX-purple.svg)](https://pub.dev/packages/get)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Windows-lightgrey.svg)](#)

**MANZAR** is a high-performance, open-source IPTV player built with Flutter. It offers a premium, modern UI/UX designed for seamless live streaming, playlist management, and channel discovery. Powered by the reactive **GetX** framework, MANZAR ensures lightning-fast performance and a butter-smooth user experience.

---

## 📸 Screenshots

<div align="center">
  <table>
    <tr>
      <td align="center"><b>🏠 Home Dashboard</b></td>
      <td align="center"><b>🎬 Live Playback</b></td>
      <td align="center"><b>📂 Categories</b></td>
    </tr>
    <tr>
      <td><img src="assets/screenshots/home_screen.png" width="280"></td>
      <td><img src="assets/screenshots/video_player.png" width="280"></td>
      <td><img src="assets/screenshots/groups_screen.png" width="280"></td>
    </tr>
  </table>
</div>

---

## ✨ Key Features

- 🎨 **Premium Aesthetic**: Modern dark-themed interface with smooth transitions and glassmorphism elements.
- 🚀 **Reactive Core**: Entirely built on **GetX** for high-speed state management and efficient memory usage.
- 📊 **Smart Playlist Parsing**: Supports `.m3u` and `.m3u8` formats with intelligent metadata extraction.
- 🌍 **Curated Discovery**: Includes built-in access to globally curated public IPTV streams.
- 🔍 **Global Search**: Find any channel instantly across all your playlists.
- 📁 **Group Organization**: Automatically categorizes channels into groups (Movies, Sports, News, etc.).
- ❤️ **Favorites & History**: Save your top channels and quickly resume where you left off.
- 🎛️ **Advanced Controls**: Aspect ratio switching (16:9, 4:3, Actual), volume management, and custom headers for stream compatibility.

---

## 🏗️ Project Architecture

MANZAR follows a clean **MVC-style pattern** powered by GetX:

```text
lib/
├── controllers/    # Business logic & State management (GetX)
├── models/         # Data structures (Channel, Playlist)
├── services/       # Network & API services (M3U Parsing)
├── screens/        # UI Layers (Home, Player, Settings)
├── utils/          # Constants, Themes & Helpers
└── widgets/        # Reusable UI components
```

---

## 🛠️ Technology Stack

| Library               | Purpose                                             |
| :-------------------- | :-------------------------------------------------- |
| **GetX**              | State Management, Navigation & Dependency Injection |
| **Chewie**            | High-level Video Player Controller                  |
| **Video Player**      | Low-level Video API                                 |
| **HTTP**              | Remote Playlist Fetching                            |
| **SharedPreferences** | Offline Persistent Storage                          |
| **UUID**              | Unique Data Identification                          |
| **Google Fonts**      | Premium Typography (Inter)                          |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- An IDE (VS Code, Android Studio) with Flutter extensions.

### Installation Roadmap

1. **Clone the Repo**

   ```bash
   git clone https://github.com/your-username/manzar_flutter.git
   cd manzar_flutter
   ```

2. **Get Dependencies**

   ```bash
   flutter pub get
   ```

3. **Run for the first time**

   ```bash
   # For Android/iOS
   flutter run

   # For Windows
   flutter run -d windows
   ```

---

## 📜 Disclaimer

**Disclaimer**: MANZAR is strictly a media player application. It **does not provide**, host, or include any media content, channels, or playlists of its own. Users are solely responsible for providing their own content (M3U playlists). The included public links are for demonstration purposes only.

---

<p align="center">Made with ❤️ for the Flutter Community</p>
