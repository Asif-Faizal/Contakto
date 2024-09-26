# `Contactor` - Flutter Plugin for Fast Contact Fetching

**Contactor** is a powerful and fast Flutter plugin designed to fetch contacts directly from the device. It provides a seamless and efficient way to retrieve names and phone numbers, making it ideal for apps that require quick access to a user's contact list.

### Features:
- 🚀 **Fastest contact fetching** on both Android and iOS platforms.
- 🔒 Handles runtime permissions smoothly with minimal code.
- 📱 Retrieves contacts with names and phone numbers.
- 🛠 Simple and easy-to-use API integration.
- 📦 Optimized for performance and reliability.

### Installation:
Add contactor to your `pubspec.yaml`:
```yaml
dependencies:
  contactor: latest_version
```

## Usage:
Fetch contacts with just a few lines of code:
```dart
List<Map<String, String>> contacts = await ContactFetcher.getContacts();
```

## Permissions:
Ensure to include the necessary permissions in your Android `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.READ_CONTACTS"/>
```
For iOS, add the following to your `Info.plist`:
```xml
<key>NSContactsUsageDescription</key>
<string>We need access to your contacts to improve your experience</string>
```

## Platform Support:

### ✅ Android
### ✅ iOS

## Contributions:
Feel free to open issues and contribute to the project! We're always looking to improve and add more features.