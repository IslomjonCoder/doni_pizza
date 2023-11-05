import 'dart:io';

import 'package:image_picker/image_picker.dart';

class THelperFunctions {
  static Future<File?> getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return (pickedFile != null) ? File(pickedFile.path) : null;
  }
}
