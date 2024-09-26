import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'contactor_platform_interface.dart';

/// An implementation of [ContactFetcherPlatform] that uses method channels.
class MethodChannelContactFetcher extends ContactFetcherPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('contact_fetcher');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}