import 'dart:io';

import 'package:dc_universal_emot/constants/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

@lazySingleton
class FileService {
  /// Save image to application documents directory,
  /// returning new path of the saved image.
  /// Optional [prefixName] parameter to add prefix name to the saved image,
  /// useful for identifying or avoiding duplicate file name.
  Future<String> saveImage(
    String imagePath, {
    String? prefixName,
    int savedImageHeight = 50,
  }) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final documentsPath = path.join(documentsDirectory.path, APPLICATION_DIR_NAME);

    if (!Directory(documentsPath).existsSync()) {
      Directory(documentsPath).createSync(recursive: true);
    }

    final originalFileName = path.basename(imagePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueFileName = '${prefixName ?? ''}-$timestamp-$originalFileName';
    final newPath = path.join(documentsPath, uniqueFileName);

    // Load the original image
    final originalImageBytes = await File(imagePath).readAsBytes();
    img.Image? originalImage = img.decodeImage(originalImageBytes);

    // TODO: dont resize the image if the image is already small
    // Resize the image while maintaining the aspect ratio
    img.Image resizedImage = img.copyResize(
      originalImage!,
      height: savedImageHeight,
      interpolation: img.Interpolation.cubic,
    );

    // Save the resized image
    await File(newPath).writeAsBytes(img.encodePng(resizedImage));

    return newPath;
  }

  Future<void> deleteImage(String imagePath) async {
    await File(imagePath).delete();
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

  static String getFileName(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }
}
