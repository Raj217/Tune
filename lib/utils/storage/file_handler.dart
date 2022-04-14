import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  static List<String> supportedFileFormats = [
    'm4a',
    'mp3',
    'wav',
  ];

  static Future<String?> pick() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: supportedFileFormats,
        withData: true);

    return file?.paths[0];
  }

  static Future<String> save(
      {List<int>? fileBytes,
      String? fileContents,
      required String fileName}) async {
    /// Either fileBytes should be supplied or files
    Directory directory = await getApplicationDocumentsDirectory();
    String applicationDocumentPath = directory.path;
    String filePath = '$applicationDocumentPath/$fileName';
    File file = File(filePath);
    if (await file.exists()) {
      file.delete();
    }

    if (fileBytes != null) {
      file.writeAsBytes(fileBytes);
    } else if (fileContents != null) {
      file.writeAsString(fileContents);
    }
    return filePath;
  }
}
