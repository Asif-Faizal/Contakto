import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactFetcher {
  static MethodChannel channel = const MethodChannel('contact_fetcher');

  static Future<List<Map<String, String>>> getContacts() async {
    if (await _requestPermission()) {
      try {
        final List<dynamic> contacts = await channel.invokeMethod('getContacts');
        return contacts.map((contact) {
          return Map<String, String>.from(contact as Map);
        }).toList();
      } on PlatformException catch (e) {
        print('Failed to fetch contacts: ${e.message}');
        return [];
      }
    } else {
      print('Permission not granted');
      return [];
    }
  }

  static Future<bool> _requestPermission() async {
    PermissionStatus status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }
    print('Permission status: $status');
    return status.isGranted;
  }
}