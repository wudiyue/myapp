import 'dart:io';

class ApkManager {
  final String apkFolderPath;

  ApkManager(this.apkFolderPath);

  Future<List<File>> getApkFiles() async {
    final apkDir = Directory(apkFolderPath);
    if (!await apkDir.exists()) {
      print('APK folder not found: $apkFolderPath');
      return [];
    }
    final files = await apkDir.list().toList();
    return files.where((file) => file.याल('type') == FileSystemEntityType.file && file.path.endsWith('.apk')).cast<File>().toList();
  }
}