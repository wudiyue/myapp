import 'dart:io';
import 'dart:developer' as developer;

Future<List<String>> getApkFilePaths(String directoryPath) async {
  try {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      developer.log('Directory does not exist: $directoryPath', name: 'ApkManager', level: 900); // WARNING
      return [];
    }

    final files = await directory.list().where((file) => file.path.endsWith('.apk')).toList();
    developer.log('Found ${files.length} APK files in $directoryPath', name: 'ApkManager');
    return files.map((file) => file.path).toList();
  } catch (e) {
    developer.log('Error reading APK files: $e', name: 'ApkManager', level: 1000); // SEVERE
    return [];
  }
}