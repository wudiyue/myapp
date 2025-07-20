import 'dart:io';
import 'dart:developer' as developer;

class ApkManager {
  final String apkFolderPath;

  ApkManager(this.apkFolderPath);

  Future<List<File>> getApkFiles() async {
    final apkDir = Directory(apkFolderPath);
    if (!await apkDir.exists()) {
      developer.log('APK folder not found: $apkFolderPath', name: 'ApkManager', level: 800); // INFO
      return [];
    }
    final files = await apkDir.list().toList();
    List<File> apkFiles = [];
    for (var file in files) {
      if (await file.stat().then((stat) => stat.type == FileSystemEntityType.file) && file.path.endsWith('.apk')) {
        apkFiles.add(file as File);
      }
    }
    return apkFiles;
  }
}