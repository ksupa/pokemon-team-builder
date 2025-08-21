# Pokemon Team Builder

A Flutter mobile application that allows users to create and manage Pokemon teams using real Pokemon data from the PokeAPI. Users can authenticate, search for Pokemon, build teams of up to 6 Pokemon, and save multiple teams to the cloud.

## Features

### Authentication
- User registration and login with Firebase Authentication
- Secure user sessions with automatic logout functionality
- Email/password authentication

### Pokemon Search
- Real-time Pokemon search using the PokeAPI
- Smart filtering with priority matching (starts with query first, then contains)
- Case-insensitive search functionality
- Displays Pokemon with images, names, and type badges with official colors

### Team Building
- Create teams with custom names
- Add up to 6 Pokemon per team
- Visual team slots with drag-and-drop style interface
- Duplicate Pokemon prevention within teams
- Remove Pokemon with confirmation dialogs
- Save partial teams (1-6 Pokemon)

### Cloud Storage
- Multi-tenancy support - each user has their own teams
- Real-time data synchronization with Firebase Realtime Database
- Persistent team storage across devices and sessions
- Team editing and updating capabilities

## API Integration

### PokeAPI Integration
- **Base URL**: `https://pokeapi.co/api/v2/`
- **Pokemon List**: Fetches up to 1000 Pokemon for search functionality. Will add filters to search such as type and generation.
- **Individual Pokemon**: Currently only retrieving the Pokemon sprite, name, and typing. Will add other details such as moveset creation and stat editing.

### Firebase Integration
- **Authentication**: Secure user management with email/password
- **Realtime Database**: NoSQL database for team storage with real-time sync
- **Data Structure**: User-scoped data with automatic multi-tenancy

## Technology Stack

### Frontend
- **Flutter**
- **Dart**
- **Material Design**

### Backend Services
- **Firebase Authentication** - User authentication
- **Firebase Realtime Database** - Cloud data storage
- **PokeAPI** - External API

## Setup Instructions

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Firebase project with Authentication and Realtime Database enabled
- Android Studio or VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pokemon-team-builder
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable Authentication with Email/Password provider
   - Enable Realtime Database in test mode
   - Run Flutter Fire CLI to generate `firebase_options.dart`:
     ```bash
     flutterfire configure
     ```

4. **Enable Developer Mode (If wanting to run it on windows instead of mobile/mobile emulation)**
   - Go to Settings → Privacy & Security → For developers
   - Turn on Developer Mode (required for Firebase plugins)

5. **Run the application**
   ```bash
   flutter run
   ```

## Usage

1. **Getting Started**
   - Register a new account or log in with existing credentials
   - You'll be taken to the dashboard where you can view and manage teams

2. **Creating a Team**
   - Tap the "+" floating action button
   - Enter a team name in the dialog
   - You'll be taken to the team setup screen with 6 empty slots

3. **Adding Pokemon**
   - Tap any empty slot to open the Pokemon search
   - Search for Pokemon by name (supports partial matching)
   - Tap the "Add to Team" button to add Pokemon to your team
   - The "Already Added" state prevents duplicate Pokemon

4. **Managing Teams**
   - Save teams at any completion level (1-6 Pokemon)
   - Edit existing teams by tapping them on the dashboard
   - Remove Pokemon using the red "X" button (with confirmation)
   - Teams are automatically synced to the cloud

## Extra

This project was built as a learning exercise to demonstrate:
- Flutter mobile app development
- Firebase backend integration
- External API consumption
- Clean architecture principles
- Real-time data synchronization

## License

This project is open source and available under the [MIT License](LICENSE).
