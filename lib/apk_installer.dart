import 'package:flutter/services.dart';

class ApkInstaller {
  static const MethodChannel _channel = MethodChannel('com.your_app_name/apk_installer');

  Future<void> installApk(String apkFilePath) async {
    try {
      await _channel.invokeMethod('installApk', {'apkFilePath': apkFilePath});
    } on PlatformException catch (e) {
      print("Failed to install APK: ${e.message}");
    }
  }
}