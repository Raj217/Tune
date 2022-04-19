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

  static Future<String?> pick() async {
    /// Allow user to pick files using a file browser
    FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: supportedFileFormats,
        withData: true);

    return file?.paths[0];
  }

  static Future<String?> read({required String fileName}) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String applicationDocumentPath = directory.path;
    String filePath = '$applicationDocumentPath/$fileName';

    File file = File(filePath);
    if (await file.exists()) {
      return file.readAsString();
    }
    return null;
  }

  static Future<String> save(
      {List<int>? fileBytes,
      String? fileContents,
      required String fileName}) async {
    /// Either fileBytes or files should be supplied
    Directory directory = await getApplicationDocumentsDirectory();
    String applicationDocumentPath = directory.path;
    String filePath = '$applicationDocumentPath/$fileName';

    File file = File(filePath);
    if (await file.exists()) {
      file.delete(); // If old file is there delete that to store the new
    }

    if (fileBytes != null) {
      file.writeAsBytes(fileBytes); // For files like of images
    } else if (fileContents != null) {
      file.writeAsString(
          fileContents); // For files like of json for info storing
    }
    return filePath;
  }
}
