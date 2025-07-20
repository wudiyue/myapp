import 'package:flutter/services.dart';
import 'dart:developer' as developer;

class ApkInstaller {
  static const MethodChannel _channel = MethodChannel('com.your_app_name/apk_installer');

  Future<void> installApk(String apkFilePath) async {
    try {
      await _channel.invokeMethod('installApk', {'apkFilePath': apkFilePath});
    } on PlatformException catch (e) {
      developer.log('Failed to install APK: ${e.message}', name: 'ApkInstaller', level: 900); // WARNING
    }
  }
}