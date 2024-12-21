# DevUp - Campus Navigation & Discovery Platform

[![Flutter Version](https://img.shields.io/badge/flutter-%3E%3D3.0.0-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

DevUp is a modern, feature-rich Flutter application designed to enhance the campus experience by providing an interactive map interface for discovering hostels, facilities, and events around the campus area.
 
## 🌟 Features

### 🗺️ Interactive Map
- Real-time location tracking
- Custom markers for hostels, facilities, and events
- Smooth animations and transitions
- Layer toggles for different types of locations
- Route visualization with OSRM integration

### 🏨 Hostels
- Comprehensive hostel information
- Availability status
- Capacity details
- Contact information
- Administrator details
- Service listings

### 🏢 Facilities
- Various facility types (sports clubs, tourist agencies, museums, etc.)
- Business hours
- Ratings and reviews
- Contact information
- Service descriptions

### 📅 Events
- Upcoming event listings
- Event details and descriptions
- Location information
- Date and time
- Registration status
- Check-in and check-out

### 💬 Travel Assistant
- AI-powered chat interface
- Location-based recommendations
- Real-time assistance
- Powered by Google's Gemini API

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Google Gemini API key
- OSRM server (for routing)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/mohamadlounnas/devup-bsc.git
cd devup-bsc
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure environment variables:
this step is not required for now
Create a `.env` file in the root directory and add:
```env
POCKETBASE_URL=your_pocketbase_url
GEMINI_API_KEY=your_gemini_api_key
OSRM_SERVER_URL=your_osrm_server_url
```

4. Run the app:
```bash
flutter run
```

## 📱 App Structure

```
lib/
├── models/          # Data models
├── screens/         # UI screens
├── widgets/         # Reusable widgets
├── services/        # API services
├── providers/       # State management
└── utils/          # Helper functions
```

## 🔧 Configuration

### PocketBase Setup
1. Set up your PocketBase server
2. Create the following collections:
   - hostels
   - facilities
   - events
   - users

### Map Configuration
- The map is centered on Boumerdes, Algeria by default
- Default zoom level: 13.0
- Supports zoom range: 3.0 - 18.0

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI framework
- [PocketBase](https://pocketbase.io/) - Backend service
- [OpenStreetMap](https://www.openstreetmap.org/) - Map data
- [OSRM](http://project-osrm.org/) - Routing engine
- [Google Gemini](https://cloud.google.com/vertex-ai) - AI capabilities

## 📞 Support

For support, email mohamed@physia.dev

---
Made with ❤️ by the BAZOKA Team
