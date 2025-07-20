import 'package:flutter/services.dart';
import 'dart:developer' as developer;

class ApkInstaller {
  static const MethodChannel _channel = MethodChannel('com.example.myapp/apk_installer');

  Future<String> installApk(String apkPath) async {
    try {
      final String result = await _channel.invokeMethod('installApk', {'apkPath': apkPath});
      developer.log('APK installation result: $result', name: 'ApkInstaller');
      return result;
    } on PlatformException catch (e) {
      developer.log('Failed to install APK: ${e.message}', name: 'ApkInstaller', level: 1000); // SEVERE
      return 'Failed to install APK: ${e.message}';
    }
  }

  Future<String> automateLogin(String email, String password) async {
    try {
      final String result = await _channel.invokeMethod('automateLogin', {'email': email, 'password': password});
      developer.log('Automated login result: $result', name: 'ApkInstaller');
      return result;
    } on PlatformException catch (e) {
      developer.log('Failed to automate login: ${e.message}', name: 'ApkInstaller', level: 1000); // SEVERE
      return 'Failed to automate login: ${e.message}';
    }
  }
}