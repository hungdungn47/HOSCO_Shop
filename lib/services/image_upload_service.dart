// import 'dart:convert';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class ImageUploadService {
//   final ImagePicker _picker = ImagePicker();

//   // Pick Image from Gallery or Camera
//   Future<File?> pickImage({required bool fromCamera}) async {
//     final pickedFile = await _picker.pickImage(
//       source: fromCamera ? ImageSource.camera : ImageSource.gallery,
//     );
//     if (pickedFile != null) {
//       return File(pickedFile.path);
//     }
//     return null;
//   }

//   // Upload Image to Firebase Storage
//   Future<String?> uploadImage(File imageFile) async {
//     try {
//       // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       // Reference storageRef = FirebaseStorage.instance.ref().child("uploads/$fileName.jpg");
//       //
//       // // Upload file
//       // await storageRef.putFile(imageFile);

//       // Get download URL
//       // String downloadUrl = await storageRef.getDownloadURL();
//       // return downloadUrl;
//       final url = Uri.parse('https://api.cloudinary.com/v1_1/dan6wlrgq/upload');
//       final request = http.MultipartRequest('POST', url)
//         ..fields['upload_preset'] = 'ml_default'
//         ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

//       final response = await request.send();
//       if (response.statusCode == 200) {
//         final responseData = await response.stream.toBytes();
//         final responseString = String.fromCharCodes(responseData);
//         final jsonMap = jsonDecode(responseString);
//         final imageUrl = jsonMap['url'];
//         print('URL: ${imageUrl}');
//         return imageUrl;
//       } else {
//         print('Status code: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print("Upload error: $e");
//       return null;
//     }
//   }

//   // Save Image URL Locally
//   Future<void> saveImageUrlLocally(String url) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('uploaded_image_url', url);
//   }

//   // Get Saved Image URL
//   Future<String?> getSavedImageUrl() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('uploaded_image_url');
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();

  // Show dialog to choose image source
  Future<File?> pickImageWithDialog(BuildContext context) async {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Image Source"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(await pickImage(fromCamera: true));
              },
              child: Text("Camera"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(await pickImage(fromCamera: false));
              },
              child: Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  // Pick Image from Gallery or Camera
  Future<File?> pickImage({required bool fromCamera}) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<Map<String, dynamic>> getGeminiResponseToImage(File image) async {
    final Gemini gemini = Gemini.instance;
    var logger = Logger();

    try {
      var value = await gemini.prompt(parts: [
        Part.bytes(image.readAsBytesSync()),
        Part.text(
            "Khai báo thông tin sản phẩm này: productId, productName, category, unit, wholesalePrice, retailPrice, description. Trả về dạng JSON, dùng tiếng Việt. Chỉ trả 1 JSON object duy nhất và không nói thêm gì khác, sao cho tôi có thể lấy câu trả lời làm kết quả JSON luôn. Đừng dùng markdown nhé!")
      ]
          // text:
          // "Khai báo thông tin sản phẩm này: productId, productName, unit, wholesalePrice, retailPrice, description. Trả về dạng JSON",
          // images: [image.readAsBytesSync()]
          );

      var res = value?.output ?? '';
      res = res.substring(7, res.length - 4);
      logger.d(res);
      print(res);
      return {"success": true, "data": jsonDecode(res)};
    } catch (e) {
      logger.e('Error gemini', error: e);
      return {"success": false, "error": e.toString()};
    }
  }

  // Upload Image to Firebase Storage
  Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dan6wlrgq/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'ml_default'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        final imageUrl = jsonMap['url'];
        print('URL: $imageUrl');
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
