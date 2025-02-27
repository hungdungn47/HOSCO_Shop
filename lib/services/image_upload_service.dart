import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
      // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Reference storageRef = FirebaseStorage.instance.ref().child("uploads/$fileName.jpg");
      //
      // // Upload file
      // await storageRef.putFile(imageFile);

      // Get download URL
      // String downloadUrl = await storageRef.getDownloadURL();
      // return downloadUrl;
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dan6wlrgq/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'ml_default'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      if(response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        final imageUrl = jsonMap['url'];
        print('URL: ${imageUrl}');
        return imageUrl;
      } else {
        print('Status code: ${response.statusCode}');
        return null;
      }
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
