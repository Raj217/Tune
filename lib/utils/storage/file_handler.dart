/// Handle All local storage related tasks

import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  static List<String> supportedFileFormats = [
    // TODO: Add for mp4
    'm4a',
    'mp3',
    'wav',
  ];

  static Future<String> _getFilePath(String fileName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String applicationDocumentPath = directory.path;
    return '$applicationDocumentPath/$fileName';
  }

  static Future<bool> fileExists(String fileName) async {
    File file = File(await _getFilePath(fileName));
    return await file.exists();
  }

  static Future<double> getFileSize(
      {String? fileName, String? filePath}) async {
    /// Either the fileName or the filePath must be provided
    /// In case of fileName, the file will be assumed to be in the application documents directory
    File file;
    if (fileName != null) {
      file = File(await _getFilePath(fileName));
    } else {
      file = File(filePath!);
    }

    if (await file.exists()) {
      int sizeInBytes = file.lengthSync();
      return sizeInBytes / (1024 * 1024);
    }
    return 0;
  }

  static Future<void> delete(String fileName) async {
    File file = File(await _getFilePath(fileName));
    if (await file.exists()) {
      file.delete();
    }
  }

  static Future<void> createFolder(String folderName) async {
    Directory dir = Directory(await _getFilePath(folderName));
    if (!(await dir.exists())) {
      await dir.create();
    }
    return;
  }

  static Future<void> deleteFolder(String folderName) async {
    Directory dir = Directory(await _getFilePath(folderName));
    if (!(await dir.exists())) {
      dir.deleteSync();
    }
  }

  /// [file] : is the type of file to pick a file or a folder
  static Future<List<String?>?> pick({file = true}) async {
    if (file) {
      /// Allow user to pick files using a file browser
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
        dialogTitle: 'Select a song',
        withData: true,
      );

      return file?.paths;
    } else {
      String? folder = await FilePicker.platform.getDirectoryPath();
      if (folder != null) {
        Directory dir = Directory(folder);
        return dir
            .listSync() // TODO: Add to settings for recursion
            .map((FileSystemEntity file) => file.path)
            .where((element) => supportedFileFormats
                .contains(element.substring(element.length - 3)))
            .toList();
      }
    }
  }

  static Future<String> read({required String fileName}) async {
    File file = File(await _getFilePath(fileName));
    if (await file.exists()) {
      return file.readAsString();
    }
    return '[]';
  }

  static Future<String> save(
      {List<int>? fileBytes,
      String? fileContents,
      required String fileName}) async {
    /// Either fileBytes or files should be supplied
    String filePath = await _getFilePath(fileName);

    File file = File(filePath);

    if (fileBytes != null) {
      if (await file.exists()) {
        file.delete(); // If old file is there delete that to store the new
      }
      file.writeAsBytes(fileBytes); // For files like of images
    } else if (fileContents != null) {
      if (await file.exists()) {
        file.delete(); // If old file is there delete that to store the new
      }
      file.writeAsString(
          fileContents); // For files like of json for info storing
    }
    return filePath;
  }
}
