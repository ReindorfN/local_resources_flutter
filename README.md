# local_resources_flutter

A new Flutter project.

## Getting Started

This application is aimed at providing resources and tutorials on implementing local resources in flutter.

This project starts with an android version and thus, will focus on implementing android local resources. 

Future versions might cater for and include resource implementation on iOS for iphones.

*NB:* This is for my mobile application development class.

## Environment Setup

### Firebase Configuration

1. Create a `.env` file in the project root:
   ```bash
   cp .env.example .env
   ```
   Then fill in your Firebase configuration values.

2. For iOS development:
   ```bash
   cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
   ```
   Then replace the placeholder values with your Firebase iOS configuration.

### Running the App

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```
