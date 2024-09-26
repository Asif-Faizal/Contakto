import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'contactor_method_channel.dart';


abstract class ContactFetcherPlatform extends PlatformInterface {
  ContactFetcherPlatform() : super(token: _token);

  static final Object _token = Object();
  static ContactFetcherPlatform _instance = MethodChannelContactFetcher();
  static ContactFetcherPlatform get instance => _instance;
  static set instance(ContactFetcherPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}