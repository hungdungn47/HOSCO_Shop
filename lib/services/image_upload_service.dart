import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();

  // Pick Image from Gallery or Camera
  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Upload Image to Firebase Storage
  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child("uploads/$fileName.jpg");

      // Upload file
      await storageRef.putFile(imageFile);

      // Get download URL
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  // Save Image URL Locally
  Future<void> saveImageUrlLocally(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uploaded_image_url', url);
  }

  // Get Saved Image URL
  Future<String?> getSavedImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uploaded_image_url');
  }
}
