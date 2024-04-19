import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileServices {
  Future<File?> getLocalImage(String path) async {
    return File(path);
  }

  Future<bool> saveImage(File file, String path) async {
    try {
      await file.copy(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<File>?> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );

    if (result != null) {
      if (result.files.isEmpty) return null;
      return result.paths.map((path) => File(path!)).toList();
    }

    return null;
  }

  Future<File?> pickSingleImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      if (result.files.isEmpty) return null;
      return File(result.files.first.path!);
    }

    return null;
  }
}
