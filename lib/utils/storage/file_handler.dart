import 'package:file_picker/file_picker.dart';

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
}
