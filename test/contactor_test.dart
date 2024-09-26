import 'package:contactor/contactor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';

// Import the generated mock classes
import 'package:mockito/annotations.dart';

import 'contactor_test.mocks.dart';

// Mocking the MethodChannel for permission handler
@GenerateMocks([MethodChannel])
void main() {
  // Ensure bindings are initialized for test
  TestWidgetsFlutterBinding.ensureInitialized();

  // Create the mock instances
  late MockMethodChannel mockMethodChannel;
  const MethodChannel permissionChannel = MethodChannel('flutter.baseflow.com/permissions/methods');

  setUp(() {
    mockMethodChannel = MockMethodChannel();
    ContactFetcher.channel = mockMethodChannel;

    // Mock the permission handler's MethodChannel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      permissionChannel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'checkPermissionStatus') {
          // Mock permission status, return 'granted'
          return PermissionStatus.granted.index;
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        permissionChannel, null);
  });

  group('ContactFetcher', () {
    test('should fetch contacts if permission is granted', () async {
      // Arrange
      when(mockMethodChannel.invokeMethod('getContacts')).thenAnswer((_) async => [
            {'name': 'John Doe', 'number': '1234567890'}
          ]);

      // Act
      final contacts = await ContactFetcher.getContacts();

      // Assert
      expect(contacts, isNotEmpty);
      expect(contacts.first['name'], 'John Doe');
      expect(contacts.first['number'], '1234567890');
    });

    test('should return an empty list if an exception occurs', () async {
      // Arrange
      when(mockMethodChannel.invokeMethod('getContacts')).thenThrow(PlatformException(code: 'ERROR'));

      // Act
      final contacts = await ContactFetcher.getContacts();

      // Assert
      expect(contacts, isEmpty);
    });
  });
}